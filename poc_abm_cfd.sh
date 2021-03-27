#! /bin/bash

BIOCELLION_MODEL_PATH="/home/boris/biocellion-3.1/biocellion-user/ABM-microcarriers"
PARAMETER_FILE="${BIOCELLION_MODEL_PATH}/Parameters-ABM-CFD.csv"

#extract the parameters from the spreadsheet
SKIP=8
IDS=( $(tail -n +$SKIP ${PARAMETER_FILE} | cut -d ',' -f1) )
MECHTRESHD=( $(tail -n +$SKIP ${PARAMETER_FILE} | cut -d ',' -f2) )
TRESH=( $(tail -n +$SKIP ${PARAMETER_FILE} | cut -d ',' -f3) )
RPM=( $(tail -n +$SKIP ${PARAMETER_FILE} | cut -d ',' -f4) )

# # check whether arrays have been substracted properly, run this piece first before you execute the script
echo "array of ParamIDs  : ${IDS[@]}"
echo "array of DEATH_TRESHOLD   : ${MECHTRESHD[@]}"
echo "array of STRESS_TRESHOLD : ${TRESH[@]}"
echo "array of RPM : ${RPM[@]}"

for ((Y=7;Y<=7;Y++));
do
    for ((Z=1;Z<=14;Z++));
    do
        INDEX=$(expr $Z - 1)
        SIM_SET="parameter${IDS[$INDEX]}_trial${Y}"
        echo $SIM_SET
        OUT_DIR="${BIOCELLION_MODEL_PATH}/output/"

        MODEL_DEFINE="${BIOCELLION_MODEL_PATH}/model_define.h" 

        #if [ "$(ls -A $OUT_DIR)" ] && $(grep -q "120000/120000" "${OUT_DIR}/output_${SIM_SET}.txt")
        #then
        #    echo -e "$SIM_SET ran to completion \n"

        #else
            cd $BIOCELLION_MODEL_PATH
            make clean
            echo "Prepare simulations for id = ${IDS[$INDEX]}, trial = $Y"
            echo "with parameters: death treshold = ${MECHTRESHD[$INDEX]}, stress_treshold = ${TRESH[$INDEX]}, rpm = ${RPM[$INDEX]}"

            # prepare biocellion files with new parameters
            sed -i "s/const REAL STRESS_TRESHOLD = .\+/const REAL STRESS_TRESHOLD = ${TRESH[$INDEX]} ;/g" ${MODEL_DEFINE}
            sed -i "s/const REAL MECH_STRESS_TRESHOLD_DEATH = .\+/const REAL MECH_STRESS_TRESHOLD_DEATH = ${MECHTRESHD[$INDEX]} ;/g" ${MODEL_DEFINE}
            cp "Velocity_${RPM[$INDEX]}rpm.txt" Velocity_cfd.txt 

            # build the biocellion model
            make -s 

            echo "Begin simulation for $OUT_DIR"
            /home/boris/biocellion-3.1/biocellion/framework/main/biocellion.DP.SPAGENT.OPT  "${BIOCELLION_MODEL_PATH}/run_model.xml" > "${OUT_DIR}/output_${SIM_SET}.txt"
            echo -e "End simulation for $OUT_DIR \n"

            cd -
        #fi
    done
done
