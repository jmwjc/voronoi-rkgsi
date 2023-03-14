
using Revise, ApproxOperator, TOML 

config = TOML.parsefile("./toml/test_integration.toml")
filename = "./msh/test_4.msh"
elements,nodes = ApproxOperator.voronoimsh(filename,config)
# vor_elms,~ = ApproxOperator.voronoimsh(filename)

nₚ = length(nodes)
s = 1.5/4*ones(nₚ)
push!(nodes,:s=>s)

set𝝭!(elements["Ω"])

check𝝭(elements["Ω"])

f(x,y) = 1.0

f1 = zeros(nₚ)
f2= zeros(nₚ)
for ap in elements["Ω"]
    xg = ap.𝓖[1]
    𝐴 = xg.𝐴
    N = xg[:𝝭]
    for (i,xᵢ) in enumerate(ap.𝓒)
        I = xᵢ.𝐼
        f1[I] += 𝐴*N[i]*f(xg.x,xg.y)
    end
    I = xg.𝐺
    f2[I] = 𝐴*f(xg.x,xg.y)
end