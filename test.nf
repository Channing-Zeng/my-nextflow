nextflow.enable.dsl=2

process foo {
    println(0)

    output:
        stdout
    script:
    """
	which fastqc
	which python
	cp $reads .
    """
}

workflow{
foo()
foo.out.view()
}
