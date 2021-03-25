#! /bin/bash
DATA_DIR="/home/jaroknor/NLeSC/InSilicoMeat/Biocellion/Biocellion-3.1/biocellion-3.1/biocellion-user/biocellion-data/PLOSone_ABM-only-microcarrier"
echo "Cleaning in $DATA_DIR"
for file in "$DATA_DIR/*"
do
    echo "Cleaning $file"
    sed -i '/this baseline time step took.\+/d' $file
    sed -i '/setup took.\+/d' $file
    sed -i '/computation took.\+/d' $file
    sed -i '/file & summary output and checkpoint took.\+/d' $file
    sed -i '/regridding took.\+/d' $file
done