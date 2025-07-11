# The following lines are copied from the Makie Docs Build script
# https://github.com/MakieOrg/Makie.jl/blob/master/docs/makedocs.jl
# They are necessary, so that the script can be executed via X11 on the headless server
using Pkg
cd(@__DIR__)
Pkg.activate(".")
Pkg.instantiate()
Pkg.precompile()

using JL_Cockpit
using Documenter

DocMeta.setdocmeta!(JL_Cockpit, :DocTestSetup, :(using JL_Cockpit); recursive=true)

makedocs(;
    modules=[JL_Cockpit],
    authors="Niklas Schlüter niklas.schlueter@tu-berlin.de",
    sitename="JL_Cockpit.jl",
    format=Documenter.HTML(;
        canonical="https://Themightyfirefly.github.io/JL_Cockpit.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Getting Started" => "getting_started.md",
        "API Reference" => [
            "Training and Visualisation API" => "API/training_api.md",
            "Plot Functions" => "API/plot_functions.md",
            "Utils" => "API/utils.md",
        ],
        "Internal Functions" => "internal.md"
    ],
)

deploydocs(;
    repo="github.com/Themightyfirefly/JL_Cockpit.jl",
    devbranch="main",
)
