#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --job-name=daskxgb
#SBATCH --mem=40G
#SBATCH --signal=B:SIGUSR1@120
#SBATCH --mail-type=end
#SBATCH --mail-type=fail
#SBATCH --mail-type=begin
#SBATCH -o dasktest.o.%J
#SBATCH -e dasktest.o.%J

# set params for conversion
scriptdir=""  # location for python scripts e.g. $HOME/dask_xgboost_slurm/scripts
nrow_read_raw=5000
dask_chunk_size=100
plinkfile=""  # full path for plink bed/bim/fam file without extension
recodedallelefile=""  # full path for txt file to specify allele coding via --recode-allele in plink
dtype="float16"
plinkdir=""  # path to load plink from if not in PATH

## handle tmp dir and job trap
## optional copying data to tmp directory and deleting it before job finishes
trap "rm -r /tmp/user_${SLURM_JOB_ID}" SIGUSR1
mkdir /tmp/user_${SLURM_JOB_ID}
chmod 700 /tmp/user_${SLURM_JOB_ID}

# setup python env
module load python_module  # replace with python/conda module
conda activate env_name  # replace with env name

# convert to raw with plink
if [ -s "${plinkfile}.raw" ]
then
    echo "--> File ${plinkfile}.raw already exists - skipping plink conversion"
else
    ${plinkdir}/plink --bfile $plinkfile --recode A --recode-allele $recodedallelefile --out $plinkfile
fi

# shuffle on command line
if [ -s "${plinkfile}_shuffled.raw" ]
then
    echo "--> File ${plinkfile}_shuffled.raw already exists - skipping row shuffling."
else
    awk "(NR == 1) {print $0}" ${plinkfile}.raw > ${plinkfile}_shuffled.raw
    awk "(NR > 1) {print $0}" ${plinkfile}.raw | shuf >> ${plinkfile}_shuffled.raw
fi

# set nrows from fam file
wc_fam=($(wc -l ${plinkfile}.fam))
nrow_fam=${wc_fam[0]}

# convert raw to hdf5
python3 ${scriptdir}/convert_to_hdf5.py \
    --in_raw ${plinkfile}_shuffled.raw \
    --out_hdf5 ${plinkfile}_shuffled \
    --nrows ${nrow_fam} \
    --dask_chunks ${dask_chunk_size} \
    --read_raw_chunk_size ${nrow_read_raw} \
    --dtype ${dtype}

# remove dask files
rm -r /tmp/user_${SLURM_JOB_ID}
