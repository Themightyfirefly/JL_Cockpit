```@meta
CurrentModule = JL_Cockpit
```

# Using the visualiser

JL_Cockpit allows to use the visualiser with your own training implementation. To use the visualiser, call the *visualiser* function and write the return value to a variable.

    vis = visualiser()

Just like with the *training_loop* execution, the optional arguments can be used to turn on or turn off the plots. To turn off the visualisation of the loss and gradient norm, run

    vis = visualiser(vis_loss = false, vis_grad_norm = false)

Before the training starts, the original parameter values should be passed to the visualiser, by pushing a *Datapoint* object to vis.datapoints.

    push!(vis.datapoints, Datapoint(-1, -1, nothing, nothing, Flux.params(model)))

Then the data from the training can be passed in each iteration of the training.

    push!(vis.datapoints, Datapoint(epoch, iteration, loss, grads, params))

The vis.datapoint object is a vector inside an Observable. This will ensure that the passed values are automatically used to calculate the metrics and update the plots.