# go_enrichment

From DNA sequences to annotation and GO enrichment Fisher test results

## Overview

`go_enrichment` annotates transcript sequences and performs GO enrichment
Fisher tests. The transcript sequences are blasted against the swissprot
protein database and the uniprot information corresponding to the hit is
retrieved from the uniprot website. Fisher tests are performed with the
`goatools` Python module.

## Prerequisites

To use `go_enrichment`, you will need a UNIX system (Linux or Mac OSX) and the
following dependencies installed on your computer (see *Installation* section
for more details about installing these prerequisites):

- `wget`
- `gnu parallel`
- `blastplus` the NCBI suite of blast tools
- `swissprot` and `nr` blast databases
- GO database
- `goatools`

## Installation

If you do not have administrator rights on the computer you will be using or
have little experience compiling, installing and adding programs to your PATH
environment variable, you will potentially need to ask an administrator to
install the following programs and databases.

### Wget

Your UNIX system should already have wget installed. Test this by running:

```
wget
```

If you get a message saying there is a missing URL, wget is installed.
Otherwise, if you are using a computer with OSX. Google `install wget OSX` and
follow the installations instructions. For `Debian` or `Ubuntu` derived Linux
distributions, install `wget` with:

```
sudo apt-get install wget
```

### Gnu Parallel

We will use `wget` to download gnu parallel:

```
wget http://ftp.gnu.org/gnu/parallel/parallel-latest.tar.bz2
tar xvfB parallel-latest.tar.bz2
cd parallel-*
./configure && make && sudo make install
```

### Blast tools

The blast executables (pre-compiled for different architectures) can be found
here:
[ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/](ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/).
Download the right ones for your computer, uncompress the archive and copy all
the files that are in the `bin` folder so that they are accessible through the
`$PATH` variable on your system.

For example, if you have administrator rights on the system, you could do:

```
sudo cp /path_to_blastplus/bin/\* /usr/local/bin
```

Test the installation by launching blastn's help:

```
blastn -h
```

### Swissprot database

We will use wget to download the `nr` and `swissprot` databases. Since
`swissprot` is effectively only a subset of `nr`, we need to download both in
order to use it.

**WARNING!** The `nr` database is rather big. You will be downloading
approximately 20Go of data and then decompressing it, which will use even more
space on your computer. Depending on your connection speed, this process could
take a long time.

```
# Create a temporary bash session
bash

# Create folder to contain the databases
mkdir ~/blastplus_databases
cd ~/blastplus_databases

# Downloading the databases
wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/nr.*
wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/swissprot.*

# Confirming the integrity of the downloaded files
cat *.md5 | md5sum -c

# Decompressing
gunzip nr.*.gz
gunzip swissprot.*.gz

# Exit temporary bash session
exit
```

### GO database

Installing the GO database will be faster:

```
# Create a temporary bash session
bash

# Moving to the GO database folder
cd 02_go_database

# Downloading the databases
wget http://geneontology.org/ontology/go-basic.obo

# Exit temporary bash session
exit
```

### goatools

`goatools` is a python module. It depends on a certain number of other python
modules. In order to make the installation easier, we will be using the
`anaconda` python data analysis platform. `anaconda` will make it easy to
install most of the module dependencies and does not require administrator
rights.  To get the `anaconda` install file, go to
[https://www.continuum.io/downloads](https://www.continuum.io/downloads) and
choose the appropriate platform and python 2.7, then launch the installation
and follow the instructions. When asked if you want `anaconda` to add itself to
your `$PATH` variable, say yes. You can then update with:

```
conda update conda
```

Then go to the `goatools` `GitHub` page
[https://github.com/tanghaibao/goatools](https://github.com/tanghaibao/goatools)
and follow the installation instructions.

## Workflow

This is a brief description of the steps as well as the input and output
formats expected by `go_enrichment`.

### Step 1 - Blast against swissprot

Put your sequences of interest in the `03_sequences` folder in a file named
`analysed_genes.fasta`. If you use another name, you will need to modify the
`SEQUENCE_FILE` variable in the script.

You need the script to point to the locally installed blastplus database by
modifying the `SWISSPROT_DB` variable.

Then run:

```
./01_scripts/01_blast_against_swissprot.sh
```

### Step 2 - Get annotation information from uniprot

This step will use the blast results to download the information of the genes
to which the transcript sequences correspond.

Run:

```
./01_scripts/02_get_uniprot_info.sh
```

### Step 3 - Annotate the transcripts

Use this step to create a .csv file containing the transcript names as well as
some annotation information (Name, Accession, Fullname, Altnames, GO).

Run:

```
./01_scripts/03_annotate_genes.py 03_sequences/analyzed_genes.fasta 05_annotations/ sequence_annotation.csv
```

### Step 4 - Extract analyzed genes

Before we can perform the Fisher tests, we need to generate two text files containing (one per line):
- The names of **all** the analyzed transcripts
- The names of the **significant** transcripts

### Step 5 - Run `goatools`

This script will launch `goatools` and perform the Fisher tests.

```
./01_scripts/04_goatools.sh
```

### Step 6 - Filter `goatools` results

We can now reformat the results of `goatools` to make them more useful.

```
./01_scripts/05_filter_goatools.py enrichment.csv 02_go_database/go-basic.obo filtered.csv
```

## Licence

`go_enrichment` is licensed under the GPL3 license. See the LICENCE file for
more details.


