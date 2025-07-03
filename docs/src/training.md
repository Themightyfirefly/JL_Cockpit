```@meta
CurrentModule = jl_cockpit
```

```@docs
visualiser(; vis_loss::Observable{Vector{Float32}} = nothing, vis_grad_norm::Observable{Vector{Float32}} = nothing)
```

```@docs
accuracy(model, x_test, y_test)
```

```@docs
training_loop(; model = nothing, dataset_train = nothing, dataset_test = nothing, batchsize = 128, epochs = 5, optim = nothing)
```

```@docs
preprocess(dataset)
```