#!/bin/zsh
ROOT_DIR=/Users/mws/Documents/geisinger_lab_research/bioinformatics_in_acinetobacter/2023-10_lirL_suppressor_msa129_WGS/2023-10-20_breseq
SCRIPT_DIR=${ROOT_DIR}/scripts
BRESEQ_OUT_DIR=${ROOT_DIR}/breseq_output/2023-11-22
OUT_DIR=${ROOT_DIR}/breseq_output/2023-11-22/cat_outs

mkdir -p ${OUT_DIR}

find ${BRESEQ_OUT_DIR} -depth 1 > output_dirs.list

# Written for filepaths like: /Users/mws/Documents/geisinger_lab_research/bioinformatics_in_acinetobacter/lirL_suppressor_mutations_breseq/2023-10-20_breseq/breseq_output/output_zips/MSA152
paste output_dirs.list| while read directory ;
do
  rootname=$(echo ${directory} | cut -f11 -d"/")
  python ${SCRIPT_DIR}/cat_breseq.py -i ${directory} -o ${OUT_DIR}
  mv ${OUT_DIR}/Predicted_Mutations_all.txt ${OUT_DIR}/${rootname}_predicted_mutations.txt
  mv ${OUT_DIR}/Unassigned_new_junction_evidence_all.txt ${OUT_DIR}/${rootname}_unassigned_new_junction_evidence.txt
done
