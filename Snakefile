#!python

__author__ = "Joseph Marcus"

import sys
import os
import numpy as np
import pandas as pd
sys.path.append('../gwass')
import gwass

configfile: 'config.yaml'
#summary_statistics_df = pd.read_table('meta/gwass.tsv', index_col=False, keep_default_na=False)
summary_statistics_df = pd.read_table('meta/gwas_ss.csv', index_col=False, keep_default_na=False, sep=",")

snps = '/project/mstephens/data/external_public_supp/gwas_summary_statistics/snps/1kg_phase3_snps.tsv.gz' 
summary_statistics = [] 
for i, row in summary_statistics_df.iterrows():
    summary_statistics.append('/project/mstephens/data/external_public_supp/gwas_summary_statistics/summary_statistics/{}_{}_summary_statistics.tsv.gz'.format(row['consortium'], row['trait']))

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
        snp = lambda wildcards: summary_statistics_df[(summary_statistics_df['consortium'] == wildcards.consortium) & (summary_statistics_df['trait'] == wildcards.trait)]['snp'].tolist()[0],
        a1 = lambda wildcards: summary_statistics_df[(summary_statistics_df['consortium'] == wildcards.consortium) & (summary_statistics_df['trait'] == wildcards.trait)]['a1'].tolist()[0],
        a2 = lambda wildcards: summary_statistics_df[(summary_statistics_df['consortium'] == wildcards.consortium) & (summary_statistics_df['trait'] == wildcards.trait)]['a2'].tolist()[0],
        beta_hat = lambda wildcards: summary_statistics_df[(summary_statistics_df['consortium'] == wildcards.consortium) & (summary_statistics_df['trait'] == wildcards.trait)]['beta_hat'].tolist()[0],
        se = lambda wildcards: summary_statistics_df[(summary_statistics_df['consortium'] == wildcards.consortium) & (summary_statistics_df['trait'] == wildcards.trait)]['se'].tolist()[0],
        p_value = lambda wildcards: summary_statistics_df[(summary_statistics_df['consortium'] == wildcards.consortium) & (summary_statistics_df['trait'] == wildcards.trait)]['p_value'].tolist()[0],
        sample_size = lambda wildcards: summary_statistics_df[(summary_statistics_df['consortium'] == wildcards.consortium) & (summary_statistics_df['trait'] == wildcards.trait)]['sample_size'].tolist()[0],
        regression_type = lambda wildcards: summary_statistics_df[(summary_statistics_df['consortium'] == wildcards.consortium) & (summary_statistics_df['trait'] == wildcards.trait)]['regression_type'].tolist()[0],
        output = '/project/mstephens/data/external_public_supp/gwas_summary_statistics/summary_statistics/{consortium}_{trait}_summary_statistics'
    output: '/project/mstephens/data/external_public_supp/gwas_summary_statistics/summary_statistics/{consortium}_{trait}_summary_statistics.tsv.gz'
    run:
        shell(('clean-summary-statistics --summary_statistics {input.summary_statistics} --snps {input.snps} ' +
               '--snp_col {params.snp} --a1_col {params.a1} --a2_col {params.a2} --beta_hat_col {params.beta_hat} ' +
               '--se_col {params.se} --p_value_col {params.p_value} --sample_size_col {params.sample_size} ' +
               '--regression_type_col {params.regression_type} --out {params.output}'
               )) 
