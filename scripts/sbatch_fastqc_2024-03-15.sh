#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=fastqc
#SBATCH --time=04:00:00
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --output=/work/geisingerlab/Mark/breseq_suppressor_mutations/2024-03_breseq_KC-lirL-suppressors/logs/%x-%j.out
#SBATCH --error=/work/geisingerlab/Mark/breseq_suppressor_mutations/2024-03_breseq_KC-lirL-suppressors/logs/%x-%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=soo.m@northeastern.edu

echo "Starting fastqc SBATCH script $(date)"

echo "Loading environment and tools"
#fastqc requires OpenJDK/19.0.1
module load OpenJDK/19.0.1
module load fastqc/0.11.9

WORK_DIR=/work/geisingerlab/Mark/breseq_suppressor_mutations/2024-03_breseq_KC-lirL-suppressors
FASTQDIR=${WORK_DIR}/data/fastq
OUT_DIR=${WORK_DIR}/output/fastqc
SCRIPT_DIR=${WORK_DIR}/scripts

mkdir -p $FASTQDIR $OUT_DIR $SCRIPT_DIR

echo "Running fastqc in directory $FASTQDIR"
fastqc $FASTQDIR/*.fastq

echo "Cleaning up logs and output files"
mkdir -p $SCRIPT_DIR/logs
mv $SCRIPT_DIR/fastq_breseq_* $SCRIPT_DIR/logs
mkdir -p $OUT_DIR/fastqc_html $OUT_DIR/fastqc_zip
mv $FASTQDIR/*fastqc.html $OUT_DIR/fastqc_html
mv $FASTQDIR/*fastqc.zip $OUT_DIR/fastqc_zip
