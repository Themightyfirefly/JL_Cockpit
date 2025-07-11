using GLMakie
using LinearAlgebra

include("util.jl")

"""
    loss_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}})

Plot the loss of each Datapoint as a line graph.
"""
function loss_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}}, a::Int64, b::Int64)
    losses = Observable{Vector{Float32}}([])

    ax_loss = Axis(fig[a, b], xlabel = "Iteration", ylabel = "Loss", title = "Training Loss")
    lines!(ax_loss, losses, label = "Training Loss", color = :blue)

    on(datapoints) do data
        (length(data) > 1) && push!(losses, data[end].loss)
        if length(losses[]) > 1
            xlims!(ax_loss, 1, length(losses[]))
            ylims!(ax_loss, minimum(losses[]), maximum(losses[]))
        end
    end 
    return losses
end

"""
    loss_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}})

Use a predefined position (1,1) in Figure, if none is given.
"""
loss_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}}) = loss_plot!(fig, datapoints, 1, 1)

"""
    grad_norm_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}})

Plot the norm of the gradients in each Datapoint as a line graph. 
"""
function grad_norm_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}}, a::Int64, b::Int64)
    grad_norms = Observable{Vector{Float32}}([])

    ax_grad_norm = Axis(fig[a, b], xlabel = "Iteration", ylabel = "GradNorm", title = "Gradient Norms")
    scatter!(ax_grad_norm, grad_norms, label = "Gradient Norm", color = Makie.wong_colors()[3], markersize = 5, strokewidth = 0)

    on(datapoints) do data
        (length(data) > 1) && push!(grad_norms, norm(myflatten(data[end].grads)))
        if length(grad_norms[]) > 1
            xlims!(ax_grad_norm, 1, length(grad_norms[]))
            ylims!(ax_grad_norm, minimum(grad_norms[]), maximum(grad_norms[]))
        end
    end

    return grad_norms
end

"""
    grad_norm_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}})

Use a predefined position (2,1) in Figure, if none is given.
"""
grad_norm_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}}) = grad_norm_plot!(fig, datapoints, 2, 1)

"""
    hist_1d_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}})

Plot a histogram of gradients in the last Datapoint.
"""
function hist_1d_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}}, a::Int64, b::Int64)
    grad_elems = Observable{Vector{Float32}}([])

    ax_hist_1d = Axis(fig[a, b], xlabel = "", ylabel = "", title = "Gradient Element Histogram", yscale = log10)
    plot_exist = false

    on(datapoints) do data
        if length(data) > 1
            grad_elems[] = myflatten(data[end].grads)
            if !plot_exist
                plot_exist = true
                hist!(ax_hist_1d, grad_elems, bins = range(-0.2, 0.2, length = 50), color = Makie.wong_colors()[4], strokewidth = 0.1, strokecolor = :white)
            end
        end
    end

    return grad_elems
end

"""
    hist_1d_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}})

Use a predefined position (1,2) in Figure, if none is given.
"""
hist_1d_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}}) = hist_1d_plot!(fig, datapoints, 1, 2)

"""
    params_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}})

Plot a histogram of the parameters given in the last Datapoint.
"""
function params_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}}, a::Int64, b::Int64)
    params = Observable{Vector{Float32}}([])
    
    ax_params = Axis(fig[a, b], xlabel = "", ylabel = "", title = "Parameter Histogram")
    plot_exist = false

    on(datapoints) do data
        params[] = myflatten(data[end].params)
        if !plot_exist
            plot_exist = true
            h = hist!(ax_params, params, bins = range(-0.2, 0.2, length = 50), color = Makie.wong_colors()[3], strokewidth = 0.1, strokecolor = :white)
        end
    
    end

    return params
end

"""
    params_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}})

Use a predefined position (2,2) in Figure, if none is given.
"""
params_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}}) = params_plot!(fig, datapoints, 2, 2)

"""
    distance_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}})

Plot the l2 distance between the parameters in the first and last Datapoint as a point graph.
"""
function distance_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}}, a::Int64, b::Int64)
    params_0 = Vector{Float32}([])
    l2_distance = Observable{Vector{Float32}}([])

    ax_distance = Axis(fig[a, b], xlabel = "", ylabel = "", title = "Distance")
    scatter!(ax_distance, l2_distance, label = "", color = Makie.wong_colors()[5])

    on(datapoints) do data
        params_0 == [] && (params_0 = myflatten(data[end].params))
        push!(l2_distance, norm(myflatten(data[end].params) - params_0))
        if length(l2_distance[]) > 1
            xlims!(ax_distance, 1, length(l2_distance[]))
            ylims!(ax_distance, minimum(l2_distance[]), maximum(l2_distance[]))
        end
    end

    return l2_distance
end

"""
    distance_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}})

Use the predefined position (1,3) in Figure, if none is given.
"""
distance_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}}) = distance_plot!(fig, datapoints, 1, 3)


"""
    update_size_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}})

Plot the l2 distance between parameters in the second to last and last Datapoint given.
"""
function update_size_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}}, a::Int64, b::Int64)
    params_prev = Vector{Float32}([])
    l2_distance = Observable{Vector{Float32}}([])

    ax_distance = Axis(fig[a, b], xlabel = "", ylabel = "", title = "Update Size")
    scatter!(ax_distance, l2_distance, label = "", color = Makie.wong_colors()[6])

    on(datapoints) do data
        (params_prev != []) && push!(l2_distance, norm(myflatten(data[end].params) - params_prev))
        params_prev = myflatten(data[end].params)
        if length(l2_distance[]) > 1
            xlims!(ax_distance, 1, length(l2_distance[]))
            ylims!(ax_distance, minimum(l2_distance[]), maximum(l2_distance[]))
        end
    end

    return l2_distance
end

"""
    update_size_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}})

Use the predefined position (2,3) in Figure, if none is given.
"""
update_size_plot!(fig::Makie.Figure, datapoints::Observable{Vector{Datapoint}}) = update_size_plot!(fig, datapoints, 2, 3)


"""
    hist_2d_plot!(fig, datapoints::Observable{Vector{Datapoint}}, a::Int64, b::Int64)

Plot the Parameters and the corresponding Gradients in the current training iteration.
"""
function hist_2d_plot!(fig, datapoints::Observable{Vector{Datapoint}}, a::Int, b::Int)
    nbins = 100 # 50 bins per axis
    ax = Axis(fig[a, b],
        xlabel = "Gradient Value",
        ylabel = "Parameter Value",
        title  = "GradNorm 2D (heatmap)")

    
    heat_obs = Observable(zeros(Float32, nbins, nbins))
    hm = heatmap!(ax, heat_obs; colormap = :turbo)

    on(datapoints) do dps
        dp = dps[end]
        if dp.grads === nothing || dp.params === nothing 
            return # skip if either of them is empty
        end

        g = myflatten(dp.grads)
        p = myflatten(dp.params)
        isempty(g) || isempty(p) && return # skip if either of them is empty

        # Compute bin edges 
        eg = range(minimum(g), stop=maximum(g), length=nbins+1)
        ep = range(minimum(p), stop=maximum(p), length=nbins+1)

        # convert into 50x50 matrix
        mat = zeros(Float32, nbins, nbins)

        # search for each value's bin 
        @inbounds for (gi, pi) in zip(g, p)
            i = clamp(searchsortedfirst(eg, gi) - 1, 1, nbins) #ensure index is not out-of-bounds
            j = clamp(searchsortedfirst(ep, pi) - 1, 1, nbins)
            mat[j, i] += Float32(1.0) # to match matrix's type. Without this plot will be pure color. TBD why
        end

        heat_obs[] = mat
        hm.colorrange[] = (0f0, maximum(mat))
    end

    return ax
end



"""
    hist_2d_plot!(fig, datapoints::Observable{Vector{Datapoint}})

Use the predefined position (3,1) in Figure, if none is given.
"""
hist_2d_plot!(fig, datapoints::Observable{Vector{Datapoint}}) = hist_2d_plot!(fig, datapoints, 3, 1)