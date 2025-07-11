using GLMakie: Observable, Figure
using Makie: Keyboard

include("plots.jl")

"""
    iterate_plot_pos(a::Int64, b::Int64)

Iterate the positions in a Figure, so that there are no gaps and the number of rows is never more than the number of columns.
"""
function iterate_plot_pos(a::Int64, b::Int64)
    a == b && return (1, b+1)
    a+1 == b && return (a+1, 1)
    a > b && return (a, b+1)
    a < b && return (a+1, b)
end

struct Visualiser
    datapoints::Observable{Vector{Datapoint}}
end

"""
    visualiser(;
        vis_loss::Bool = true, vis_grad_norm::Bool = true, vis_hist_1d::Bool = true, 
        vis_params::Bool = true, vis_distance::Bool = true, vis_update_size::Bool = true, 
        vis_hist_2d::Bool = true
    )

Initialises the visualiser. It will take the given Observables and display a plot that updates live. 
"""
function visualiser(; 
    vis_loss::Bool = true, vis_grad_norm::Bool = true, vis_hist_1d::Bool = true, vis_params::Bool = true, 
    vis_distance::Bool = true, vis_update_size::Bool = true, vis_hist_2d::Bool = false
)

    GLMakie.activate!()
    GLMakie.closeall()
    
    datapoints = Observable{Vector{Datapoint}}([])

    @info "Initialising Plots"

    with_theme(theme_black()) do
        fig = Figure(size = (1920, 1080))
        a::Int64 = 1
        b::Int64 = 1
        
        
        if vis_loss
            loss_plot!(fig, datapoints, a, b)
            a,b = iterate_plot_pos(a,b)
        end
        
        if vis_grad_norm
            grad_norm_plot!(fig, datapoints, a, b)
            a,b = iterate_plot_pos(a,b)
        end
        
        if vis_hist_1d 
            hist_1d_plot!(fig, datapoints, a, b)
            a,b = iterate_plot_pos(a,b)
        end
        
        if vis_params 
            params_plot!(fig, datapoints, a, b)
            a,b = iterate_plot_pos(a,b)
        end
        
        if vis_distance 
            distance_plot!(fig, datapoints, a, b)
            a,b = iterate_plot_pos(a,b)
        end
        
        if vis_update_size
            update_size_plot!(fig, datapoints, a, b)
            a,b = iterate_plot_pos(a,b)
        end
        
        if vis_hist_2d
            hist_2d_plot!(fig, datapoints, a, b)
            a,b = iterate_plot_pos(a,b)
        end

        @info "Initialising Key Events"
        DataInspector(fig, textcolor = :black, strokecolor = :black, font = "Consolas")
      
        on(fig.scene.events.keyboardbutton) do event
            event.key == Keyboard.r && foreach(autolimits!, fig.content)  # Press "R" to reset zoom
            event.key == Keyboard.s && save("training_plot.png", fig)     # Press "S" to save plot
        end

        @info "Displaying Figure"
        display(fig)

        # Exit training loop when user closes the Makie window
        on(events(fig.scene).window_open) do is_open
            if !is_open
           @info "Window closed - Visualization interrupted."
        end
end

    end    
        return Visualiser(datapoints)
end

export visualiser