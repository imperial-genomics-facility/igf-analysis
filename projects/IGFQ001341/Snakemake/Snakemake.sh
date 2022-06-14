snakemake \
	--cores 4 \
	--use-singularity \
	--use-conda \
	--singularity-args="-B /rds/general/project/genomics-facility-archive-2019/ephemeral/rnaseq,/rds/general/project/genomics-facility-archive-2019/ephemeral/rnaseq/snakemake/rna-seq-star-deseq2/tmp:/tmp -C" \
	--cluster-config cluster.json \
	-j 20 \
	--cluster "qsub -o /dev/null -e /dev/null -V -lwalltime=08:00:00  -lselect=1:ncpus={cluster.ncpus}:mem={cluster.mem}gb" \
	--rerun-incomplete