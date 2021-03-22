#! /bin/bash

BIOCELLION_MODEL_PATH="/home/jaroknor/NLeSC/InSilicoMeat/Biocellion/Biocellion-3.1/biocellion-3.1/biocellion-user/ABM-only-microcarriers"
PARAMETER_FILE="${BIOCELLION_MODEL_PATH}/Parameters-ABM-Only.csv"

#extract the parameters from the spreadsheet
SKIP=4
IDS=( $(tail -n +$SKIP ${PARAMETER_FILE} | cut -d ',' -f1) )
HILL=( $(tail -n +$SKIP ${PARAMETER_FILE} | cut -d ',' -f2) )
TRESH=( $(tail -n +$SKIP ${PARAMETER_FILE} | cut -d ',' -f3) )
MECHTRESHD=( $(tail -n +$SKIP ${PARAMETER_FILE} | cut -d ',' -f4) )
TDEATH=( $(tail -n +$SKIP ${PARAMETER_FILE} | cut -d ',' -f5) )

# # check whether arrays have been substracted properly, run this piece first before you execute the script
echo "array of ParamIDs  : ${IDS[@]}"
echo "array of HILL_EXP   : ${HILL[@]}"
echo "array of TRESHOLD : ${TRESH[@]}"
echo "array of MECH_TRESHOLD : ${MECHTRESHD[@]}"
echo "array of TIME_DEATH : ${TDEATH[@]}"

for ((Y=4;Y<=6;Y++));
do
    for ((Z=1;Z<=16;Z++));
    
            # biocellion run_model.xml
            echo -e "\n End simulation for $OUT_DIR"

            #rename the summary file to the proper filename
            mv "${OUT_DIR}/output.log" "${OUT_DIR}/output_${SIM_SET}.txt"
        fi
    done
done