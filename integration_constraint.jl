using Revise, ApproxOperator, TOML, CairoMakie

# config = TOML.parsefile("./toml/voronoi_linear.toml")
config = TOML.parsefile("./toml/voronoi_quadratic.toml")
filename = "./msh/test_20.msh"
elements,nodes = ApproxOperator.voronoimsh(filename,config)
vor_elms,~ = ApproxOperator.voronoimsh(filename)

nₚ = length(nodes)
# s = 1.5/4 .* ones(nₚ)
s = 2.5/20 .* ones(nₚ)
push!(nodes, :s => s)

ApproxOperator.set𝑤ᵣₖ!(elements["Ω̃"],nodes)

set𝝭!(elements["Ω"])
set𝝭!(elements["Ω̃"])
set∇̃𝝭!(elements["Ω̃"],elements["Ω"])
set𝝭!(elements["Γᵗ"])
set𝝭!(elements["Γᵍ"])

# cc = check∇₂𝝭(elements["Ω̃"])
# cc = check𝝭(elements["Γᵍ"])

# prescribed variables
# Linear integration constraint
# u(x,y) = 1.0
# ∂u∂x(x,y) = 0.0
# ∂u∂y(x,y) = 0.0
# prescribe!(elements["Ω̃"],:p₁=>(x,y,z)->u(x,y))
# prescribe!(elements["Ω̃"],:p₂=>(x,y,z)->0.0)
# prescribe!(elements["Ω̃"],:u=>(x,y,z)->-∂u∂x(x,y))
# prescribe!(elements["Γᵍ"],:u=>(x,y,z,n₁,n₂)->u(x,y)*n₁)
# prescribe!(elements["Ω̃"],:p₁=>(x,y,z)->0.0)
# prescribe!(elements["Ω̃"],:p₂=>(x,y,z)->u(x,y))
# prescribe!(elements["Ω̃"],:u=>(x,y,z)->0.0)
# prescribe!(elements["Γᵍ"],:u=>(x,y,z,n₁,n₂)->u(x,y)*n₂)

# Quadratic integration constraint
prescribe!(elements["Ω̃"],:p₁=>(x,y,z)->x)
prescribe!(elements["Ω̃"],:p₂=>(x,y,z)->0.0)
prescribe!(elements["Ω̃"],:u=>(x,y,z)->-1.0)
prescribe!(elements["Γᵍ"],:u=>(x,y,z,n₁,n₂)->x*n₁)

op_Ω = Operator{:∫∫vᵢpᵢdxdy}()
op_𝑓𝑣 = Operator{:𝑓𝑣}()

fint = zeros(nₚ)
fext = zeros(nₚ)
op_Ω(elements["Ω̃"],fint)
op_𝑓𝑣(elements["Ω̃"],fext)
op_𝑓𝑣(elements["Γᵍ"],fext)

err = fint-fext
