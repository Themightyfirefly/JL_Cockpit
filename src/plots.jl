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