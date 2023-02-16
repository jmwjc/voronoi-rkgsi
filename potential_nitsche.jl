using ApproxOperator, TOML

"""
Mesh.Algorithm = 6; // Frontal-Delaunay for 2D meshes
"""

# config = TOML.parsefile("./toml/voronoi_linear.toml")
config = TOML.parsefile("./toml/voronoi_quadratic.toml")
filename = "./msh/square_10.msh"
elements,nodes = ApproxOperator.voronoimsh(filename,config)

nₚ = length(nodes)
# s = 1.5/4 .* ones(nₚ)
s = 2.5/10 .* ones(nₚ)
push!(nodes, :s => s)

# calculate the weights for meshfree node integration
ApproxOperator.set𝑤ᵣₖ!(elements["Ω̃"],nodes)

set𝝭!(elements["Ω"])
set𝝭!(elements["Ω̃"])
set∇̃𝝭!(elements["Ω̃"],elements["Ω"])
set𝝭!(elements["Γᵗ"])
set∇₂𝝭!(elements["Γᵍ"])

cc = check∇₂𝝭(elements["Γᵍ"])
"""
# prescribed variables
"""
r = 2
u(x,y) = (x+y)^r
∂u∂x(x,y) = r*(x+y)^abs(r-1)
∂u∂y(x,y) = r*(x+y)^abs(r-1)
∂²u∂x²(x,y) = r*(r-1)*(x+y)^abs(r-2)
∂²u∂y²(x,y) = r*(r-1)*(x+y)^abs(r-2)
prescribe!(elements["Ω̃"],:b=>(x,y,z)->-∂²u∂x²(x,y)-∂²u∂y²(x,y))
prescribe!(elements["Γᵍ"],:g=>(x,y,z)->u(x,y))
prescribe!(elements["Γᵗ"],:t=>(x,y,z,n₁,n₂)->∂u∂x(x,y)*n₁+∂u∂y(x,y)*n₂)

ops = [
    Operator{:∫∇v∇uvbdxdy}(:k=>1.0),
    Operator{:∫vtdΓ}(),
    Operator{:∫∇𝑛vgds}(:k=>1.0,:α=>1e3),
    Operator{:H₁}(),
]

k = zeros(nₚ,nₚ)
f = zeros(nₚ)
ops[1](elements["Ω̃"],k,f)
ops[2](elements["Γᵗ"],f)
ops[3](elements["Γᵍ"],k,f)

d = k\f

push!(nodes,:d=>d)

set∇₂𝝭!(elements["Ωᵍ"])
prescribe!(elements["Ωᵍ"],:u=>(x,y,z)->u(x,y))
prescribe!(elements["Ωᵍ"],:∂u∂x=>(x,y,z)->∂u∂x(x,y))
prescribe!(elements["Ωᵍ"],:∂u∂y=>(x,y,z)->∂u∂y(x,y))
prescribe!(elements["Ωᵍ"],:∂u∂z=>(x,y,z)->0.0)
H₁,L₂ = ops[4](elements["Ωᵍ"])