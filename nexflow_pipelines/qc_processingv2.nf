#!/usr/local/bin/env nextflow

// version 2
// quality control of rawreads with reporting in multiqc format and fastqc format html files.
// reads should be in rawReads folder in basedir(where thi script is present) and in format "name_[1/2].fq.gz"
// processed reads should be in "hqReads" folder
//  fastqc and multiqc should be in conda environment.

params.reads="$projectDir/rawReads/*_{1,2}.fastq.gz"
params.outdir="$projectDir/hqReads"
params.triml=40
params.len=75


// #location of programs please update
params.fastp="/home/akshay/miniconda3/envs/fastp"

log.info """\

            QC Reads Processing Workflow
            Raw Reads          : "${params.reads}"
            fastp location    : "${params.fastp}"
            output directory   : "${params.outdir}"

"""

process processRun {
  cpus 8
  conda "${params.fastp}"
  publishDir "${params.outdir}", mode: 'copy'
  tag "fastp on $sample_id"

  input:
  tuple val(sample_id), path(reads)
  val trim
  val len

  
  output:
   stdout
  path "${sample_id}.html"
  path "${sample_id}.json"
  path "filt_${sample_id}_1.fastq.gz"
  path "filt_${sample_id}_2.fastq.gz"

  script:
  """
  $projectDir/fastp.sh ${reads[0]} ${reads[1]} ${sample_id} $trim $len ${task.cpus}
  """
}

workflow {
  channel.fromFilePairs(params.reads, checkIfExists: true).set{ reads_ch }
  channel.value(params.triml).set{ trim_ch }
  channel.value(params.len).set{ len_ch }
  fastp_ch = processRun(reads_ch,trim_ch,len_ch)
}