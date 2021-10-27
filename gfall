#!/usr/bin/env bash
#
# Requirements
# - Golang (for complete bug bounty tools, clone this https://github.com/x1mdev/ReconPi)
# - gau (go get -u github.com/lc/gau)
# - gf (go get -u github.com/tomnomnom/gf)
# - Gf-Patterns (https://github.com/1ndianl33t/Gf-Patterns) - Read the README.md for how to copy json file to ~/.gf/

[ ! -f ~/gfpatterns ] && mkdir ~/gfpatterns  2&>1
[ ! -f ~/gfpatterns/temp ] && mkdir ~/gfpatterns/temp/  2&>1


cd ~/.gf
ls *.json > ~/gfpatterns/temp/patterns
cat ~/gfpatterns/temp/patterns | cut -d "." -f 1 > ~/gfpatterns/temp/gf-patterns

cd ~/gfpatterns/temp/
echo $1 | gau | sort -u >> $1-waybackdata.txt     # if you have subdomains list, can use "cat subdomains.txt | gau | sort -u >> waybackdata"
for patterns in $(cat ~/gfpatterns/temp/gf-patterns);
do
  cat $1-waybackdata.txt | gf $patterns | tee -a ~/gfpatterns/$1-$patterns.txt;
done
cd ~/gfpatterns
find . -iname "*.txt" -size 0 -delete
rm ~/gfpatterns/temp/patterns | rm  ~/gfpatterns/temp/gf-patterns
