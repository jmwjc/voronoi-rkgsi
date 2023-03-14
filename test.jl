using Revise, ApproxOperator, TOML, CairoMakie

config = TOML.parsefile("./toml/voronoi_linear.toml")
filename = "./msh/test_4.msh"
elements,nodes = ApproxOperator.voronoimsh(filename,config)
vor_elms,~ = ApproxOperator.voronoimsh(filename)

nₚ = length(nodes)
s = 2.5/4 .* ones(nₚ)
# s = 2.5/20 .* ones(nₚ)
# push!(nodes, :s₁ => s, :s₂ => s, :s₃ => s)
push!(nodes, :s => s)

ApproxOperator.set𝑤ᵣₖ!(elements["Ω̃"],nodes)


# plot ith element integration points
# red circle: support
# red cross: boundary integration points
# blue xcross: domain integration points
# green star: centroid

f = Figure()

# axis
ax = Axis(f[1, 1])
limits!(ax, -0.1,1.1,-0.1,1.1) 
# limits!(ax, 0,1,0,1) 
hidespines!(ax)
hidedecorations!(ax)
ax.aspect = AxisAspect(1)

# nodes
data = getfield(nodes[1],:data)
x = data[:x][2]
y = data[:y][2]
scatter!(x,y, 
    marker=:circle,
    markersize = 20,
    color = :black
)

# elements
for elm in vor_elms["Ω"]
    x = [x.x for x in elm.𝓒[[1:end...,1]]]
    y = [x.y for x in elm.𝓒[[1:end...,1]]]
    lines!(x,y, linewidth = 1.5, color = :black)
end

# integration points
i = 20
elm = elements["Ω"][i]
x = [xᵢ.x for xᵢ in elm.𝓖]
y = [xᵢ.y for xᵢ in elm.𝓖]
scatter!(x,y, 
    marker=:cross,
    markersize = 10,
    color = :red
)

elm = elements["Ω̃"][i]
x = [xᵢ.x for xᵢ in elm.𝓒]
y = [xᵢ.y for xᵢ in elm.𝓒]
scatter!(x,y, 
    marker=:circle,
    markersize = 10,
    color = :red
)

elm = elements["Ω̃"][i]
x = [xᵢ.x for xᵢ in elm.𝓖]
y = [xᵢ.y for xᵢ in elm.𝓖]
scatter!(x,y, 
    marker=:xcross,
    markersize = 10,
    color = :blue
)

## centroid
x = [elm.𝓖[1].xₘ for elm in elements["Ω̃"]]
y = [elm.𝓖[1].yₘ for elm in elements["Ω̃"]]
scatter!(x,y, 
    marker=:star5,
    markersize = 20,
    color = :green
)

"""
# check 𝑤
"""

elm = elements["Ω̃"][20]
𝓖 = elm.𝓖
m₀₀ = 0.0
m₁₀ = 0.0
m₀₁ = 0.0
m₂₀ = 0.0
m₁₁ = 0.0
m₀₂ = 0.0
for ξ in 𝓖
    global m₀₀ += ξ.𝑤
    global m₁₀ += ξ.x*ξ.𝑤
    global m₀₁ += ξ.y*ξ.𝑤
    global m₂₀ += ξ.x^2*ξ.𝑤
    global m₁₁ += ξ.x*ξ.y*ξ.𝑤
    global m₀₂ += ξ.y^2*ξ.𝑤
end
𝐴 = 𝓖[1].𝐴
e00 = m₀₀ - 𝐴
e10 = m₁₀/𝐴 - 𝓖[1].xₘ
e01 = m₀₁/𝐴 - 𝓖[1].yₘ
e20 = m₂₀/𝐴 - 𝓖[1].m₂₀
e11 = m₁₁/𝐴 - 𝓖[1].m₁₁
e02 = m₀₂/𝐴 - 𝓖[1].m₀₂

# check consistency condition

# set𝝭!(elements["Ω"])
# set𝝭!(elements["Ω̃"])
# set∇̃𝝭!(elements["Ω̃"],elements["Ω"])
# cc = check∇₂𝝭(elements["Ω̃"])
# cc = check𝝭(elements["Ω"][i:i])
# f