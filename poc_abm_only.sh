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
    do
        INDEX=$(expr $Z - 1)
        SIM_SET="parameter${IDS[$INDEX]}_trial${Y}"
        OUT_DIR="${BIOCELLION_MODEL_PATH}/output/output_${SIM_SET}"
        LOG_DIR="${BIOCELLION_MODEL_PATH}/output/"

        MODEL_DEFINE="${BIOCELLION_MODEL_PATH}/model_define.h" 
        RUN_MODEL="${BIOCELLION_MODEL_PATH}/run_model.xml"

        mkdir -p $OUT_DIR
        if [ "$(ls -A $OUT_DIR)" ] && $(grep -q "75000/75000" "${OUT_DIR}/output_${SIM_SET}.txt")
        then
            echo -e "$SIM_SET ran to completion \n"

        else
            make clean
            echo "Prepare simulations for id = ${IDS[$INDEX]}, trial = $Y"
            echo "with parameters: hill = ${HILL[$INDEX]}, treshold = ${TRESH[$INDEX]}, mech_treshold = ${MECHTRESHD[$INDEX]}, time_to_death = ${TDEATH[$INDEX]}"

            # prepare biocellion files with new parameters
            sed -i "s/const REAL STRESS_HILL_EXPONENT = .\+/const REAL STRESS_HILL_EXPONENT = ${HILL[$INDEX]} ;/g" ${MODEL_DEFINE}
            sed -i "s/const REAL STRESS_TRESHOLD = .\+/const REAL STRESS_TRESHOLD = ${TRESH[$INDEX]} ;/g" ${MODEL_DEFINE}
            sed -i "s/const REAL MECH_STRESS_TRESHOLD_DEATH = .\+/const REAL MECH_STRESS_TRESHOLD_DEATH = ${MECHTRESHD[$INDEX]} ;/g" ${MODEL_DEFINE}
            sed -i "s/const REAL TIME_TO_DEATH = .\+/const REAL TIME_TO_DEATH = ${TDEATH[$INDEX]} * DOUBLING_TIME ;/g" ${MODEL_DEFINE}
            sed -i "s@<output path=.\+@<output path=\"${OUT_DIR}\" particle=\"pvtp\" grid=\"vthb\" start_x=\"0\" start_y=\"0\" start_z=\"0\" size_x=\"4\" size_y=\"4\" size_z=\"4\"/>@g" ${RUN_MODEL}
            sed -i "s@<stdout path=.\+@<stdout path=\"${OUT_DIR}\" verbosity=\"3\" time_stamp=\"yes\"/>@g" ${RUN_MODEL}
            
            # build the biocellion model
            # make -s

            echo "Begin simulation for $OUT_DIR"
            # biocellion run_model.xml
            echo -e "\n End simulation for $OUT_DIR"

            #rename the summary file to the proper filename
            mv "${OUT_DIR}/output.log" "${OUT_DIR}/output_${SIM_SET}.txt"
        fi
    done
done