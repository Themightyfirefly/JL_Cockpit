using GLMakie

include("plots.jl")

struct visualiser
    datapoints::Observable{Vector{datapoint}}
    batch_size::Int64
end

"""
    visualiser(; vis_loss::Observable{Vector{Float32}} = nothing, vis_grad_norm::Observable{Vector{Float32}} = nothing)

Initialises the visualiser. It will take the given Observables and display a plot that updates live. 
"""
function visualiser(; batch_size = 1, vis_loss::Bool = false, vis_grad_norm::Bool = false)
    
    datapoints = Observable{Vector{datapoint}}([])

    fig = Figure()
    
    vis_loss && loss_plot!(fig, datapoints)
    #vis_grad_norm && grad_norm_plot!(fig, datapoints)
    
    display(fig)

    return visualiser(datapoints, batch_size)
end

export visualiser