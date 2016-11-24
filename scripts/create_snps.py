import argparse
import sys
sys.path.append('../gwass/')
import gwass

parser = argparse.ArgumentParser()
parser.add_argument('--sites', default=None, type=str, help='', required=True)
parser.add_argument('--ref', default=None, type=str, help='', required=True)
args = parser.parse_args()

s = gwass.Snps(sites_vcf_path=args.sites, ref_genome_path=args.ref)
s.write_snps()
