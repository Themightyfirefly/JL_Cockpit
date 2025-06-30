using GLMakie
using LinearAlgebra

include("util.jl")

"""
    This function plots the loss of the plot data and axis
"""
function loss_plot!(fig, datapoints::Observable{Vector{Datapoint}})
    losses = Observable{Vector{Float32}}([])

    ax_loss = Axis(fig[1, 1], xlabel = "Iteration", ylabel = "Loss", title = "Training Loss")
    lines!(ax_loss, losses, label = "Training Loss", color = :blue)

    on(datapoints) do data
        (length(data) > 1) && push!(losses, data[end].loss)
        if length(losses[]) > 1
            xlims!(ax_loss, 1, length(losses[]))
            ylims!(ax_loss, minimum(losses[]), maximum(losses[]))
        end
    end

    return ax_loss
end

function grad_norm_plot!(fig, datapoints::Observable{Vector{Datapoint}})
    grad_norms = Observable{Vector{Float32}}([])

    ax_grad_norm = Axis(fig[2, 1], xlabel = "Iteration", ylabel = "GradNorm", title = "Gradient Norms")
    lines!(ax_grad_norm, grad_norms, label = "Gradient Norm", color = :blue)

    on(datapoints) do data
        (length(data) > 1) && push!(grad_norms, norm(myflatten(data[end].grads)))
        if length(grad_norms[]) > 1
            xlims!(ax_grad_norm, 1, length(grad_norms[]))
            ylims!(ax_grad_norm, minimum(grad_norms[]), maximum(grad_norms[]))
        end
    end

    return ax_grad_norm
end

function hist_1d_plot!(fig, datapoints::Observable{Vector{Datapoint}})
    grad_elems = Observable{Vector{Float32}}([])

    ax_hist_1d = Axis(fig[1, 2], xlabel = "", ylabel = "", title = "Gradient Element Histogram")
    plot_exist = false

    on(datapoints) do data
        if length(data) > 1
            grad_elems[] = myflatten(data[end].grads)
            if !plot_exist
                plot_exist = true
                hist!(ax_hist_1d, grad_elems, bins = 50, color = Makie.wong_colors()[4], strokewidth = 0.1, strokecolor = :white)
            end
        end
    end

end

function params_plot!(fig, datapoints::Observable{Vector{Datapoint}})
    params = Observable{Vector{Float32}}([])
    
    ax_params = Axis(fig[2, 2], xlabel = "", ylabel = "", title = "Parameter Histogram")
    plot_exist = false

    on(datapoints) do data
        params[] = myflatten(data[end].params)
        if !plot_exist
            plot_exist = true
            hist!(ax_params, params, bins = 50, color = Makie.wong_colors()[3], strokewidth = 0.1, strokecolor = :white)
        end
    end
end

function distance_plot!(fig, datapoints::Observable{Vector{Datapoint}})
    params_0 = Vector{Float32}([])
    l2_distance = Observable{Vector{Float32}}([])

    ax_distance = Axis(fig[1, 3], xlabel = "", ylabel = "", title = "Distance")
    scatter!(ax_distance, l2_distance, label = "", color = Makie.wong_colors()[5])

    on(datapoints) do data
        params_0 == [] && (params_0 = myflatten(data[end].params))
        push!(l2_distance, norm(myflatten(data[end].params) - params_0))
        if length(l2_distance[]) > 1
            xlims!(ax_distance, 1, length(l2_distance[]))
            ylims!(ax_distance, minimum(l2_distance[]), maximum(l2_distance[]))
        end
    end

end

function update_size_plot!(fig, datapoints::Observable{Vector{Datapoint}})
    params_prev = Vector{Float32}([])
    l2_distance = Observable{Vector{Float32}}([])

    ax_distance = Axis(fig[2, 3], xlabel = "", ylabel = "", title = "Update Size")
    scatter!(ax_distance, l2_distance, label = "", color = Makie.wong_colors()[6])

    on(datapoints) do data
        (params_prev != []) && push!(l2_distance, norm(myflatten(data[end].params) - params_prev))
        params_prev = myflatten(data[end].params)
        if length(l2_distance[]) > 1
            xlims!(ax_distance, 1, length(l2_distance[]))
            ylims!(ax_distance, minimum(l2_distance[]), maximum(l2_distance[]))
        end
    end

end