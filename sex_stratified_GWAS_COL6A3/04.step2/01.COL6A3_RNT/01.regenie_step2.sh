#!/bin/bash
#SBATCH --job-name=step2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=96GB
#SBATCH -t 56:00:00
#SBATCH -o ./log/output.%j.out
#SBATCH -e ./log/output.%j.err
#SBATCH --array 1-22%10
cd $SLURM_SUBMIT_DIR

# conda
source ~/anaconda3/etc/profile.d/conda.sh
conda activate regenie

mkdir -p output/

regenie \
  --step 2 \
  --bgen path-to-wd/04.merge_imputed_files/per_chr_bgen_files/${SLURM_ARRAY_TASK_ID}.qc.bgen \
  --sample /project/richards/restricted/ukb-27449/data/ukb27449_imp_chr1_v3_s487395_20210201.sample \
  --chr ${SLURM_ARRAY_TASK_ID} \
  --covarFile path-to-wd/03.pheno/01.COL6A3_RNT/02.covariate.tsv \
  --phenoFile path-to-wd/03.pheno/01.COL6A3_RNT/02.pheno.tsv \
  --bsize 200 \
  --phenoCol Protein_level \
  --threads 20 \
  --remove path-to-wd/remove.tsv \
  --pred path-to-wd/05.step1/01.COL6A3_RNT/fit_bin_out_pred.list --ref-first \
  --out output/COL6A3.chr${SLURM_ARRAY_TASK_ID}
  