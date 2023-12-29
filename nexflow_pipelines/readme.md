*** Nextflow Bioinfomatics Pipelines ***

**RNAseq1.nf**

Nextflow pipeline for RNAseq data analysis which uses salmon for transcriptome based quantification. Output is salmon output with multiqc report.
make sure all the programs are found in docker container

**RNAseq2.nf**

Nextflow pipeline for RNAseq data analysis which uses kallisto for transcriptome based quantification. Output is kallisto output with multiqc report.

**qc_reads.nf**

automating generation of fastqc and multiqc reports.
makesure reads are in Project Directory in a folder named rawReads with naming format of "samplename_[1/2].fq.gz"
programs should be in seperate conda environments

# before exccuting

if miniconda3 folder is not in home folder make sure to update the location of tools.
update the conda environment names
results will be in qcReport folder in project directory.