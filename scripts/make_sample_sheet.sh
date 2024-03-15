#!/bin/bash
## make_sample_sheet.sh
# Generate a sample sheet containing
# Usage: `bash make_sample_sheet.sh`

# IMPORTANT NOTE: file paths to fastq and sample_sheet.txt are hard-coded. Sample sheet construction code relies on specific file paths (see lines 29-34).

# Location of fastq files
WORK_DIR=/work/geisingerlab/Mark/breseq_suppressor_mutations/2024-03_breseq_KC-lirL-suppressors
IN_PATH=${WORK_DIR}/data/fastq
# Output filepath; bash magic below will make individual output filepaths by strain ID
SAMPLE_SHEET=${WORK_DIR}/data/fastq/sample_sheet.txt

# bash magic to get file lists and create a sample sheet (lists paired files for each strain)
# See https://www.biostars.org/p/449164/

# Create .list files with R1 and R2 fastqs.  Sort will put them in same orders, assuming files are paired
find $IN_PATH -maxdepth 1 -name "*.fastq" | grep -e "_R1" | sort > R1.list ;
find $IN_PATH -maxdepth 1 -name "*.fastq" | grep -e "_R2" | sort > R2.list ;

# For debug purposes... delete sample sheet if it exists
if [ -f "${SAMPLE_SHEET}" ] ; then
  rm "${SAMPLE_SHEET}"
fi

# make sample sheet from R1 and R2 files.  Format on each line looks like (space separated):
# MSA# /path/to/MSA#_R1.fastq /path/to/MSA#_R2.fastq
# from sample sheet, we can access individual items from each line with e.g. `awk '{print $3}' sample_sheet.txt`
paste R1.list R2.list | while read R1 R2 ;
do
    outdir_root=$(echo "${R2}" | cut -f7 -d"/" | cut -f1 -d"_") ;
    sample_line="${outdir_root} ${R1} ${R2}" ;
    echo "${sample_line}" >> $SAMPLE_SHEET
done

echo 'Sample sheet contents:'
cat $SAMPLE_SHEET
