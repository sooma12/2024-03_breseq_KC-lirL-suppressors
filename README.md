# 2024-03_breseq_KC-lirL-suppressors
MWS created 2024-03-15 

Analysis of Kate Corey's ∆lirL suppressor mutant genomes, isolated on SDS/EDTA

Scripts are derived from 2023-10-20_breseq (MWS last batch of ∆lirL suppressors)

## Methods from SeqCenter:
Illumina Sequencing Methods
Illumina sequencing libraries were prepared using the tagmentation-based and PCR-based
Illumina DNA Prep kit and custom IDT 10bp unique dual indices (UDI) with a target insert size of
280 bp. No additional DNA fragmentation or size selection steps were performed. Illumina
sequencing was performed on an Illumina NovaSeq X Plus sequencer in one or more multiplexed
shared-flow-cell runs, producing 2x151bp paired-end reads. Demultiplexing, quality control and
adapter trimming was performed with bcl-convert1 (v4.2.4). Sequencing statistics are included in
the ‘DNA Sequencing Stats.xlsx’ file.

Breseq setup if needed:
```bash
srun --partition=express --nodes=1 --cpus-per-task=2 --pty --time=00:60:00 /bin/bash
module load anaconda3/2021.05
conda create --prefix /work/geisingerlab/conda_env/breseq_env python=3.9
# Deal with CommandNotFoundError: Your shell has not been properly configured to use 'conda activate'.
conda init bash
source ~/.bashrc

conda activate /work/geisingerlab/conda_env/breseq_env

# Biopython tweaks
# Make .condarc file, then tell conda to check bioconda.
conda config 
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict

conda install -p /work/geisingerlab/conda_env/breseq_env breseq
```


## 1. Get data
Downloaded data via Box to shared desktop (downloads Zip file)
Note, I needed to download in multiple small pieces to avoid a "possible zip bomb" error
Unzipped using `unzip <zipfile>`

`cd` to resulting directory
Generated list of md5sums with `md5sum * > gz_md5sums.txt`
Ran this to verify integrity:
`python check_md5sums.py DNA\ Sequencing\ Stats.xlsx gz_md5sums.txt`

## 2. Fastqc
Ran fastqc using:
`sbatch sbatch_fastqc_2024-03-15.sh`

Interpreting FastQC (for Kate)
https://hbctraining.github.io/Intro-to-rnaseq-hpc-salmon/lessons/qc_fastqc_assessment.html

'Per base sequence quality': quality by position in read
- Expect a decrease from left to right (quality drop towards end of read); usually this is signal decay (fluor degradation e.g.) or phasing (loss of synch in cluster due to e.g. incomplete 3' terminator removal)
- Should be worried about instrument problems (sudden, lasting, large drop in quality, or individual cycles with low quality)  

'Per sequence quality scores': histogram of # of reads with specific score
- Ideally peak at high quality; be concerned if there are a lot at low quality

'Per base sequence content'
- Always fails for RNA-seq due to 'random' hexamer priming not actually being random (some bias)
- Issues here probably suggest a sample prep or sequencing method issue

'Per sequence GC content'
- Usually expect a central peak on the organism's GC content (17978 is ~40%)
- Sharp extra peaks would indicate issues with an overrepresented sequence
- Broad extra peaks suggest contamination with another organism

'Sequence duplication levels'
- Suggests some sequence(s) where there's a lot of copies
- Tells if this is a "low complexity" set of reads; in other words, there aren't a lot of diverse samples
- Can be due to low starting material (missing rare sequences), too much PCR amplification, ...

'Overrepresented sequences'
- IDs sequences found in >0.1% of reads
- Helps ID contaminating molecules like adapters
- Can BLAST these

## 3. Sample sheet preparation


## 4. Breseq array


## 5. Analysis


Try gdtools COMPARE (part of breseq package)
POTENTIALLY USEFUL: gdtools APPLY -f GENBANK -o updated.gbk -r reference.gbk input.gd
-> Lets you create an updated genbank file containing the mutations from a breseq run to use as a new reference...
-> Try this with MSA9/11/13!!