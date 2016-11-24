#!python

__author__ = "Joseph Marcus"

import sys
import os
import numpy as np
import pandas as pd

configfile: 'config.yaml'
summary_statistics_df = pd.read_table('meta/gwass.tsv', index_col=False)

snps = 'data/snps/1kg_phase3_snps.tsv.gz' 

rule all:
    input:
        snps

rule create_snps:
    ''' '''
    input:
        sites_vcf = config['data']['sites_vcf'],
        ref_genome = config['data']['ref_genome']
    output:
        snps
    run:
        shell('python scripts/create_snps.py --sites {input.sites_vcf} --ref {input.ref_genome} | gzip -c > {output}')

