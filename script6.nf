/* 
 * pipeline input parameters 
 */

nextflow.enable.dsl=2

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
    tag "$pair_id"
         
    input:
    path(index)
    tuple val(pair_id), path(reads)
 
    output:
    path(pair_id)
 
    script:
    """
    salmon quant --threads $task.cpus --libType=U -i $index -1 ${reads[0]} -2 ${reads[1]} -o $pair_id
    """
}

process fastqc {
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
 
process multiqc {
    publishDir params.outdir, mode:'copy'
       
    input:
    path qc_files

//path "data*/*"
//path config=params.multiqc
    
    output:
    path 'multiqc_report.html'
     
    script:
    """
    multiqc . 

    """
// cp $config/* .
// echo "custom_logo: \$PWD/log.png >> multiqc_config.yaml"
// multiqc -v .

} 


workflow test{

    take:
        transcriptome
	read_pairs_ch

    main:
        index(transcriptome)
        quantification(index.out, read_pairs_ch)
	fastqc(read_pairs_ch)
	multiqc(quantification.out.mix(fastqc.out).collect())
	

    emit:
	log0=read_pairs_ch
        log1=fastqc.out
	log2=multiqc.out
	mix0=quantification.out.mix(fastqc.out) | collect

}



include { foo as bar } from './test'
workflow {
    params.user_input=params.transcriptome_file

    take: 

    main:
	bar()

        test(params.user_input, read_pairs_ch)

//	test.out.log0.view()
//        test.out.log1.view()
	test.out.log2.view()
//	test.out.mix0.view()

 }


workflow.onComplete {
        log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/multiqc_report.html\n" : "Oops .. something went wrong" )
	

        sendMail( to: 'zqlaiyy@gmail.com',
          subject: 'Catch up',
          body: 'Hi, how are you!'
)
}
