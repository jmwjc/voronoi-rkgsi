using ApproxOperator

nā = 2
L = 1.0
dx = L/(nā-1)

# variables in š
x = [i*dx for i in 0:(nā-1)]
s = 1.5*dx*ones(nā)

data_š = Dict([:x=>(1,x),:y=>(1,zeros(nā)),:z=>(1,zeros(nā)),:s=>( 1,s)])
š = [Node{(:š¼,),1}((i,),data_š) for i in 1:nā]

# variables in š
aps = ApproxOperator.ReproducingKernel{:Linear1D,:ā,:Constant,:Vor1}[]
data_š = Dict([:x=>(1,zeros(inte*n))])

for i in 1:nā
    if i == 1
        xā = x[1]
        xā = 0.5*(x[1]+x[2])
    elseif i == nā
        xā = 0.5*(x[nā-1]+x[nā])
        xā = x[nā]
    else
        xā = 0.5*(x[i-1]+x[i])
        xā = 0.5*(x[i]+x[i+1])
    end
end

# variables in š
data_š = Dict([:x=>(1,x),:y=>(1,zeros(nā)),:z=>(1,zeros(nā)),:s=>( 1,s)])
š = [Node{(:šŗ,),1}((g,),data_šŗ) for g in 1:nā ]

# variables in š 
data_š  = Dict([:])
š  = [Node{(:š,),1}((s,),data_š)  for s in 1:nā]


# calculate shape functions