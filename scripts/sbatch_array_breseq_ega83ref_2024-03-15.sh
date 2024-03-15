#!/bin/bash
#SBATCH --partition=short
#SBATCH --job-name=breseq_array
#SBATCH --time=04:00:00
#SBATCH --array=1-10%11
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mem=100G
#SBATCH --output=/work/geisingerlab/Mark/
#SBATCH --error=/work/geisingerlab/Mark/
#SBATCH --mail-type=END,FAIL
#SBATCH --open-mode=append
#SBATCH --mail-user=soo.m@northeastern.edu

## MWS March 15, 2024
## TODO: I added open-mode=append to sbatch header and added 'echo' before the breseq command.  See what this does to logs.

# Files; note that I needed to use plasmid genbank files instead of gff3.  EGA83ref.gff3 has the ##FASTA at the bottom.. maybe why it works?  unclear to me
REFERENCE_CHR=/work/geisingerlab/Mark/REF_GENOMES/AB_17978_ega83/EGA83ref.gff3
REFERENCE_PAB1=/work/geisingerlab/Mark/REF_GENOMES/AB_17978_ega83/CP000522.gbk
REFERENCE_PAB2=/work/geisingerlab/Mark/REF_GENOMES/AB_17978_ega83/CP000523.gbk
REFERENCE_PAB3=/work/geisingerlab/Mark/REF_GENOMES/AB_17978_ega83/CP012005.gbk
WORK_DIR=
SAMPLE_SHEET=${WORK_DIR}/
# Output filepath; bash magic below will make individual output filepaths by strain ID
OUT_PATH=${WORK_DIR}/breseq_output

echo "Starting breseq SBATCH script $(date)"

mkdir -p $OUT_PATH

echo "Loading environment and tools"
module load anaconda3/2021.05
eval "$(conda shell.bash hook)"
conda activate /work/geisingerlab/conda_env/breseq_env

# Run breseq
# -r options specify reference genome(s)
# Pass fastq files after reference genomes

name=`sed -n "$SLURM_ARRAY_TASK_ID"p $SAMPLE_SHEET |  awk '{print $1}'`
r1=`sed -n "$SLURM_ARRAY_TASK_ID"p $SAMPLE_SHEET |  awk '{print $2}'`
r2=`sed -n "$SLURM_ARRAY_TASK_ID"p $SAMPLE_SHEET |  awk '{print $3}'`

echo "Running breseq on files $r1 and $r2"
echo breseq -r ${REFERENCE_CHR} -r ${REFERENCE_PAB1} -r ${REFERENCE_PAB2} -r ${REFERENCE_PAB3} -o ${OUT_PATH}/${name} ${r1} ${r2}

echo "cleaning up"
rm R1.list R2.list

echo "breseq script complete $(date)"
