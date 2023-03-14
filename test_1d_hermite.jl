using ApproxOperator

nₚ = 2
L = 1.0
dx = L/(nₚ-1)

# variables in 𝓒
x = [i*dx for i in 0:(nₚ-1)]
s = 1.5*dx*ones(nₚ)

data_𝓒 = Dict([:x=>(1,x),:y=>(1,zeros(nₚ)),:z=>(1,zeros(nₚ)),:s=>( 1,s)])
𝓒 = [Node{(:𝐼,),1}((i,),data_𝓒) for i in 1:nₚ]

# variables in 𝓖
aps = ApproxOperator.ReproducingKernel{:Linear1D,:○,:Constant,:Vor1}[]
data_𝓖 = Dict([:x=>(1,zeros(inte*n))])

for i in 1:nₚ
    if i == 1
        x₁ = x[1]
        x₂ = 0.5*(x[1]+x[2])
    elseif i == nₚ
        x₁ = 0.5*(x[nₚ-1]+x[nₚ])
        x₂ = x[nₚ]
    else
        x₁ = 0.5*(x[i-1]+x[i])
        x₂ = 0.5*(x[i]+x[i+1])
    end
end

# variables in 𝑑
data_𝑑 = Dict([:x=>(1,x),:y=>(1,zeros(nₚ)),:z=>(1,zeros(nₚ)),:s=>( 1,s)])
𝑑 = [Node{(:𝐺,),1}((g,),data_𝐺) for g in 1:nₚ ]

# variables in 𝑠
data_𝑠 = Dict([:])
𝑠 = [Node{(:𝑆,),1}((s,),data_𝑆)  for s in 1:nₚ]


# calculate shape functions