echo "[+] FINDOMAIN SCANNING [+]"
if [ ! -f $1-findomain.txt ] && [ ! -z $(which findomain) ]; then
	findomain -t $1 -q -u $1-findomain.txt
	echo "[+] Findomain Found $findomainscan subdomains"
else
	echo "[!] Skipping ..."
fi
sleep 5
echo "[+] SUBFINDER SCANNING AND MORE [+]"
if [ ! -f $1-subfinder.txt ] && [ ! -z $(which subfinder) ]; then
	subfinder -d $1 -nW  -rL ~/tools/wordlists/dns/resolvers.txt -o $1-subfinder.txt
	curl -s https://crt.sh/\?q\=\%.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | tee -a $1-certspotter.txt
	curl -s https://crt.sh/?Identity=%.$1 | grep ">*.$1" | sed 's/<[/]*[TB][DR]>/\n/g' | grep -vE "<|^[\*]*[\.]*$1" | sort -u | awk 'NF' | tee -a $1-certsh.txt
	echo "[+] Subfinder Found $subfinderscan subdomains"
else
	echo "[!] Skipping ..."
fi
sleep 5
echo "[+] ASSETFINDER SCANNING [+]"
if [ ! -f $1-assetfinder.txt ] && [ ! -z $(which assetfinder) ]; then
	assetfinder -subs-only $1 > $1-assetfinder.txt
	echo "[+] Assetfinder Found $assetfinderscan subdomains"
else
	echo "[!] Skipping ..."
fi
sleep 5

echo "[+] SCANNING SUBDOMAINS WITH OneForAll [+]"
if [ ! -f $1-oneforall.txt ] && [ -e ~/tools/OneForAll ]; then
	python3 ~/tools/OneForAll/oneforall.py --target $1 --brute True -fmt txt --path=./ run
	cat *.txt >> $1-oneforall.txt
	echo "[+] oneforall Found $oneforall subdomains"
else
	echo "[!] Skipping ..."
fi
sleep 5
cat  $1-oneforall.txt $1-findomain.txt $1-subfinder.txt $1-assetfinder.txt $1-certspotter.txt $1-certsh.txt > $1-final-uns.txt | sort -uf
cat $1-final-uns.txt | sort | uniq > $1-final.txt
httpx -l $1-final.txt  -silent -threads 9000 -timeout 30 >> $1-live.txt
#cat $1-final.txt | httprobe -c 100 >> $1-live.txt
rm $1-final-uns.txt $1-oneforall.txt $1-findomain.txt $1-subfinder.txt $1-assetfinder.txt $1-certspotter.txt $1-certsh.txt

PS3='all saved to alive.txt and final.txt do you want run dnsgen ? : '
options=("yes 1" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "yes 1")
            xargs -a $1-final.txt -I@ sh -c 'echo @' | dnsgen - | httpx -silent -threads 10000 | anew $1-live.txt
            echo "dnsgen done!"
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done