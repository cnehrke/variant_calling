#!/bin/bash
#SBATCH --partition mpcb.p
#SBATCH --nodes 1
#SBATCH --tasks-per-node 1
#SBATCH --cpus-per-task 16
#SBATCH --time 14-00:00:00
#SBATCH --mem-per-cpu 30000
#SBATCH --job-name job_name
#SBATCH --output vc_%j.txt

## load environment and module
module load hpc-env/8.3
module load parallel
module load Miniconda3/4.9.2

##manual activate conda env

## Variant calling pipeline
bwa index /path/to/reference.fasta
ls /path/to/dir/with/reads/*.fastq.gz | cut -d/ -f6 | cut -d. -f1 | cut -d_ -f1 | sort | uniq > sample_names.txt
cat sample_names.txt | parallel "bwa mem /path/to/reference.fasta /path/to/dir/with/reads/{}_R1_clipped.fastq.gz /path/to/dir/with/reads/{}_R2_clipped.fastq.gz > {}.aligned.sam"
cat sample_names.txt | parallel "samtools view -S -b {}.aligned.sam > {}.aligned.bam"
cat sample_names.txt | parallel "samtools sort -o {}.aligned.sorted.bam {}.aligned.bam"
cat sample_names.txt | sed -i s/$/.aligned.sorted.bam/ sample_names.txt 
cat sample_names.txt | parallel "bcftools mpileup -O b -B -I --threads 16 --bam-list sample_names.txt -o assembly_name.raw.bcf \
-f /path/to/reference.fasta"
bcftools call -m -v --output assembly_name.variants.vcf assembly_name.raw.bcf
vcfutils.pl varFilter assembly_name.variants.vcf > assembly_name.final_variants.vcf


