#!/usr/bin/env zsh


typeset -A lang_books=(
  [yi]="Hebrew/Yehoyesh's Yiddish Tanakh Translation [yi].json"
  [he]="Hebrew/Tanach with Nikkud.json"
  [pl]="English/Bible in Polish, trans. Izaak Cylkow, 1841 - 1908 [pl].json"
   )

old_IFS=$IFS
IFS=$'\n'

for lang book in "${(@kv)lang_books}"; do

    for i in $(find Tanakh/*/*/"$book"); do

      new_file=$(echo "$i" | sed "s#Tanakh#Tanakh_he-pl#")
      dn=$(dirname "$new_file")
      dn=$(dirname "$dn")

      new_file="$dn"/$lang.json

      echo "b>> $book"
      echo "l>> $lang"
      echo "i>> $i"
      echo "dn>> $dn"
      echo "nf>> $new_file"

      echo ""

      if ! [[ -d "dn" ]]; then
        mkdir -p $dn
      fi

      cp -r "$i" "$new_file"
    done
done

IFS=$old_IFS


