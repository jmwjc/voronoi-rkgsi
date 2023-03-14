using Revise, ApproxOperator, CairoMakie

tri_elms, points = ApproxOperator.importmsh("./msh/test_4.msh")
vor_elms, nodes = ApproxOperator.voronoimsh("./msh/test_4.msh")

set𝓖!(vor_elms["Ω"],:SegGI1)

f = Figure()

# axis
ax = Axis(f[1, 1])
limits!(ax, -0.1,1.1,-0.1,1.1) 
# limits!(ax, 0,1,0,1) 
hidespines!(ax)
hidedecorations!(ax)
ax.aspect = AxisAspect(1)

# nodes
data = getfield(points[1],:data)
x = data[:x][2]
y = data[:y][2]
scatter!(x,y, 
    marker=:circle,
    markersize = 20,
    color = :black
)

# elements
for elm in tri_elms["Ω"]
    x = [x.x for x in elm.𝓒[[1:end...,1]]]
    y = [x.y for x in elm.𝓒[[1:end...,1]]]
    lines!(x,y, linewidth = 1.5, color = :black)
end

for elm in vor_elms["Ω"]
    x = [x.x for x in elm.𝓒[[1:end...,1]]]
    y = [x.y for x in elm.𝓒[[1:end...,1]]]
    lines!(x,y, linewidth = 1.5, color = :blue)
end

for elm in vor_elms["Γᵍ"]
    x = [x.x for x in elm.𝓒[[1,2]]]
    y = [x.y for x in elm.𝓒[[1,2]]]
    lines!(x,y, linewidth = 1.5, color = :red)
end

f