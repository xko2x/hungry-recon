#put all your domains in all.txt
for i in $(cat $1); do
        filename=$(echo $i)
        echo $i
done
