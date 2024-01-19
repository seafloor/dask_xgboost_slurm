#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=12:00:00
#SBATCH --job-name=daskxgb
#SBATCH --mem=90G
#SBATCH --signal=B:SIGUSR1@120
#SBATCH --mail-type=end
#SBATCH --mail-type=fail
#SBATCH --mail-type=begin
#SBATCH -o dasktest.o.%J
#SBATCH -e dasktest.o.%J

# setup python env
module load python_module  # replace with python/conda module
conda activate env_name  # replace with env name

# input dirs
scriptdir=""  # location for python scripts e.g. $HOME/dask_xgboost_slurm/scripts
data_dir=""

# convert raw to hdf5
python3 ${scriptdir}/adjust_hdf5_for_covars.py \
    --train ${data_dir}/train.hdf5 \
    --test ${data_dir}/test.hdf5 \
    --covar /scratch/user/covar.txt \
    --out_train ${data_dir}/train_adjusted.hdf5 \
    --out_test ${data_dir}/test_adjusted.hdf5
