#!/bin/bash
#SBATCH --partition mpcb.p
#SBATCH --nodes 1
#SBATCH --tasks-per-node 1
#SBATCH --cpus-per-task 16
#SBATCH --time 14-00:00:00
#SBATCH --mem-per-cpu 30000
#SBATCH --job-name job_name
#SBATCH --output vcf2p_%j.txt

module load hpc-env/8.3
sleep 30
module load Python/3.7.4-GCCcore-8.3.0
sleep 30

##file conversion from .vcf to alignments, e.g .nexus or .phy
python vcf2phylip.py -i /path/to/vcf.vcf --output-folder /path/to/output_dir --output-prefix rDNA -m 4 -f -n -b 
