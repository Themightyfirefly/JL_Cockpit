```@meta
CurrentModule = JL_Cockpit
```

```@index
Pages   = ["training_api.md"]
```

```@docs
training_loop(; model = nothing, dataset_train = nothing, dataset_test = nothing, batchsize = 128, epochs = 5, optim = nothing, vis_loss::Bool = true, vis_grad_norm::Bool = true, vis_hist_1d::Bool = true, vis_params::Bool = true, vis_distance::Bool = true, vis_update_size::Bool = true, vis_hist_2d::Bool = true
)
```

```@docs
visualiser(; vis_loss::Bool = true, vis_grad_norm::Bool = true, vis_hist_1d::Bool = true, vis_params::Bool = true, vis_distance::Bool = true, vis_update_size::Bool = true, vis_hist_2d::Bool = true
)
```

