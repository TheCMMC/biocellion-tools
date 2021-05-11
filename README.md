# Biocellion tools
This repository contains a variety of scripts and tools to run biocellion simulations and to manipulate and plot output for the CMMC research on cultivated meat. Visit www.thecmmc.org for more information about the Cultivated Meat Modeling Consortium (CMMC) and their projects.

## Getting started
To run the python scripts and notebooks in this repository it is recommended to use conda.
1. [Install conda](https://conda.io/projects/conda/en/latest/user-guide/install/download.html)
2. [Clone this repository](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository)
3. With conda installed run `conda env create -f environment.yml` inside your local clone of this repository to create the environment
4. Run `conda activate biocellion-tools` to activate the environment
5. Run `jupyter lab` to start a jupyter lab session in which you can open the notebook "biocellion_output_plotting.ipynb".