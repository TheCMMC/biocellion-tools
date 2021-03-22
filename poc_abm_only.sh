#! /bin/bash

BIOCELLION_MODEL_PATH="/home/jaroknor/NLeSC/InSilicoMeat/Biocellion/Biocellion-3.1/biocellion-3.1/biocellion-user/ABM-only-microcarriers"
PARAMETER_FILE="${BIOCELLION_MODEL_PATH}/Parameters-ABM-Only.csv"

#extract the parameters from the spreadsheet
SKIP=4
IDS=( $(tai
            # biocellion run_model.xml
            echo -e "\n End simulation for $OUT_DIR"

            #rename the summary file to the proper filename
            mv "${OUT_DIR}/output.log" "${OUT_DIR}/output_${SIM_SET}.txt"
        fi
    done
done