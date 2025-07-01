using GLMakie
using LinearAlgebra
using Makie: vlines!

include("util.jl")

function add_slider!(fig, datapoints::Observable{Vector{Datapoint}})
    # Initialize slider with safe range
    slider_range = Observable(1:1)
    slider = Slider(fig[3, 1:2], range=slider_range, startvalue=1)
    
    # Create safe observable for current point
    current_point = Observable{Union{Nothing,Datapoint}}(nothing)
    
    # Update current point when slider changes
    on(slider.value) do idx
        if !isempty(datapoints[]) && idx <= length(datapoints[])
            current_point[] = datapoints[][idx]
        else
            current_point[] = nothing
        end
    end
    
    # Update slider range when data changes
    on(datapoints) do data
        if !isempty(data) && length(data) > length(slider_range[])
            slider_range[] = 1:length(data)
        end
    end
    
    # Info label using map instead of @lift
    info_txt = map(current_point) do pt
        isnothing(pt) ? "No data" : "Epoch: $(pt.epoch), Batch: $(pt.batch)"
    end
    Label(fig[3, 3], info_txt)
    
    return slider
end


"""
    This function plots the loss of the plot data and axis
"""
function loss_plot!(fig, datapoints::Observable{Vector{Datapoint}})
    losses = Observable{Vector{Float32}}([])

    # Create layout
    gl = GridLayout()
    fig[1,1] = gl
    ax = Axis(gl[1,1], xlabel="Iteration", ylabel="Loss", title="Training Loss")
    lines!(ax, losses, color=:blue)

    # Initialize slider
    slider_range = Observable(1:1)
    slider = Slider(gl[2,1], range=slider_range, startvalue=1)

    # Create vertical lines (using vlines! instead of vline!)
    current_pos = Observable([1.0])  # Must be array for vlines!
    vlines!(ax, current_pos, color=:red, linestyle=:dash)

    # Info label
    info = Label(gl[3,1], @lift begin
        if isempty(datapoints[])
            "No data"
        else
            idx = clamp($(slider.value), 1, length(datapoints[]))
            pt = datapoints[][idx]
            "Epoch: $(pt.epoch), Loss: $(round(pt.loss, digits=4))"
        end
    end)

    # Update position
    on(slider.value) do val
        current_pos[] = [Float64(val)]  # Must be array of Float64
    end

    # Update data
    on(datapoints) do data
    if !isempty(data) && !isnothing(data[end].loss)
        push!(losses, data[end].loss)
            if length(data) > length(slider_range[])
                slider_range[] = 1:length(data)
            end
            if length(losses[]) > 1
                xlims!(ax, 1, length(losses[]))
                ylims!(ax, minimum(losses[]), maximum(losses[]))
            end
        end
    end

    return ax
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

    #=axiszoom!(ax_hist_1d)  # Enables zooming
    axispan!(ax_hist_1d)   # Enables panning
    =#
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

    #= Enable zoom and pan for the parameter histogram plot
    axiszoom!(ax_params)  # Enables zooming
    axispan!(ax_params)   # Enables panning =#

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
#=
    axiszoom!(ax_distance)  # Enables zooming
    axispan!(ax_distance)   # Enables panning =#

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
#=
    axiszoom!(ax_distance)  # Enables zooming
    axispan!(ax_distance)   # Enables panning =#

    on(datapoints) do data
        (params_prev != []) && push!(l2_distance, norm(myflatten(data[end].params) - params_prev))
        params_prev = myflatten(data[end].params)
        if length(l2_distance[]) > 1
            xlims!(ax_distance, 1, length(l2_distance[]))
            ylims!(ax_distance, minimum(l2_distance[]), maximum(l2_distance[]))
        end
    end

end