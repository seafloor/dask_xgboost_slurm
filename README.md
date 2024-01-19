# Core scripts to run distributed XGBoost on SLURM clusters

## Hello ECR informatics people :wave:

I've put some code here for handling file conversions, fitting and CV. With it you should be good to get setup with datasets and fit a model. This isn't a full pipeline release though, so what's not here is other steps of the pipeline which are downstream, or a cohesive workflow or container etc.

Before running anything please go through the submission scripts to add any hardcoded paths etc. :)

## Setup

Create a local conda environment with:

- git clone https://github.com/seafloor/dask_xgboost_slurm.git
- cd dask_xgboost_slurm
- conda env create -f environment.yml

## Submitting SLURM scripts
Scripts need to be called with additional flags in the sbatch submission, e.g.:

- sbatch --mail-user=email --account slurmacctnum -p queuename SLURM_submit_plink_to_hdf5.sh
