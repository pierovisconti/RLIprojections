#!/bin/bash

while IFS=, read i aooadj densadj
	do
	cp template_noemail_longpar.pbs ~/pbsdirmonte/pbs_scriptbase$i.pbs # copy template pbs file
	cd pbsdirmonte # navigate to dir where all pbs of the montecarlo runs are stored (1 for each species)
	echo "#PBS -o log.montecarlo$i" >> pbs_scriptbase$i.pbs # start appending text to the pbs that is specific to this run (species)
	echo "#PBS -e err.montecarlo$i" >> pbs_scriptbase$i.pbs
	echo "module load autoload R" >>pbs_scriptbase$i.pbs
	echo " " >> pbs_scriptbase$i.pbs
	echo "PBS_JOBID=ILCEMER$i" >> pbs_scriptbase$i.pbs
	echo "PBS_ENVIRONMENT=PBS_BATCH" >> pbs_scriptbase$i.pbs
	#echo "module load autoload R" >> pbs_scriptbase$i.pbs
	echo "R --vanilla --slave --args ITER=$i AOOADJ=$aooadj DENSADJ=$densadj < run.RL.montecarlo.R" >> pbs_scriptbase$i.pbs
	cat pbs_scriptbase$i.pbs |tr -d '\r' >pbs_scriptbase$i.2.pbs # ensure the end of file is linux compatible
	mv pbs_scriptbase$i.2.pbs pbs_scriptbase$i.pbs # replace original file
	qsub pbs_scriptbase$i.pbs #submit pbs file to cluster queue
	cd ..
done < ~/input/montecarlo_values2.csv




