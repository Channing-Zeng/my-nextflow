// anno
params.reads = "$baseDir/data/ggal/*_{1,2}.fq"
params.transcriptome_file = "$baseDir/data/ggal/transcriptome.fa"
params.multiqc = "$baseDir/multiqc"

params.outdir = "$baseDir/myresult" //inserted
//println "$params.outdir"  // inserted

//println "reads: $params.reads"

log.info """\
         R N A S E Q - N F   P I P E L I N E
         ===================================
         transcriptome: ${params.transcriptome_file}
         reads        : ${params.reads}
         outdir       : ${params.outdir}
         """.stripIndent()
 
