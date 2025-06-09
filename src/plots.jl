using GLMakie

function loss_plot!(fig, vis_loss::Observable{Vector{Float32}})
    ax_loss = Axis(fig[1, 1], xlabel = "x label", ylabel = "y label", title = "Losses")
    lines!(ax_loss, @lift(1:length($vis_loss)), vis_loss)
    
    on(vis_loss) do vl
        if length(vl) > 1
            xlims!(ax_loss, 1, length(vl))
            ylims!(ax_loss, minimum(vl), maximum(vl))
        end
    end

    return ax_loss
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
end