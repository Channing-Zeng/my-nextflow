nextflow.enable.dsl=2

process foo {
    println(0)

    output:
        stdout
    script:
    """
	whoami
	ls -ld /tmp
    """
}

workflow{
foo()
foo.out.view()
}
