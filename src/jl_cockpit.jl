module jl_cockpit

    # other source files used
    include("example.jl")
    #include("training_process.jl")
    #include("plot.jl")

    using Flux
    using MLDatasets
    using Statistics

    using GLMakie
    using LinearAlgebra

    # Write your package code here.

    struct cockpit_visualiser
        vis_loss::Observable{Vector{Float32}}
        vis_det_norm::Observable{Vector{Float32}}

        function cockpit_visualiser(vis_loss::Observable{Vector{Float32}}, vis_det_norm::Observable{Vector{Float32}})
            fig = Figure()
            ax = Axis(fig[1, 1], xlabel = "x label", ylabel = "y label", title = "Losses")
            ax_grad = Axis(fig[1, 2], xlabel = "x label", ylabel = "y label", title = "Gradient Norms")
            lines!(ax, @lift(1:length($vis_loss)), vis_loss)
            scatter!(ax_grad, @lift(1:length($vis_det_norm)), vis_det_norm)
            display(fig)
        
            on(vis_loss) do vis_loss
                if length(vis_loss) > 1
                    xlims!(ax_grad, 1, length(vis_loss))
                    ylims!(ax_grad, minimum(vis_loss), maximum(vis_loss))
                end
            end

            on(vis_det_norm) do gn
                if length(gn) > 1
                    xlims!(ax, 1, length(gn))
                    ylims!(ax, minimum(gn), maximum(gn))
                end
            end

            return new(vis_loss,vis_det_norm)
        end
    end

    function cockpit_visualiser(; vis_loss::Observable{Vector{Float32}} = nothing, vis_det_norm::Observable{Vector{Float32}} = nothing)
        return cockpit_visualiser(vis_loss, vis_det_norm)
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