module load anaconda3/personal
source activate snakemake

cd /rds/general/project/genomics-facility-archive-2019/ephemeral/IGFQ001345_mitchell_14-2-2022_GlobinDepletion
export SNAKEMAKE_OUTPUT_CACHE=/project/tgu/resources/pipeline_resource/snakemake/cache_dir

snakemake \
  --use-singularity \
  --use-conda \
  --singularity-args="-B /rds/general/project/genomics-facility-archive-2019/ephemeral/IGFQ001345_mitchell_14-2-2022_GlobinDepletion,/project/tgu/resources/pipeline_resource/snakemake,$EPHEMERAL:/tmp" \
  --cluster-config cluster.json \
  -j 20 \
  --cluster "qsub -V -o /dev/null -e /dev/null -lwalltime=08:00:00  -lselect=1:ncpus={cluster.ncpus}:mem={cluster.mem}gb" \
  --rerun-incomplete \
  --configfile /rds/general/project/genomics-facility-archive-2019/ephemeral/IGFQ001345_mitchell_14-2-2022_GlobinDepletion/config.yaml \
  --snakefile /project/tgu/resources/pipeline_resource/snakemake/workflow/rna-seq-star-deseq2/workflow/Snakefile \
  --conda-prefix /project/tgu/resources/pipeline_resource/snakemake/conda_prefix_dir \
  --singularity-prefix /project/tgu/resources/pipeline_resource/snakemake/singularity_prefix_dir \
  --cache \
  --latency-wait 60 # \
  #--report report.zip
