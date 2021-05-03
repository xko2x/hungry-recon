#bash domains.txt
for i in $(cat $1); do
        filename=$(echo $i)
        bash ~/hungry-recon/sub2.sh $i
done
