#!/usr/bin/env bash
for i in json_sources/*/*; do
  case $1 in

    "--he+pl")
        if [[ -f "$i/pl.json" ]]; then
        export OUTPUT_DIR="./output/he-pl"
        bash ./run.sh "$i" he pl
        fi
    ;;

    "--he+yi")
        if [[ -f "$i/yi.json" ]]; then
        export OUTPUT_DIR="./output/he-yi"
        bash ./run.sh "$i" he yi
        fi
    ;;

    "--he+yi+pl")
        if [[ -f "$i/pl.json" ]] && [[ -f "$i/yi.json" ]] ; then
        export OUTPUT_DIR="./output/he-yi-pl"
        bash ./run.sh "$i" he yi pl
        fi
    ;;

      "--only-he")
        if [[ -f "$i/he.json" ]]; then
        export OUTPUT_DIR="./output/he"
        bash ./run.sh "$i" he
        fi
    ;;

      "--only-yi")
        if [[ -f "$i/he.json" ]] && [[ -f "$i/yi.json" ]] ; then
        export OUTPUT_DIR="./output/yi"
        bash ./run.sh "$i" yi
        fi
      ;;

      "--only-pl")
        if [[ -f "$i/pl.json" ]]; then
        export OUTPUT_DIR="./output/pl"
        bash ./run.sh "$i" pl
        fi
    ;;

  esac
done