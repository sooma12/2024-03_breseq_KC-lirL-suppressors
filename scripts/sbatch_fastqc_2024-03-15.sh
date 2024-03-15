#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=fastqc
#SBATCH --time=04:00:00
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --output=/work/geisingerlab/Mark/
#SBATCH --error=/work/geisingerlab/Mark/
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=soo.m@northeastern.edu

echo "Starting fastqc SBATCH script $(date)"

echo "Loading environment and tools"
#fastqc requires OpenJDK/19.0.1
module load OpenJDK/19.0.1
module load fastqc/0.11.9

FASTQDIR=/work/geisingerlab/Mark/2023-10_breseq_lirL-suppressors/input
OUT_DIR=/work/geisingerlab/Mark/2023-10_breseq_lirL-suppressors/fastqc_output
SCRIPT_DIR=/work/geisingerlab/Mark/2023-10_breseq_lirL-suppressors/scripts

mkdir -p $FASTQDIR $OUT_DIR $SCRIPT_DIR

echo "Running fastqc in directory $FASTQDIR"
fastqc $FASTQDIR/*.fastq

echo "Cleaning up logs and output files"
mkdir -p $SCRIPT_DIR/logs
mv $SCRIPT_DIR/fastq_breseq_* $SCRIPT_DIR/logs
mkdir -p $OUT_DIR/fastqc_html $OUT_DIR/fastqc_zip
mv $FASTQDIR/*fastqc.html $OUT_DIR/fastqc_html
mv $FASTQDIR/*fastqc.zip $OUT_DIR/fastqc_zip



