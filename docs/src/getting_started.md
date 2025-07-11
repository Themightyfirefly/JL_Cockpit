# Getting started

We have created a package to provide a modular monitoring and debugging pipeline for training neural networks, implementing a modular training loop using Flux.jl.
This package allows users to specify observable quantities (e.g. gradient norm, curvature).
Users can see the live dashboard that we implemented with Makie.jl.

The **JL_Cockpit** module provides plots for the live visualisation for neural network training. It uses the GLMakie module and their *Observable* to provide the live functionality.


# Example Workflow
To add the JL_Cockpit module to your Julia environment run

    ]
    add https://github.com/Themightyfirefly/JL_Cockpit

Once the module has been added, activate the module

    using JL_Cockpit

To run the visualised training, execute

    training_loop()

During the visualisation, users can press the r key to reset the plots (in case they zoomed into one) and the s key to save a screenshot of the current figure.