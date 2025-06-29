using Flux
using MLDatasets
using Statistics
using GLMakie
using LinearAlgebra

include("visualiser.jl")

# Example taken from https://adrianhill.de/julia-ml-course/L7_Deep_Learning/
"""
    This function preprocesses features x and labels y from the given dataset for the training.
    It transforms x into a 28x28 matrix and y into a 10-class vector.
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
    This function calculates the accuracy of the model on test data
"""
function accuracy(model, x_test, y_test)
    # Use onecold to return class index
    ŷ = Flux.onecold(model(x_test))
    y = Flux.onecold(y_test)

    return mean(ŷ .== y)
end

"""
    This function trains the data in a loop
    Call this function with optional parameters
"""
function training_loop(; model = nothing, dataset_train = nothing, dataset_test = nothing, batchsize = 128)
    # Assignment of standard values
    # TODO remove these for the final submission
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
    optim = Flux.setup(Adam(3.0f-4), model)
    loss_fn(ŷ, y) = Flux.logitcrossentropy(ŷ, y)

    x_train, y_train = preprocess(dataset_train)
    x_test, y_test = preprocess(dataset_test)
    train_loader = Flux.DataLoader((x_train, y_train); batchsize=batchsize, shuffle=true);

    # creating a visualiser and pass the batch size
    vis = visualiser(batch_size = batchsize, vis_loss = true, vis_grad_norm = true, vis_update_size = true)

    #TODO Users should be able to specify the optimizer, loss, numbers of epochs etc.
    for epoch in 1:5
        # Iterate over batches returned by data loader
        for (i, (x, y)) in enumerate(train_loader)
            # https://fluxml.ai/Flux.jl/stable/reference/training/zygote/
            #   julia> Flux.withgradient(m -> m(3), model)  # this uses Zygote
            #   (val = 14.52, grad = ((layers = ((weight = [0.0 0.0 4.4],), (weight = [3.3;;], bias = [1.0], σ = nothing), nothing),),))
            # Compute loss and gradients of model w.r.t. its parameters (individually for each batch)
            
            #gets params before updating model
            params_before = deepcopy(Flux.params(model))
            
            loss, grads = Flux.withgradient(m -> loss_fn(m(x), y), model)

            # Update optimizer state
            Flux.update!(optim, model, grads[1])

            #gets params after updating model
            params_after = Flux.params(model)

            # Keep track of losses by logging them in `losses`
            push!(vis.datapoints, Datapoint(epoch, i, loss, grads, params_before, params_after))
            
            # Without this sleep, the visualisation will not work smoothly. TBD why...
            sleep(0)
        end
    end
end

export training_loop