#! /bin/bash

# This script is meant to test the output of the biocellion simulation automation script poc_abm_only.sh 
# see http://github.com/thecmmc/biocellion-tools for more information

# Below, specify the model directory set NSTEPS to the number of steps your simulation should be running, 
# also set the values for Y (trial) and Z (parameter ID) in the for loops to specify the range of outputs to test
BIOCELLION_MODEL_PATH="/home/jaroknor/NLeSC/InSilicoMeat/Biocellion/Biocellion-3.1/biocellion-3.1/biocellion-user/ABM-only-microcarriers"
NSTEPS=75000 

echo -e "Testing whether the summary output files exist in the proper directory and include step number ${NSTEPS}. Please check your run_model.xml file if this is the amount of steps you are running the simulation. \n"
for ((Y=3;Y<=4;Y++));
do
    for ((Z=17;Z<=29;Z++));
	do
		OUT_DIR="${BIOCELLION_MODEL_PATH}/output/output_parameter${Z}_trial${Y}"
		LOG_FILE="${OUT_DIR}/output_parameter${Z}_trial${Y}.txt"
		SIM_SET="parameter${Z}_trial${Y}"
		
		if test -f $LOG_FILE 
		then
			if  grep -q "${NSTEPS}/${NSTEPS}" ${LOG_FILE}
			then
			# in this case the output file is available and has the output from the step number NSTEPS
			# this implies that the simulation ran successfully until the end. 
				echo -e "$SIM_SET ran to completion"
			else
			# in this case the output file is available but doesn't countain the specified "NSTEPS" step, 
			# implying that the simulation has stopped early
				echo -e "$SIM_SET failed"
			fi
		elif test -f "${OUT_DIR}/output.log"
		then
		# in this case the summary output file has been created, but not yet moved to the proper location and filename, 
		# which is an indication (not an assertion) that the simulation is still running
			echo -e "$SIM_SET is currently running"
		else
		# in this case the summary output file has not been created
			echo -e "$SIM_SET has not been started"
		fi
    done
done
