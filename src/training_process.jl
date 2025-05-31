using Flux
using MLDatasets
using Statistics

using GLMakie, Makie

# Example taken from https://adrianhill.de/julia-ml-course/L7_Deep_Learning/
function preprocess(dataset)
    x, y = dataset[:]

    # Add singleton color-channel dimension to features for Conv-layers
    x = reshape(x, 28, 28, 1, :)

    # One-hot encode targets
    y = Flux.onehotbatch(y, 0:9)

    return x, y
end

function accuracy(model, x_test, y_test)
    # Use onecold to return class index
    ŷ = Flux.onecold(model(x_test))
    y = Flux.onecold(y_test)

    return mean(ŷ .== y)
end



function training_process()
    dataset_train = MNIST(; split=:train)
    dataset_test = MNIST(; split=:test)

    x_train, y_train = preprocess(dataset_train)
    x_test, y_test = preprocess(dataset_test)

    batchsize = 128
    train_loader = Flux.DataLoader((x_train, y_train); batchsize=batchsize, shuffle=true);

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

    loss_fn(ŷ, y) = Flux.logitcrossentropy(ŷ, y)

    optim = Flux.setup(Adam(3.0f-4), model)

    losses = Observable(Float32[])

    #---
    
    fig = Figure(size = (500, 900))
    ax = Axis(fig[1, 1])
    #lines!(ax, lift(1:length(to_value(losses))), lift(losses))
    display(fig)

    on(losses) do losses
        lines!(ax, (1:length(to_value(losses))), to_value(losses))
        
    end
    #---


    # Train for 5 epochs
    for epoch in 1:5

        # Iterate over batches returned by data loader
        for (i, (x, y)) in enumerate(train_loader)

            # Compute loss and gradients of model w.r.t. its parameters
            loss, grads = Flux.withgradient(m -> loss_fn(m(x), y), model)

            # Update optimizer state
            Flux.update!(optim, model, grads[1])

            # Keep track of losses by logging them in `losses`
            push!(losses[], loss)
            @info "Losses: $(losses[])"

            # Every fifty steps, evaluate the accuracy on the test set
            # and print the accuracy and loss
            if isone(i) || iszero(i % 50)
                acc = accuracy(model, x_test, y_test) * 100
                @info "Epoch $epoch, step $i:\t loss = $(loss), acc = $(acc)%"
            end
        end
    end

    plot(losses; xlabel="Step", ylabel="Loss", yaxis=:log) # runs after training
end

export training_process