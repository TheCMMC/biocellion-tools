HILL_LIST=(1.0 2.0 3.0 5.0)
TRESHOLD_LIST=(1.0 1e-6 1e-7 1e-8)
for ((Y=4;Y<=6;Y++));
do
    for ((X=1;X<=16;X++));
    do
        OUT_DIR="./output_parameter${X}_trial${Y}"
        LOG_DIR="./log_parameter${X}_trial${Y}"
        if [ "$(ls -A $OUT_DIR)" ]; 
        then
            echo "$OUT_DIR is already full"
        else
            make clean
            
            HILL_INDEX=$(((X-1) / 4))
            TRESHOLD_INDEX=$(((X-1) % 4))
            HILL=${HILL_LIST[HILL_INDEX]}
            TRESHOLD=${TRESHOLD_LIST[TRESHOLD_INDEX]}
            
            echo "Prepare simulations with id = ${X}, hill = ${HILL}, treshold = ${TRESHOLD}"
            sed -i "s/const REAL STRESS_HILL_EXPONENT = .\+/const REAL STRESS_HILL_EXPONENT = ${HILL} ;/g" ./model_define.h
            sed -i "s/const REAL STRESS_TRESHOLD = .\+/const REAL STRESS_TRESHOLD = ${TRESHOLD} ;/g" ./model_define.h
            sed -i "s@<output path=.\+@<output path=\"${OUT_DIR}\" particle=\"pvtp\" grid=\"vthb\" start_x=\"0\" start_y=\"0\" start_z=\"0\" size_x=\"4\" size_y=\"4\" size_z=\"4\"/>@g" ./run_model.xml
            sed -i "s@<stdout path=.\+@<stdout path=\"${LOG_DIR}\" verbosity=\"3\" time_stamp=\"yes\"/>@g" ./run_model.xml
            
            make -s

            echo "Begin simulation for $OUT_DIR"
            biocellion run_model.xml
            printf "\n"
        fi
    done
done