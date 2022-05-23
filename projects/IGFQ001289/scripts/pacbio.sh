#PBS -lselect=1:ncpus=16:mem=64gb
#PBS -lwalltime=04:00:00


module load anaconda3/personal

source activate qiime2-2022.2

cd /rds/general/project/genomics-facility-archive-2019/ephemeral/PACBIO/run2

qiime tools import --type 'SampleData[SequencesWithQuality]' \
 --input-path sample.manifest \
 --output-path samples.qza \
 --input-format SingleEndFastqManifestPhred33V2


qiime demux summarize --i-data samples.qza \
 --o-visualization samples.demux.summary.qzv


qiime dada2 denoise-ccs --i-demultiplexed-seqs ./samples.qza \
 --o-table dada2-ccs_table.qza \
 --o-representative-sequences dada2-ccs_rep.qza \
 --o-denoising-stats dada2-ccs_stats.qza \
 --p-min-len 1000 --p-max-len 1600 \
 --p-front AGRGTTYGATYMTGGCTCAG --p-adapter RGYTACCTTGTTACGACTT \
 --p-n-threads 16


qiime metadata tabulate --m-input-file ./dada2-ccs_stats.qza \
 --o-visualization ./dada2-ccs_stats.qzv


qiime feature-table summarize --i-table ./dada2-ccs_table.qza \
 --m-sample-metadata-file metadata.tsv \
 --o-visualization ./dada2-ccs_table.qzv


qiime diversity alpha-rarefaction --i-table dada2-ccs_table.qza \
 --m-metadata-file metadata.tsv \
 --o-visualization ./alpha-rarefaction-curves.qzv \
 --p-min-depth 10 --p-max-depth 10000



qiime feature-classifier classify-consensus-vsearch --o-classification ./taxonomy.vsearch.qza \
 --i-query dada2-ccs_rep.qza \
 --i-reference-reads ../references/silva-138-99-seqs.qza \
 --i-reference-taxonomy ../references/silva-138-99-tax.qza  \
 --p-threads 16 \
 --p-maxrejects 100 --p-maxaccepts 10 --p-perc-identity 0.97



qiime metadata tabulate --m-input-file ./taxonomy.vsearch.qza \
 --o-visualization taxonomy.vsearch.qzv


qiime tools export --input-path taxonomy.vsearch.qza \
 --output-path tax_export


qiime taxa barplot --i-table dada2-ccs_table.qza \
 --i-taxonomy taxonomy.vsearch.qza \
--m-metadata-file ./metadata.tsv \
 --o-visualization ./taxa_barplot.qzv


qiime phylogeny align-to-tree-mafft-fasttree --i-sequences dada2-ccs_rep.qza \
 --output-dir phylogeny-align-to-tree-mafft-fasttree


qiime diversity core-metrics-phylogenetic --i-table ./dada2-ccs_table.qza \
 --i-phylogeny ./phylogeny-align-to-tree-mafft-fasttree/rooted_tree.qza \
 --m-metadata-file ./metadata.tsv \
 --p-sampling-depth 9000 \
 --output-dir ./core-metrics-results


qiime diversity beta-group-significance --i-distance-matrix core-metrics-results/bray_curtis_distance_matrix.qza \
 --m-metadata-file metadata.tsv --m-metadata-column condition \
 --o-visualization core-metrics-results/bray_curtis_bet_div_comp.qzv \
 --p-pairwise