# MetaPhlAn3 Pipeline in Nextflow

### Dependencies:
1. [Nextflow](https://www.nextflow.io/)
2. [Docker](https://www.docker.com/) - if you select to use the -profile docker option. Otherwise, Metaphlan4 needs to be installed and available in the environment. 

### Input Parameters:
The params.json in the repo shows the parameters needed by the workflow.
1. Paired end Fastq files containing metagenomic sequences you want to analyze (input_fastqs). You can find some sample files [here](https://singular-public-repo.s3.us-west-1.amazonaws.com/microbiome/RM8376_2Million.tar). This file need to untar-ed before use.
2. Output location (out) where you want the output files to be sent to.
3. The Metaphlan4 database (the database(s) folder is defined by the mpa_db parameter and the specific index is defined by the index_db parameter). Unfortunately, Metaphlan4 does not provide precompiled, ready to use libraries. You can install a Metaphlan4 library by running "metaphlan --install" once you have Metaphlan4 installed [instructions](https://github.com/biobakery/MetaPhlAn/wiki/MetaPhlAn-4), and use that library for the workflow. This process can take several hours to download and install. You can access the precompiled database (mpa_vJan21_CHOCOPhlAnSGB_202103) we used [here](). You will need to untar the file. The included params.json gives the template for how to use that index/database.
4. Whether to turn on unclassified estimation (unclassified_estimation). A new, experimental feature in Metaphlan4 is trying to estimate the portion of reads coming from unclassified organism. This is set to "false" by default.

### Usage:
You can run the workflow using the following command with your valid parameter (files).
```
nextflow run metaphlan4_nf2/main.nf -params-file metaphlan4_nf2/params.json [-profile docker]
```

### What the workflow is doing:
There are 2 processes to the workflow. The first step runs Metaphlan4 on your input paired end Fastq files. The second step aggregates the outputs for each file into a single table for downstream analysis.
