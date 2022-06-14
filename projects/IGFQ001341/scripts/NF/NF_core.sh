export NXF_VER=21.10.3

export TOWER_ACCESS_TOKEN=BBB


/project/tgu/software/nextflow/nextflow \
-log /rds/general/project/genomics-facility-archive-2019/ephemeral/rnaseq/run.log \
-c /rds/general/project/genomics-facility-archive-2019/ephemeral/rnaseq/nextflow.conf \
run nf-core/rnaseq  -r 3.7 \
--input /rds/general/project/genomics-facility-archive-2019/ephemeral/rnaseq/nfcore_samplesheet.csv \
--aligner star_rsem \
--genome GRCh38 \
-profile singularity \
-with-tower http://igf-lims.cc.ic.ac.uk:8086/api \
--outdir test1 \
-dsl2 \
-resume \
-with-report -with-dag rnaseq.html \
--skip_biotype_qc
# https://github.com/nf-core/rnaseq/issues/460