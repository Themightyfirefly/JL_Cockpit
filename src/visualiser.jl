using GLMakie: Observable, Figure
using Makie: Keyboard

include("plots.jl")

#TODO struct should be capitalized
struct Visualiser
    datapoints::Observable{Vector{Datapoint}}
end

"""
    visualiser(; vis_loss::Observable{Vector{Float32}} = nothing, vis_grad_norm::Observable{Vector{Float32}} = nothing)

Initialises the visualiser. It will take the given Observables and display a plot that updates live. 
"""
function visualiser(; vis_loss::Bool = true, vis_grad_norm::Bool = true, vis_hist_1d = true, vis_params = true, vis_distance = true, vis_update_size = true, vis_hist_2d = true)
    GLMakie.activate!()
    GLMakie.closeall()
    
    datapoints = Observable{Vector{Datapoint}}([])

    with_theme(theme_black()) do
        fig = Figure(size = (1920, 1080))

        vis_loss && loss_plot!(fig, datapoints)
        vis_grad_norm && grad_norm_plot!(fig, datapoints)
        vis_hist_1d && hist_1d_plot!(fig, datapoints)
        vis_params && params_plot!(fig, datapoints)
        vis_distance && distance_plot!(fig, datapoints)
        vis_update_size && update_size_plot!(fig, datapoints)
        vis_hist_2d && hist_2d_plot!(fig, datapoints)

        di = DataInspector(fig, textcolor = :black, strokecolor = :black, font = "Consolas")
      
        on(fig.scene.events.keyboardbutton) do event
        event.key == Keyboard.r && foreach(autolimits!, fig.content)  # Press "R" to reset zoom
        event.key == Keyboard.s && save("training_plot.png", fig)     # Press "S" to save plot
        end

        display(fig)
    end

    return Visualiser(datapoints)
end

export visualiser