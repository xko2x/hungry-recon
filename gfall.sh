#!/usr/bin/env bash
#
# Requirements
# - Golang (for complete bug bounty tools, clone this https://github.com/x1mdev/ReconPi)
# - gau (go get -u github.com/lc/gau)
# - gf (go get -u github.com/tomnomnom/gf)
# - Gf-Patterns (https://github.com/1ndianl33t/Gf-Patterns) - Read the README.md for how to copy json file to ~/.gf/

[ ! -f ~/gfpatterns ] && mkdir ~/gfpatterns  2&>1
[ ! -f ~/gfpatterns/$1 ] && mkdir ~/gfpatterns/$1  2&>1
[ ! -f ~/gfpatterns/$1/temp ] && mkdir ~/gfpatterns/$1/temp/  2&>1


cd ~/.gf
ls *.json > ~/gfpatterns/$1/temp/patterns
cat ~/gfpatterns/$1/temp/patterns | cut -d "." -f 1 > ~/gfpatterns/$1/temp/gf-patterns

cd ~/gfpatterns/$1/temp/
echo $1 | gau | sort -u >> $1-waybackdata.txt     # if you have subdomains list, can use "cat subdomains.txt | gau | sort -u >> waybackdata"
for patterns in $(cat ~/gfpatterns/$1/temp/gf-patterns);
do
  cat $1-waybackdata.txt | gf $patterns | tee -a ~/gfpatterns/$1/$1-$patterns.txt;
done
cd ~/gfpatterns/$1
find . -iname "*.txt" -size 0 -delete
rm ~/gfpatterns/$1/temp/patterns | rm  ~/gfpatterns/$1/temp/gf-patterns
