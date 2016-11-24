# run the pipeline !!!
snakemake --snakefile Snakefile \
          --cluster-config cluster.json \
          -c "sbatch -t {cluster.time} --mem {cluster.mem} -o {cluster.out} -e {cluster.err}" \
          -j 10 \
          -p \
	  $*
