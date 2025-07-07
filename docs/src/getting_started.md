# Getting started

We have created a package to provide a modular monitoring and debugging pipeline for training neural networks, implementing a modular training loop using Flux.jl.
This package allows users to specify observable quantities (e.g. gradient norm, curvature).
Users can see the live dashboard that we implemented with Makie.jl.

The **jl_cockpit** module provides plots for the live visualisation for neural network training. It uses the GLMakie module and their *Observable* to provide the live functionality. Using the module can happen in two different ways:


# Example Workflow
After entering the REPL session on your command line with 
    julia then enter ] to enter PKg mode

activate a temporary environment by entering 

    activate --temp

then add the repo 

    add https://github.com/Themightyfirefly/jl_cockpit

after that you can run the training_loop function

    training_loop()

which runs  


    training_loop(; model = nothing, dataset_train = nothing, dataset_test = nothing, batchsize = 128, epochs = 5, optim = nothing)


with default values

### Default Values 

    Chain(
        Conv((5, 5), 1 => 6, relu),  # 1 input color channel
        MaxPool((2, 2)),
        Conv((5, 5), 6 => 16, relu),
        MaxPool((2, 2)),
        Flux.flatten,
        Dense(256, 120, relu),
        Dense(120, 84, relu),
        Dense(84, 10),  # 10 output classes
    )

- By default **model** is defined as the 8-layered model above

- The datasets **dataset_train** and **dataset_test** are from MLDatasets.jl's MNIST dataset split into a training and a test dataset

- The **batchsize** is set to 128 by default

- The number of **epochs** is set to 5 by default

- The optimizer **optim** is set to the Adam optimizer with a learning rate of 0.0003

you can run training_loop with your own inputs as well

   
## Selecting Plots one by one
ToDO()

## Creating Observables and passing them to the visualiser
Right now, only the loss function visualisation is fully operational.

First, initialise an Observable

    losses = Observable{Vector{Float32}}([])

Once the Observables have been initialised, the visualiser can be initialised

    cockpit_visualiser(vis_loss=losses)

Inside the training loop, values can be pushed to the Vector via push!()

    push!(losses, loss)
