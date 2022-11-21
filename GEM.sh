#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=GEM
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=70:00:00
#SBATCH --mem=30000
#SBATCH --output=GEM.%j.out
#SBATCH --error=GEM.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL
#SBATCH --array=1-22

i=$SLURM_ARRAY_TASK_ID

cd /scratch/ahc87874/Fall2022

ml GEM/1.4.3-intel-2020b

genodir=("/scratch/ahc87874/Fall2022/geno")
phenodir=("/scratch/ahc87874/Fall2022/pheno")
outdir=("/scratch/ahc87874/Fall2022/GEM")
mkdir -p $outdir

phenotypes=("w3FA_NMR" "w3FA_NMR_TFAP" "w6FA_NMR" "w6FA_NMR_TFAP" "w6_w3_ratio_NMR" 
"DHA_NMR" "DHA_NMR_TFAP" "LA_NMR" "LA_NMR_TFAP" "PUFA_NMR" "PUFA_NMR_TFAP" "MUFA_NMR" 
"MUFA_NMR_TFAP" "PUFA_MUFA_ratio_NMR")

exposures=("CSRV" "SSRV")

for j in ${phenotypes[@]} 
        do

for e in ${exposures[@]} 
        do

mkdir -p $outdir/$j

echo running "$j" and "$e"

GEM \
--bgen $genodir/chr"$i".bgen \
--sample $genodir/chr"$i".sample \
--pheno-file $phenodir/GEMpheno.csv \
--sampleid-name IID \
--pheno-name $j \
--covar-names Sex Age Townsend \
PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 \
--robust 1 \
--exposure-names "$e" \
--thread 16 \
--out $outdir/$j/"$j"x"$e"-chr"$i"

done
done