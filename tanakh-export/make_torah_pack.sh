#!/bin/bash

# Torah
PART=Torah
BOOK_LIST=(1_Bereshit 2_Shemot 3_Vayikra 4_Bemidbar 5_Devarim)

FORMAT=epub

declare -A LANGUAGES
LANGUAGES=(["cs"]="Kralicka" ["pl"]="Cylkow" ["yi"]="Yehoyesh" ["it"]="Luzzato" ["lad"]="Boyadjian" ["de"]="Bernfeld" ["he"]="Only Hebrew")

if ! [ -d "./exports/$PART" ]; then
	mkdir "./exports/$PART"
fi


TO_TAR=""
for LANG in "${!LANGUAGES[@]}"; do
	for BOOK in "${BOOK_LIST[@]}"; do
		LABEL=${LANGUAGES["$LANG"]}
		DIR_NAME="$PART/"$LABEL
		if ! [ -d "./exports/$DIR_NAME" ]; then
			mkdir "./exports/$DIR_NAME/"
		fi
		if [ "$LANG" = "he" ]; then
			bash ./run $FORMAT "./source_texts/$PART/$BOOK" he
			cp "./exports/docs/$BOOK/${BOOK}_he.$FORMAT" "./exports/$DIR_NAME/$BOOK.$FORMAT"
		else
			bash ./run $FORMAT "./source_texts/$PART/$BOOK" he $LANG
			cp "./exports/docs/$BOOK/${BOOK}_he-$LANG.$FORMAT" "./exports/$DIR_NAME/$BOOK.$FORMAT"
		fi
		TO_TAR+="${LABEL}/* "
	done
done

TIME=$(date +%Y-%b-%d)
cd "./exports/$PART"

ARCHFILE="$PART"__"${TIME,,}".zip
zip "$ARCHFILE" $TO_TAR
mv "./$ARCHFILE" "../$ARCHFILE"
cd ../..
