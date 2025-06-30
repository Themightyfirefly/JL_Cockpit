using GLMakie
using LinearAlgebra

include("util.jl")

struct Plot_data_losses
    losses::Observable{Vector{Float32}}
end

"""
    This function plots the loss of the plot data and axis
"""
function loss_plot!(fig, datapoints::Observable{Vector{Datapoint}})
    pd_losses = Plot_data_losses(Observable{Vector{Float32}}([]))

    ax_loss = Axis(fig[1, 1], xlabel = "Iteration", ylabel = "Loss", title = "Training Loss")
    loss_line = lines!(ax_loss, pd_losses.losses, label = "Training Loss", color = :blue)

    axislegend(ax_loss)

    on(datapoints) do data
        @info "New datapoint" data[end].batch
        push!(pd_losses.losses, data[end].loss)
    end

    on(pd_losses.losses) do losses
        if length(losses) > 1
            xlims!(ax_loss, 1, length(losses))
            ylims!(ax_loss, minimum(losses), maximum(losses))
        end
    end

    return ax_loss
end

struct Plot_grad_norm
    grad_norms::Observable{Vector{Float32}}
end

function grad_norm_plot!(fig, datapoints::Observable{Vector{Datapoint}})
    pd_grad_norm = Plot_grad_norm(Observable{Vector{Float32}}([]))

    ax_grad_norm = Axis(fig[2, 1], xlabel = "Iteration", ylabel = "GradNorm", title = "Gradient Norms")
    norm_line = lines!(ax_grad_norm, pd_grad_norm.grad_norms, label = "Gradient Norm", color = :blue)

    axislegend(ax_grad_norm)

    on(datapoints) do data
        push!(pd_grad_norm.grad_norms, norm(myflatten(data[end].grads)))
    end

    on(pd_grad_norm.grad_norms) do norms
        if length(norms) > 1
            xlims!(ax_grad_norm, 1, length(norms))
            ylims!(ax_grad_norm, minimum(norms), maximum(norms))
        end
    end

    return ax_grad_norm
end

mutable struct Plot_hist_1d
    plot_exists::Bool
    grad_elems::Observable{Vector{Float32}}
end

function hist_1d_plot!(fig, datapoints::Observable{Vector{Datapoint}})
    pd_hist_1d = Plot_hist_1d(false, Observable{Vector{Float32}}([]))
    ax_hist_1d = Axis(fig[1, 2], xlabel = "", ylabel = "", title = "Gradient Element Histogram")

    on(datapoints) do data
        pd_hist_1d.grad_elems[] = myflatten(data[end].grads)
        if !pd_hist_1d.plot_exists
            pd_hist_1d.plot_exists = true
            hist!(ax_hist_1d, pd_hist_1d.grad_elems, bins = 50, color = Makie.wong_colors()[4], strokewidth = 1, strokecolor = :white, normalization = :pdf)
        end
        
    end

end

function grad_norm_hist2d_plot!(fig, param_norm_matrix::Observable{Matrix{Float32}})
    ax = Axis(fig[2, 2], xlabel="Parameter Index", ylabel="Training Step", title="Grad Norm Histogram 2D")
    heat_data = Observable(rand(Float32, 1, 1))

    heatmap_obj = heatmap!(ax, heat_data, colormap = :turbo) 
    Colorbar(fig[2, 3], heatmap_obj)  # show color scale

    on(param_norm_matrix) do mat
        rows, cols = size(mat)
        if rows > 0 && cols > 0 && !isempty(mat)
            mat_norm = mat ./ maximum(mat)
            heat_data[] = mat_norm

            sorted_vals = sort(vec(mat))
            n = length(sorted_vals)
            q1 = sorted_vals[clamp(floor(Int, n * 0.01), 1, n)]
            q99 = sorted_vals[clamp(ceil(Int, n * 0.99), 1, n)]

            hmin = q1
            hmax = q99

            if abs(hmax - hmin) < 1e-5
                hmin -= 0.01
                hmax += 0.01
            end
            heatmap_obj.colorrange[] = (hmin, hmax)
        else
        end
    end

    return ax
end
