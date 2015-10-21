# go_enrichment
From DNA sequences to GO enrichment Fisher tests

## Overview
`go_enrichment` enrichment goes from transcripts in fasta sequences without annotation and a
list of significant transcripts and produces GO enrichment Fisher tests.

## Prerequisites
To make `go_enrichment` enrichment work, you will need to have the following installed on
your computer (see *Installation* section for more details about installing
these prerequisites):

- UNIX system (Linux or OSX)
- `wget`
- `gnu parallel`
- `blastplus` suite of blast tools
- `swissprot` and `nr` blast database
- GO database (`go-basic.obo`)
- `goatools`

## Installation
If you do not have administrator rights on the computer you will be using, you
may need to ask an administrator to install the following on the computer.

### Wget
Your UNIX system should already have wget installed. Test this by running:

```bash
wget
```

If you get a message saying there is a missing URL, wget is installed.
Otherwise, you probably have a computer with OSX. Google `install wget OSX` and
follow the installations instructions.

### Gnu Parallel
We will use `wget` to download gnu parallel:

```bash
wget http://ftp.gnu.org/gnu/parallel/parallel-latest.tar.bz2
tar xvfB parallel-latest.tar.bz2
cd parallel-*
./configure && make && sudo make install
```

### Blast tools
The blast executables (pre-compiled for different architectures) can be found
here: [ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/](ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/). Download the right ones for your computer, uncompress the archive
and copy all the files that are in the `bin` folder so that they are accessible
through the `$PATH` variable on your system.

For example, if you have administrator rights on the system, you could do:

```bash
sudo cp /path_to_blastplus/bin/* /usr/local/bin
```

Test the installation by launching blastn:

```bash
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

```bash
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
`goatools` is a python module which depends on a certain number of other python
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

### Step 2 - Extract analyzed genes

### Step 3 - Get annotation information from uniprot

### Step 4 - Format wanted GO information

### Step 5 - Run `goatools`

## Licence
<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img
    alt="Creative Commons Licence" style="border-width:0"
    src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br/><span
    xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/Text"
    property="dct:title" rel="dct:type">go_enrichment</span> by <a
    xmlns:cc="http://creativecommons.org/ns#"
    href="https://github.com/enormandeau/go_enrichment"
    property="cc:attributionName" rel="cc:attributionURL">Eric Normandeau</a> is
    licensed under a <br/><a rel="license"
    href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution
    4.0 International License
</a>.

