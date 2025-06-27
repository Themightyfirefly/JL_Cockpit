# using Flux
# using MLDatasets
# using Statistics

# using GLMakie
# using LinearAlgebra

# using jl_cockpit

# dataset_train = MNIST(; split=:train)
# dataset_test = MNIST(; split=:test)

# x_train, y_train = jl_cockpit.preprocess(dataset_train)
# x_test, y_test = jl_cockpit.preprocess(dataset_test)

# batchsize = 128
# train_loader = Flux.DataLoader((x_train, y_train); batchsize=batchsize, shuffle=true);

# model = Chain(
#     Conv((5, 5), 1 => 6, relu),  # 1 input color channel
#     MaxPool((2, 2)),
#     Conv((5, 5), 6 => 16, relu),
#     MaxPool((2, 2)),
#     Flux.flatten,
#     Dense(256, 120, relu),
#     Dense(120, 84, relu),
#     Dense(84, 10),  # 10 output classes
# )

# loss_fn(ŷ, y) = Flux.logitcrossentropy(ŷ, y)

# optim = Flux.setup(Adam(3.0f-4), model)

# losses = Observable{Vector{Float32}}([])
# gradient_norms = Observable{Vector{Float32}}([])

# # creating a visualiser and passing the Observables
# cockpit_vis = visualiser()


# for epoch in 1:5

#     # Iterate over batches returned by data loader
#     for (i, (x, y)) in enumerate(train_loader)


#         # https://fluxml.ai/Flux.jl/stable/reference/training/zygote/
#         #   julia> Flux.withgradient(m -> m(3), model)  # this uses Zygote
#         #   (val = 14.52, grad = ((layers = ((weight = [0.0 0.0 4.4],), (weight = [3.3;;], bias = [1.0], σ = nothing), nothing),),))
#         # Compute loss and gradients of model w.r.t. its parameters
#         loss, grads = Flux.withgradient(m -> loss_fn(m(x), y), model)

#         # Update optimizer state
#         Flux.update!(optim, model, grads[1])

#         # Keep track of losses by logging them in `losses`
#         push!(losses, loss)
#         push!(gradient_norms, loss)

#         # Every fifty steps, evaluate the accuracy on the test set
#         # and print the accuracy and loss
        
#         #=if isone(i) || iszero(i % 50)
#             acc = accuracy(model, x_test, y_test) * 100
#             @info "Epoch $epoch, step $i:\t loss = $(loss), acc = $(acc)%"
#         end=#
        
#         # Without this sleep, the visualisation will not work. TBD why...
#         sleep(0)
#     end
# end

# #plot(losses; xlabel="Step", ylabel="Loss", yaxis=:log) # runs after training
