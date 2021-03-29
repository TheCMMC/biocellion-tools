#! /bin/bash

BIOCELLION_MODEL_PATH="/home/jaroknor/NLeSC/InSilicoMeat/Biocellion/Biocellion-3.1/biocellion-3.1/biocellion-user/ABM-only-microcarriers"
DATA_DIR="/home/jaroknor/NLeSC/InSilicoMeat/Biocellion/Biocellion-3.1/biocellion-3.1/biocellion-user/biocellion-data/PLOSone_ABM-only-microcarrier"

for ((Y=3;Y<=4;Y++));
do
    for ((Z=17;Z<=29;Z++));
    do
        SIM_SET="parameter${Z}_trial${Y}"
        OUT_DIR="${BIOCELLION_MODEL_PATH}/output/output_${SIM_SET}"

        cp "${OUT_DIR}/output_${SIM_SET}.txt" "${DATA_DIR}/output_${SIM_SET}.txt"
        # echo -e "${OUT_DIR}/output_${SIM_SET}.txt \n" "${DATA_DIR}/output_${SIM_SET}.txt \n"
    done
done
