/* 
 * pipeline input parameters 
 */
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


//read_pairs_ch = Channel.fromFilePairs(params.reads)

Channel
    .fromFilePairs( params.reads, checkIfExists: true )
    .set { read_pairs_ch }


//read_pairs_ch.view()

process quantification {

    input:
        tuple pair_id, path(reads) from read_pairs_ch

    output:
        stdout into printout_ch
        
    """
    echo $pair_id
    echo $reads
    echo ${reads[0]}

    """
}

printout_ch.view()

//tuple pair_id, path(reads) from read_pairs_ch 
//println(params.reads)

//println(pair_id)
//println(path(reads))
//println(reads)
