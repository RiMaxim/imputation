#For validation
#$1 is name of chomosome

GLIMPSE2_chunk --input ./shapeit5/$1.phased5.del_387_388.bcf --region $1 --output ./glimpse2/chunks/chunks.$1.txt --recursive

cat ./glimpse2/chunks/chunks.$1.txt |awk -F'\t' '{print "GLIMPSE2_split_reference --reference ./shapeit5/'$1'.phased5.del_387_388.bcf --input-region "$3" --output-region "$3" --output ./glimpse2/chunks/ --threads 40"}' >./glimpse2/run1.sh

chmod +x /mnt/PROJECTS1/RI_MAXIM/8_glimpse2/run1.sh

./run1.sh

























 1Help              2Save              3Mark              4Replac            5Copy              6Move              7Search            8Delete            9PullDn           10Quit
