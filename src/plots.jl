using GLMakie

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

#=struct grad_norm_plot
    grad_norm::Observable{Vector{Float32}}
end
function grad_norm_plot(fig, vis_grad::Observable{Vector{Float32}})
    ax_grad = Axis(fig[1, 2], xlabel = "x label", ylabel = "y label", title = "Gradient Norms")

    on(vis_grad) do gn
        if length(gn) > 1
            xlims!(ax_grad, 1, length(gn))
            ylims!(ax_grad, minimum(gn), maximum(gn))
        end
    end


end


function grad_norm_plot!(fig, vis_grad_norm::Observable{Vector{Float32}})
    ax_grad = Axis(fig[1, 2], xlabel = "x label", ylabel = "y label", title = "Gradient Norms")
    scatter!(ax_grad, @lift(1:length($vis_grad_norm)), vis_grad_norm)
    
    on(vis_grad_norm) do gn
        if length(gn) > 1
            xlims!(ax_grad, 1, length(gn))
            ylims!(ax_grad, minimum(gn), maximum(gn))
        end
    end

    return ax_grad
end=#