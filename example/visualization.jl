using jl_cockpit

# you can set here the batch size and what you want to visulize
vis = visualiser(batch_size=128, vis_loss=true)

# define a hook to collect and plot data
on_batch_end = (epoch, i, loss, grads) -> begin
    push!(vis.datapoints, jl_cockpit.datapoint(epoch, i, loss, grads))
end

# run training with visualization callback
training_loop(on_batch_end=on_batch_end)
