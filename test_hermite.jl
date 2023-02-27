using Revise, ApproxOperator, TOML, CairoMakie

config = TOML.parsefile("./toml/voronoi_linear.toml")
filename = "./msh/test_4.msh"
elements,nodes = ApproxOperator.voronoimsh(filename,config)
vor_elms,~ = ApproxOperator.voronoimsh(filename)

nₚ = length(nodes)
s = 0.8/4 .* ones(nₚ)
# s = 2.5/20 .* ones(nₚ)
# push!(nodes, :s₁ => s, :s₂ => s, :s₃ => s)
push!(nodes, :s => s)


# check consistency condition
# set𝝭ₕ!(elements["Ω"])
set∇𝝭ₕ!(elements["Ω"])
# set∇̃𝝭!(elements["Ω̃"],elements["Ω"])
cc = check∇₂𝝭(elements["Ω"])
# cc = ApproxOperator.check𝝭(elements["Ω"])