using Flux
using MLDatasets: MNIST
using GLMakie: Observable
using LinearAlgebra: reshape
using Statistics: mean

include("visualiser.jl")

# Example taken from https://adrianhill.de/julia-ml-course/L7_Deep_Learning/
"""
    preprocess(dataset)

Transform x into a 28x28 matrix and y into a 10-class vector.
"""
function preprocess(dataset)
    x, y = dataset[:]

    # Add singleton color-channel dimension to features for Conv-layers
    x = reshape(x, 28, 28, 1, :)

    # One-hot encode targets
    y = Flux.onehotbatch(y, 0:9)

    return x, y
end

"""
    training_loop(;
        model = nothing, dataset_train = nothing, dataset_test = nothing, 
        batchsize = 128, epochs = 5, optim = nothing,
        vis_loss::Bool = true, vis_grad_norm::Bool = true, 
        vis_hist_1d::Bool = true, vis_params::Bool = true,
        vis_distance::Bool = true, vis_update_size::Bool = true, vis_hist_2d::Bool = false
    )

Train with AD and visualise live metrics.
"""
function training_loop(
    ; model = nothing, dataset_train = nothing, dataset_test = nothing, batchsize = 128, epochs = 5, optim = nothing,
    vis_loss::Bool = true, vis_grad_norm::Bool = true, vis_hist_1d::Bool = true, vis_params::Bool = true,
    vis_distance::Bool = true, vis_update_size::Bool = true, vis_hist_2d::Bool = false
)

    @info "Initialising Training"

    # Assignment of standard values
    if isnothing(model)
        model = Chain(
        Conv((5, 5), 1 => 6, relu),  # 1 input color channel
        MaxPool((2, 2)),
        Conv((5, 5), 6 => 16, relu),
        MaxPool((2, 2)),
        Flux.flatten,
        Dense(256, 120, relu),
        Dense(120, 84, relu),
        Dense(84, 10),  # 10 output classes
    )
    end
    if isnothing(dataset_train)
        dataset_train = MNIST(; split=:train)
    end
    if isnothing(dataset_test)
        dataset_test = MNIST(; split=:test)
    end
    if isnothing(optim)
        optim = Flux.setup(Adam(3.0f-4), model)
    end
    loss_fn(ŷ, y) = Flux.logitcrossentropy(ŷ, y)

    x_train, y_train = preprocess(dataset_train)
    train_loader = Flux.DataLoader((x_train, y_train); batchsize=batchsize, shuffle=true);

    @info "Initialising Visualiser"

    # creating a visualiser and pass the batch size
    vis = visualiser(
        vis_loss = vis_loss, vis_grad_norm = vis_grad_norm, vis_hist_1d = vis_hist_1d, vis_params = vis_params, 
        vis_distance = vis_distance, vis_update_size = vis_update_size, vis_hist_2d = vis_hist_2d
    )

    @info "Pushing Initial State to Visualiser"

    push!(vis.datapoints, Datapoint(-1, -1, nothing, nothing, Flux.params(model)))

    @info "Start Training"

    for epoch in 1:epochs
        @info "Epoch $epoch out of $epochs"
        # Iterate over batches returned by data loader
        for (i, (x, y)) in enumerate(train_loader)
            # Compute loss and gradients of model w.r.t. its parameters (individually for each batch)
            loss, grads = Flux.withgradient(m -> loss_fn(m(x), y), model)

            # Update optimizer state
            Flux.update!(optim, model, grads[1])

            push!(vis.datapoints, Datapoint(epoch, i, loss, grads, Flux.params(model)))
            
            # Without this sleep, the visualisation will not work smoothly. TBD why...
            sleep(0)
        end
    end

    @info "Training Complete"

    return true
end

export training_loop