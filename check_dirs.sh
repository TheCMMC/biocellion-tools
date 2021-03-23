BIOCELLION_MODEL_PATH="/home/jaroknor/NLeSC/InSilicoMeat/Biocellion/Biocellion-3.1/biocellion-3.1/biocellion-user/ABM-only-microcarriers"

for ((Y=3;Y<=4;Y++));
do
    for ((X=17;X<=23;X++));
	do
		OUT_DIR="${BIOCELLION_MODEL_PATH}/output/output_parameter${X}_trial${Y}"
		LOG_FILE="${OUT_DIR}/output_parameter${X}_trial${Y}.txt"
		SIM_SET="parameter${X}_trial${Y}"
		if test -f $LOG_FILE 
		then
			if  grep -q "75000/75000" ${LOG_FILE}
			then
				echo -e "$SIM_SET ran to completion"
			else
				echo -e "$SIM_SET failed"
			fi
		elif test -f "${OUT_DIR}/output.log"
		then
			echo -e "$SIM_SET is currently running"
		else
			echo -e "$SIM_SET has not been started"
		fi
		# echo -e "\n"
    done
done
