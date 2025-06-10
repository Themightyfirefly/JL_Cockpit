module jl_cockpit

    # other source files used
    include("plots.jl")

    using Flux
    using MLDatasets
    using Statistics

    using GLMakie
    using LinearAlgebra

    struct cockpit_visualiser
        vis_loss::Union{Observable{Vector{Float32}}, Nothing}
        vis_grad_norm::Union{Observable{Vector{Float32}}, Nothing}

        function cockpit_visualiser(vis_loss::Union{Observable{Vector{Float32}}, Nothing}, vis_grad_norm::Union{Observable{Vector{Float32}}, Nothing})
            fig = Figure()

            if !isnothing(vis_loss)
                loss_plot!(fig, vis_loss)
            end

            if !isnothing(vis_grad_norm)
                grad_norm_plot!(fig, vis_grad_norm)
            end
            
            display(fig)
            return new(vis_loss,vis_grad_norm)
        end
    end

    """
        cockpit_visualiser(; vis_loss::Observable{Vector{Float32}} = nothing, vis_grad_norm::Observable{Vector{Float32}} = nothing)

    Initialises the visualiser. It will take the given Observables and display a plot that updates live. 
    """
    function cockpit_visualiser(; vis_loss::Union{Observable{Vector{Float32}}, Nothing} = nothing, vis_grad_norm::Union{Observable{Vector{Float32}}, Nothing} = nothing)
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