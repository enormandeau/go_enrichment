# go_enrichment

From DNA sequences to GO enrichment Fisher tests

## Overview

`go_enrichment` uses transcripts in fasta sequences without annotation and a
list of significant transcripts to produces GO enrichment Fisher tests. To do
so, the fasta sequences are blasted against the swissprot protein database and
the uniprot information is retreived from the uniprot website. Fisher tests are
done with `goatools`.

## TODO

Things left to implement:

- Create goatools bash script (see `runall.sh`)

```
find_enrichment.py --pval=0.05 --indent --fdr --obo 02_go_database/go-basic.obo significant_ids.txt all_ids.txt 06_fisher_tests/all_go_annotations.csv > 06_fisher_tests/go_enrichment.csv
```

- Filter script (python)
  - Keep only significant GOs between certain levels (eg: 1 to 3)
  - Add GO level (instead of ...)
  - Add GO categories (compatment, function, process)
  - Add definition of GO (from go-basic.obo)
  - Add gene IDs in that GO
  - Create file with GOs (col 1) and gene names (col 2)

- Generate output to use with [g:Profiler](http://biit.cs.ut.ee/gprofiler)
  - In the `05_annotations` folder
  - From all .info files
  - Get "GN   Name:cyp1a1; (...)"
  - Keep only first occurence of GN per file
  - Write them all to files
  - Second script to generate the significant genes for gprofiler

## Prerequisites

To make `go_enrichment` enrichment work, you will need to have the following
dependencies installed on your computer (see *Installation* section for more
details about installing these prerequisites):

- UNIX system (Linux or MAC OSX)
- `wget`
- `gnu parallel`
- `blastplus` the NCBI suite of blast tools
- `swissprot` and `nr` blast databases
- GO database (`go-basic.obo`)
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

# Downloading the database
wget http://purl.obolibrary.org/obo/go/go-basic.obo

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

Run:

```
./01_scripts/01_blast_against_swissprot.sh
```

### Step 2 - Get annotation information from uniprot

Run:

```
./01_scripts/02_get_uniprot_info.sh
```

### Step 3 - Extract analyzed genes

Generate two text files containing (one per line):
- The names of **all** the analyzed genes
- The names of the **significant** genes

### Step 4 - Run `goatools`

Run:

```
./01_scripts/03_goatools.sh
```

## Licence

`go_enrichment` is licensed under the GPL3 license. See the LICENCE file for
more details.


