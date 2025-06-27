# using jl_cockpit
# using GLMakie

# losses = Observable{Vector{Float32}}([])
# gradient_norms = Observable{Vector{Float32}}([])

# cockpit_vis = visualiser()

# for i in rand(4000)

#     push!(losses, Float32(i))
    
#     @info(i)
#     sleep(0.1)
# end