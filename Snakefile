#!python

__author__ = "Joseph Marcus"

import sys
import os
import numpy as np
import pandas as pd
sys.path.append('../gwass')
import gwass

configfile: 'config.yaml'
summary_statistics_df = pd.read_table('meta/gwass.tsv', index_col=False)

snps = 'data/snps/1kg_phase3_snps.tsv.gz' 
summary_statistics = [] 
for i, row in summary_statistics_df.iterrows():
    summary_statistics.append('data/summary_statistics/{}_{}_summary_statistics.tsv.gz'.format(row['consortium'], row['trait']))

rule all:
    input:
        snps,
        summary_statistics

rule create_snps:
    ''' '''
    input:
        sites_vcf = config['data']['sites_vcf'],
        ref_genome = config['data']['ref_genome']
    output:
        snps
    run:
        shell('create-snps --sites {input.sites_vcf} --ref {input.ref_genome} | gzip -c > {output}')

rule clean_summary_statistics:
    '''
    cleans up raw gwas summary statistics 
    '''
    input: 
        summary_statistics = lambda wildcards: summary_statistics_df[(summary_statistics_df['consortium'] == wildcards.consortium) & (summary_statistics_df['trait'] == wildcards.trait)]['summary_statistics_path'],
        snps = snps
    params:
        output = 'data/summary_statistics/{consortium}_{trait}_summary_statistics'
    output: 'data/summary_statistics/{consortium}_{trait}_summary_statistics.tsv.gz'
    run:
        shell('clean-summary-statistics --summary_statistics {input.summary_statistics} --snps {input.snps} --out {params.output}') 
