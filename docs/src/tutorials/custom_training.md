```@meta
CurrentModule = JL_Cockpit
```


# Customising the Flux Training Loop

As can be seen in the API reference, the [training_loop](@ref) function can be called with the following optional arguments.

    training_loop(;
        model = nothing, dataset_train = nothing, dataset_test = nothing, 
        batchsize = 128, epochs = 5, optim = nothing,
        vis_loss::Bool = true, vis_grad_norm::Bool = true, 
        vis_hist_1d::Bool = true, vis_params::Bool = true,
        vis_distance::Bool = true, vis_update_size::Bool = true, vis_hist_2d::Bool = false
    )

By default model, dataset\_train, dataset\_test and optim are not defined and the following default values will be assigned:

    model = Chain(
        Conv((5, 5), 1 => 6, relu),  # 1 input color channel
        MaxPool((2, 2)),
        Conv((5, 5), 6 => 16, relu),
        MaxPool((2, 2)),
        Flux.flatten,
        Dense(256, 120, relu),
        Dense(120, 84, relu),
        Dense(84, 10),  # 10 output classes)
    
    dataset_train = MNIST(; split=:train)

    dataset_test = MNIST(; split=:test)

    optim = Flux.setup(Adam(3.0f-4), model)

Additionally the training is set to run for 5 epochs and the size of the batch used in each iteration is set to 128.

These values can be changed by passing the custom values to the training_loop function call, e.g.

    training_loop(epochs=2)

The vis_ arguments determine if a metric is shown. By default, all available metrics, except the 2D histogram of parameter values and gradients, are shown. To deactivate a plot, set the argument to false, e.g.

    training_loop(vis_loss=false)