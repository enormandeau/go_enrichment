#!/usr/bin/env python
"""Filter and enrich the results of goatools

Usage:
    python ./01_scripts/04_filter_goatools.py input_enrichment go_database output_enrichment
"""

# TODO
# - Use argparse to add options (fdr, min and max level...)
# - Filter based on namespace

# Modules
import argparse
import sys

# Classes
class Go_term(object):
    def __init__(self):
        self.id = ""
        self.name = ""
        self.namespace = ""
        self.definition = ""

    def __repr__(self):
        return "\t".join([self.id, self.name, self.namespace, self.definition])

class Go_result(object):
    def __init__(self, line):
        self.id = line[0].replace(".", "")
        self.level = line[0].count(".")
        self.enrichment = line[1]
        self.namespace = ""
        self.name = line[2]
        self.definition = ""
        self.ratio_in_study = line[3]
        self.ratio_in_pop = line[4]
        self.p_uncorrected = line[5]
        self.p_bonferroni = line[6]
        self.p_holm = line[7]
        self.p_sidakp_fdr = line[8]

    def __repr__(self):
        return "\t".join([self.id, str(self.level), self.enrichment,
            self.namespace, self.name, self.definition, self.ratio_in_study, self.ratio_in_pop,
            self.p_uncorrected, self.p_bonferroni, self.p_holm, self.p_sidakp_fdr])

# Functions
def read_go_db(go_database):
    go_db = dict()
    with open(go_database) as gofile:
        line = gofile.next()

        # Get pass the header
        while not line.startswith("[Term]"):
            line = gofile.next()

        # Extract db info
        line = gofile.next()
        while not line.startswith("[Typedef]"):

            if line.startswith("id:"):
                term = Go_term()
                term.id = line.strip().replace("id: ", "")
                line = gofile.next()
                continue

            if line.startswith("name:"):
                term.name = line.strip().replace("name: ", "")
                line = gofile.next()
                continue

            if line.startswith("namespace:"):
                term.namespace = line.strip().replace("namespace: ", "")
                line = gofile.next()
                continue

            if line.startswith("def:"):
                term.definition = line.strip().replace("def: ", "").replace('"', '')
                go_db[term.id] = term
                line = gofile.next()
                continue

            try:
                line = gofile.next()
            except:
                break

        return go_db

def parse_enrichment_file(input_enrichment, output_enrichment, go_db):
    infile = open(input_enrichment)
    outfile = open(output_enrichment, "w")
    num_go_treated = 0
    num_go_kept = 0

    for line in infile:
        if line.startswith("#"):
            #outfile.write(line)
            pass

        elif line.startswith("id"):
            outfile.write("id\tlevel\tenrichment\tnamespace\tname\tdefinition\tratio_in_study\tratio_in_pop\tp_uncorrected\tp_bonferroni\tp_holm\tp_sidakp_fdr\n")

        else:
            keep_go = True
            num_go_treated += 1
            info = Go_result(line.strip().split("\t"))
            term = go_db[info.id]
            info.namespace = term.namespace
            info.definition = term.definition
            fdr = float(info.p_sidakp_fdr)

            # Filter based on FDR
            #if fdr > 0.05:
            #    keep_go = False

            # Filter based on GO level
            #if not 1 <= info.level <= 3:
            #    keep_go = False

            if keep_go:
                num_go_kept += 1
                outfile.write(str(info) + "\n")

    print "  Kept {}/{} GO terms".format(num_go_kept, num_go_treated)
    infile.close()
    outfile.close

# Parsing user input
try:
    input_enrichment = sys.argv[1]
    go_database = sys.argv[2]
    output_enrichment = sys.argv[3]
except:
    print __doc__
    sys.exit(1)

# Store go database
print "Extracting data from the GO database..."
go_db = read_go_db(go_database)
print "  The GO database contains {} elements".format(len(go_db))

# Parse and improving enrichment file
print "Parsing and improving enrichment file..."
parse_enrichment_file(input_enrichment, output_enrichment, go_db)
