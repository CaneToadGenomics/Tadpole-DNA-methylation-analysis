1. Map high-quality and adaptor-trimmed reads to cane toad genome (BS-Seeker2)
module load python/3.7.4
module load bowtie2
module load krb5/1.19.3
module load libssh/0.8.5

python /path/to/BSseeker2/bs_seeker2-align.py -i /path/to/input/file_trimmed.fq --aligner=bowtie2 -o /path/to/output/file.bam -g /path/to/genome/genome.fasta -r

python /path/to/BSseeker2/bs_seeker2-call_methylation.py --rm-SX --rm-CCGG -i /path/to/input/file.bam -o /path/to/output/file --db /path/to/BSseeker2/bs_utils/reference_genomes/genome.fasta_rrbs_20_500_bowtie2/


2. Call SNPs (CGmapTools)

cgmaptools snv -i /path/to/input/file.ATCGmap.gz -m bayes -v /path/to/output/file.vcf -o /path/to/output/file.snv --bayes-e = 0.01 --bayes-dynamicP


3. Compute depth of coverage for all mapped positions (SAMtools)
module load samtools/1.15.1
module load htslib/1.15.1

samtools depth /path/to/input/file.bam > /path/to/output/file.AverageCoverage


4. Variant filtering (VCFtools 0.1.14)
module load samtools/1.15.1
module load htslib/1.15.1
module load vcftools/0.1.14

bgzip -k < /srv/scratch/z3533697/ASMok/CGmaptools/snp2/${i}.DP.filtered.vcf > /srv/scratch/z3533697/ASMok/CGmaptools/snp2/${i}.DP.filtered.vcf.gz
tabix -p vcf /srv/scratch/z3533697/ASMok/CGmaptools/snp2/${i}.DP.filtered.vcf.gz

vcftools --vcf /srv/scratch/z3533697/ASMok/CGmaptools/snp2/B10.recode.vcf.recode.vcf --minDP 10 --maxDP 424 --remove-filtered-all --recode --recode-INFO-all --out /srv/scratch/z3533697/ASMok/CGmaptools/snp2/B10.DP
sed '/\.\/\./d' /srv/scratch/z3533697/ASMok/CGmaptools/snp2/B10.DP.recode.vcf > /srv/scratch/z3533697/ASMok/CGmaptools/snp2/B10.DP.filtered.vcf

(DP) < 10 and > 99.9th percentile


5. Predict allele-specific DNA methylation (CGmapTools)

module load samtools/1.15.1
module load r/4.3.1
module load python

cgmaptools asm -m ass -L 0.4 -H 0.6 -r /path/to/genome/genome.fasta -b /path/to/input/file.bam -l /path/to/input/file.filtered.vcf > /path/to/output/file.asm

cgmaptools asm -m ass -r /srv/scratch/z3533697/cane_toad/canetoad.v2.2.fasta -b /srv/scratch/rollins/Yagound-CaneToadMethylation-Mar24/BSseeker/B3.out.bam_sorted.bam -l /srv/scratch/z3533697/ASMok/CGmaptools/snp2/B3.DP.filtered.vcf > /srv/scratch/z3533697/ASMok/CGmaptools/asm/B3.default.asm
