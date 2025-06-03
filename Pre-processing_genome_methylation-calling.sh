1. Check raw reads quality (FastQC)
module load fastqc/0.11.9
module load python/3.7.4
module load multiqc/1.13

fastqc /path/to/input/file_R*_001.fq.gz --threads 2 --extract --outdir=/path/to/output/multiqc /path/to/output

2. Trim adaptors and low quality reads (TrimGalore) ### This code uses non-directional mode. May need to be adjusted.
module load trimgalore/0.6.10

trim_galore --non-directional --paired -q 30 --rrbs /path/to/input/file_R1_001.fq.gz /path/to/input/file_R2_001.fq.gz --output_dir /path/to/output

3. Check trimmed reads quality (FastQC)
module load fastqc/0.11.9
module load python/3.7.4
module load multiqc/1.13

fastqc /path/to/input/file_R*_001_trimmed.fq.gz --threads 2 --extract --outdir=/path/to/outputmultiqc /path/to/output

4. Prepare bisulfite genome (Bismark) ### This step only needs to be performed once for each reference genome.
module load bismark/0.23.0
module load hisat2/2.2.0

bismark_genome_preparation --hisat2 --verbose /path/to/genome/

5. Map reads to bisulfite genome (Bismark)
module load bismark/0.23.0
module load hisat2/2.2.0

bismark --non_directional --hisat2 --genome /path/to/genome/ -1 /path/to/file_R1_001_trimmed.fq.gz -2 /path/to/file_R2_001_trimmed.fq.gz --output_dir /path/to/output/ --temp_dir /path/to/temp/

6. Extract methylation calls (Bismark)
module load bismark/0.23.0
module load samtools/1.15.1

bismark_methylation_extractor -p --gzip --bedGraph --buffer_size 10G --genome_folder /path/to/genome/ /path/to/input/ --output /path/to/output/

