#!/usr/bin/env nextflow

nextflow.enable.dsl=2

fastq_files = Channel.fromFilePairs(params.input_fastqs, type: 'file')
mpa_db = file(params.mpa_db)
merge_script = file("$baseDir/merge_metaphlan_tables.py")

if(params.unclassified_estimation) {
    unclassified_estimation = "--unclassified_estimation"
}
else {
    unclassified_estimation = " "
}


workflow {
    mpa_fastq(fastq_files, mpa_db, params.index_db, unclassified_estimation)
    mpa_merge_results(merge_script, mpa_fastq.out.collect())
}


process mpa_fastq {

    //errorStrategy 'ignore'
    publishDir params.out, mode: 'copy', overwrite: true
    memory '30 GB'
    cpus 4
    input:
    tuple val(name), file(fastq) 
    file(mpa_db)
    val(index_db)
    val(unclassified_estimation)

    output:
    file("*.txt")

    """
    metaphlan ${fastq[0]},${fastq[1]} --input_type fastq -o ${name}.txt --bowtie2out ${name}.bowtie2.bz2 --index ${params.index_db} --bowtie2db ${mpa_db} --nproc 4 ${unclassified_estimation}
    """
}

process mpa_merge_results {

    //errorStrategy 'ignore'
    publishDir params.out, mode: 'copy', overwrite: true
    memory '2 GB'
    cpus 1
    input:
    file(merge_script)
    file(mpa_reports)

    output:
    file("combined_metaphlan_results.txt")

    """
    python3 ${merge_script} *.txt  > combined_metaphlan_results.txt
    """
}
