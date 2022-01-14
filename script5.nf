nextflow.enable.dsl=2
/* pipeline input parameters */


params.reads = "$baseDir/data/ggal/gut_{1,2}.fq"
params.transcriptome_file = "$baseDir/data/ggal/transcriptome.fa"
params.multiqc = "$baseDir/multiqc"
params.outdir = "results"

log.info """\
         R N A S E Q - N F   P I P E L I N E    
         ===================================
         transcriptome: ${params.transcriptome_file}
         reads        : ${params.reads}
         outdir       : ${params.outdir}
         """
         .stripIndent()

 
/* 
 * define the `index` process that create a binary index 
 * given the transcriptome file
*/


process index {
    
input:
path transcriptome
     
output:
path 'index'

script: 
"""
salmon index --threads $task.cpus -t $transcriptome -i index
"""
}


Channel 
    .fromFilePairs( params.reads, checkIfExists: true )
    .set { read_pairs_ch } 

process quantification {
     
    input:
    path index
    tuple val(pair_id), path(reads)
 
    output:
    path pair_id
 
    script:
    """
    salmon quant --threads $task.cpus --libType=U -i $index -1 ${reads[0]} -2 ${reads[1]} -o $pair_id
    """
}

process fastqc {
    publishDir "/home/zql/tools/nextflow/nf-training/result_test"
    tag "FASTQC on $pair_id"

    input:
    tuple val(pair_id), path(reads)

    output:
    path "fastqc_${pair_id}_logs"

    script:
    """
    mkdir fastqc_${pair_id}_logs
    fastqc -o fastqc_${pair_id}_logs -f fastq -q ${reads}
    """  
}





workflow { 
    index(params.transcriptome_file)
    index.out.view()

    quantification(index.out, read_pairs_ch)
    quantification.out.view()

    fastqc(read_pairs_ch.take(2))

    
}
