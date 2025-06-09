module jl_cockpit

    # other source files used
    include("example.jl")

    using Flux
    using MLDatasets
    using Statistics

    using GLMakie
    using LinearAlgebra

    # Write your package code here.

    struct cockpit_visualiser
        vis_loss::Observable{Vector{Float32}}
        vis_grad_norm::Observable{Vector{Float32}}

        function cockpit_visualiser(vis_loss::Observable{Vector{Float32}}, vis_grad_norm::Observable{Vector{Float32}})
            fig = Figure()
            ax_loss = Axis(fig[1, 1], xlabel = "x label", ylabel = "y label", title = "Losses")
            ax_grad = Axis(fig[1, 2], xlabel = "x label", ylabel = "y label", title = "Gradient Norms")
            lines!(ax_loss, @lift(1:length($vis_loss)), vis_loss)
            scatter!(ax_grad, @lift(1:length($vis_grad_norm)), vis_grad_norm)
            display(fig)
        
            on(vis_loss) do vl
                if length(vl) > 1
                    xlims!(ax_loss, 1, length(vl))
                    ylims!(ax_loss, minimum(vl), maximum(vl))
                end
            end

            on(vis_grad_norm) do gn
                if length(gn) > 1
                    xlims!(ax_grad, 1, length(gn))
                    ylims!(ax_grad, minimum(gn), maximum(gn))
                end
            end

            return new(vis_loss,vis_grad_norm)
        end
    end

    function cockpit_visualiser(; vis_loss::Observable{Vector{Float32}} = nothing, vis_grad_norm::Observable{Vector{Float32}} = nothing)
        return cockpit_visualiser(vis_loss, vis_grad_norm)
    end

    export cockpit_visualiser

    # Extending the function push! to ensure the Observable is triggered
    #
    # Observables are triggered when they get assigned a value,
    # but when appending the list is mutated, not assigned, and therefore the Observable must be triggered manually
    import Base.push!
    function push!(list_obs::Observable{Vector{Float32}}, value::Float32)
        push!(list_obs[], value)
        list_obs[] = list_obs[]
    end

    #export push!

end