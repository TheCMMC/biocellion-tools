
# This script automates biocellion simulations for the ABM-only-microcarriers simulations (http://github.com/thecmmc/ABM-only-microcarriers)
# see http://github.com/thecmmc/biocellion-tools for more information

# Below, specify the model directory and the parameter file that specifies the parameters that need to be changed, 
# also set the values for Y (trial) and Z (parameter ID) in the for loops to specify the range of simulations to run
BIOCELLION_MODEL_PATH="/home/jaroknor/NLeSC/InSilicoMeat/Biocellion/Biocellion-3.1/biocellion-3.1/biocellion-user/ABM-microcarriers"
PARAMETER_FILE="${BIOCELLION_MODEL_PATH}/Parameters-ABM-CFD.csv"

# extract the parameters from the spreadsheet (skips the first 4 header lines)
SKIP=4
IDS=( $(tail -n +$SKIP ${PARAMETER_FILE} | cut -d ',' -f1) )
TRESH=( $(tail -n +$SKIP ${PARAMETER_FILE} | cut -d ',' -f2) )
MECHTRESHD=( $(tail -n +$SKIP ${PARAMETER_FILE} | cut -d ',' -f3) )
RPM=( $(tail -n +$SKIP ${PARAMETER_FILE} | cut -d ',' -f4) )

# check whether arrays have been extracted properly, run this piece first before you execute the rest of the script
echo "array of ParamIDs  : ${IDS[@]}"
echo "array of HILL_EXP   : ${HILL[@]}"
echo "array of TRESHOLD : ${TRESH[@]}"
echo "array of MECH_TRESHOLD : ${MECHTRESHD[@]}"
echo "array of TIME_DEATH : ${TDEATH[@]}"

LOG_DIR="${BIOCELLION_MODEL_PATH}/output/"
MODEL_DEFINE="${BIOCELLION_MODEL_PATH}/model_define.h" 
RUN_MODEL="${BIOCELLION_MODEL_PATH}/run_model.xml"

# Set the values for Y (trial) and Z (parameter ID) in the for loops to specify the range of simulations to run
for ((Y=4;Y<=6;Y++));
do
    for ((Z=5;Z<=18;Z++));
    do
        # list indexing starts at 0, while parameter IDs start at 1, set simulation specific paths and create output directory
        INDEX=$(expr $Z - 1)
        SIM_SET="parameter${IDS[$INDEX]}_trial${Y}"
        OUT_DIR="${BIOCELLION_MODEL_PATH}/output/output_${SIM_SET}"
        mkdir -p $OUT_DIR

        # test whether the output is already completed. Failed runs will be run again. 
        if [ "$(ls -A $OUT_DIR)" ] && $(grep -q "75000/75000" "${OUT_DIR}/output_${SIM_SET}.txt")
        then
            echo -e "$SIM_SET ran to completion \n"

        else
            # cd $BIOCELLION_MODEL_PATH
            # make clean
            echo "Prepare simulations for id = ${IDS[$INDEX]}, trial = $Y"
            echo "with parameters: hill = ${HILL[$INDEX]}, treshold = ${TRESH[$INDEX]}, mech_treshold = ${MECHTRESHD[$INDEX]}, time_to_death = ${TDEATH[$INDEX]}"

            # prepare biocellion files with new parameters
            sed -i "s/const REAL STRESS_TRESHOLD = .\+/const REAL STRESS_TRESHOLD = ${TRESH[$INDEX]} ;/g" ${MODEL_DEFINE}
            sed -i "s/const REAL MECH_STRESS_TRESHOLD_DEATH = .\+/const REAL MECH_STRESS_TRESHOLD_DEATH = ${MECHTRESHD[$INDEX]} ;/g" ${MODEL_DEFINE}
            sed -i "s/  cfd_setup((char*)\"Velocity_.\+/  cfd_setup((char*)\"Velocity_${RPM[$INDEX]}rpm.txt\") ;/g" ${MODEL_DEFINE}
            sed -i "s@<output path=.\+@<output path=\"${OUT_DIR}\" particle=\"pvtp\" grid=\"vthb\" start_x=\"0\" start_y=\"0\" start_z=\"0\" size_x=\"4\" size_y=\"4\" size_z=\"4\"/>@g" ${RUN_MODEL}
            sed -i "s@<stdout path=.\+@<stdout path=\"${OUT_DIR}\" verbosity=\"3\" time_stamp=\"yes\"/>@g" ${RUN_MODEL}
            
            # build the biocellion model
            # make -s 

            # run the simulation
            echo "Begin simulation for $OUT_DIR"
            # biocellion "${BIOCELLION_MODEL_PATH}/run_model.xml"
            echo -e "End simulation for $OUT_DIR \n"

            #rename the summary file to the proper filename and move back to the original directory
            mv "${OUT_DIR}/output.log" "${OUT_DIR}/output_${SIM_SET}.txt"
            cd -
        fi
    done
done