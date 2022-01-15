nextflow run script7.nf --reads 's3://zenofbucket/nf-testing/*_{1,2}.fq'  --outdir 's3://zenofbucket/nf-testing/results/' -profile cloud -w 's3://zenofbucket/nf-testing/work/' -process.queue 'queue_test_light' --with-container

#nextflow run test.nf -profile cloud -w 's3://zenofbucket/nf-testing/work/' -process.queue 'queue_test_light' --with-container



