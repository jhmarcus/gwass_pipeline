import argparse
import sys
sys.path.append('../gwass/')
import gwass

parser = argparse.ArgumentParser()
parser.add_argument('--summary_statistics', default=None, type=str, help='', required=True)
parser.add_argument('--snps', default=None, type=str, help='', required=True)
parser.add_argument('--out', default=None, type=str, help='', required=True)
args = parser.parse_args()

s = gwass.SummaryStatistics(summary_statistics_path=args.summary_statistics, snps_path=args.snps)
s.clean_summary_statistics()
s.summary_statistics.to_csv('{}.tsv.gz'.format(args.out), sep='\t', compression='gzip', index=False)
