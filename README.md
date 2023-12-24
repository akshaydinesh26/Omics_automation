## Omics automation
Omics data analysis automation scripts and other data processing scripts.

# Processing scripts
  **count_aa.py**
  
  script to count amino acids in each sequences from a fasta file. multifasta input is also fine.
  The output is a matrix with sequence ids as rows and amino acids as columns.

  **WGS alignment**

  automation scripts for Whole Genome Sequencing Reseq data analysis when there is a reference genome.
  The usage of the scripts follows;
    $ Add user input required on the head portion of the script and understand the positional arguments required from comments
    $ execute the script in the same direcotry as the input files to be used.
  
  _scripts_

  1. alignment_short.sh

     short paired end reads are nowadays more common than single end reads. So, this script is only for paired-end short reads.
     execute this script as;
       ```````console
       ./alignment_short.sh inlist output_folder aligner_name
       ```````
       inlist - a csv file of the input samples and readname in the following format.\
                samplename,readname like hum1,ERR123.\
                readname should be common for both the read files. READS SHOULD BE NAMED AS "readname_[1/2].fq.gz".<br>
       output_folder - full path of the folder to save bam files.<br>
       aligner_name - name of the short read aligner to use. it should be,<br>
                bowtie/bowtie2/bwa\<br>

     make sure that aligner you choose and samtools are available in the path.
  
  2. process_bam.sh

     script to process the alignment bam file from the above script to variant callers.\
     make sure samtools is in the path.\
     run script in folder containing bam files as; 
       ```console
       ./process_bam.sh
       ```

  3. varscan2.sh
     
     script to process the bam file to mpileup and to call snp and indels from the mpileup file with varscan2.\
     make sure samtools and java version compatible with varscan2 jarfile is available in the path.\
     run the script in the folder with processed bam file.\
      ```console
       ./varscan2.sh
       ```

  alternatively, you can process the bam file and call variants using picard and GATK.\

  4. process_bam_picard.sh
 
    script to process the alignment bam file for GATK using picard tools.\
    run script in folder containing bam files as;\ 
      ```console
       ./process_bam_picard.sh
       ```
   