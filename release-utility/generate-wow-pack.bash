Usage() {
	cd out/
	bash ../release-utility/generate-wow-pack.bash
}

mkdir -p Morpheus/
cp -R ../build/pass1/UI-CN-Cond*.ttf Morpheus/

ver=$(cat ../package.json | grep version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')

regionalVariant=(CN TW)
declare -A regionalVariantName
regionalVariantName=([CN]=CN [TW]=TW)

chatFontWidth=(Compact Condensed)
declare -A chatFontWidthName
chatFontWidthName=([Normal]=100 [Compact]=95 [Condensed]=90)

weight=(L R M B)
declare -A weightFilenameMap
weightFilenameMap=([L]=Lt [R]=R [M]=M [B]=Bd)
declare -A weightCondensedFilenameMap
weightCondensedFilenameMap=([L]=CondLt [R]=Cond [M]=CondM [B]=CondBd)

getMorpheus() {
	# getMorpheus weight
	case $1 in
		L) echo UI-CN-CondExLt.ttf;;
		R) echo UI-CN-CondM.ttf;;
		M) echo UI-CN-CondBd.ttf;;
		B) echo UI-CN-CondExBd.ttf;;
	esac
}

getEnglishFont() {
	# getEnglishFont regionalVariant chatFontWidth weight
	echo Nowar-WideUI-$1-${weightFilenameMap[$3]}.ttf
}

getEnglishChatFont() {
	# getEnglishChatFont regionalVariant chatFontWidth weight
	case $2 in
		Normal) echo Nowar-UI-$1-${weightFilenameMap[$3]}.ttf;;
		Compact) echo Nowar-CompactUI-$1-${weightFilenameMap[$3]}.ttf;;
		Condensed) echo Nowar-UI-$1-${weightCondensedFilenameMap[$3]}.ttf;;
	esac
}

getHansFont() {
	# getHansFont regionalVariant chatFontWidth weight
	echo Nowar-WarcraftSans-CN-${weightFilenameMap[$3]}.ttf
}

getHansCombatFont() {
	# getHansFont regionalVariant chatFontWidth weight
	echo Nowar-WideSans-CN-${weightFilenameMap[$3]}.ttf
}

getHansChatFont() {
	# getHansChatFont regionalVariant chatFontWidth weight
	case $2 in
		Normal) echo Nowar-Sans-CN-${weightFilenameMap[$3]}.ttf;;
		Compact) echo Nowar-CompactSans-CN-${weightFilenameMap[$3]}.ttf;;
		Condensed) echo Nowar-Sans-CN-${weightCondensedFilenameMap[$3]}.ttf;;
	esac
}

getHantFont() {
	# getHantFont regionalVariant chatFontWidth weight
	echo Nowar-WarcraftSans-TW-${weightFilenameMap[$3]}.ttf
}

getHantCombatFont() {
	# getHantFont regionalVariant chatFontWidth weight
	echo Nowar-WideSans-TW-${weightFilenameMap[$3]}.ttf
}

getHantNoteFont() {
	# getHantFont regionalVariant chatFontWidth weight
	echo Nowar-Sans-TW-${weightFilenameMap[$3]}.ttf
}

getHantChatFont() {
	# getHantChatFont regionalVariant chatFontWidth weight
	case $2 in
		Normal) echo Nowar-Sans-TW-${weightFilenameMap[$3]}.ttf;;
		Compact) echo Nowar-CompactSans-TW-${weightFilenameMap[$3]}.ttf;;
		Condensed) echo Nowar-Sans-TW-${weightCondensedFilenameMap[$3]}.ttf;;
	esac
}

for rv in ${regionalVariant[@]}; do
	for cfw in ${chatFontWidth[@]}; do
		for w in ${weight[@]}; do
			morpheus=$(getMorpheus $w)
			englishFont=$(getEnglishFont $rv $cfw $w)
			englishChatFont=$(getEnglishChatFont $rv $cfw $w)
			hansFont=$(getHansFont $rv $cfw $w)
			hansCombatFont=$(getHansCombatFont $rv $cfw $w)
			hansChatFont=$(getHansChatFont $rv $cfw $w)
			hantFont=$(getHantFont $rv $cfw $w)
			hantCombatFont=$(getHantCombatFont $rv $cfw $w)
			hantNoteFont=$(getHantNoteFont $rv $cfw $w)
			hantChatFont=$(getHantChatFont $rv $cfw $w)
			mkdir Fonts
			otfccdump --no-bom --ignore-hints --pretty morpheus/$morpheus   | sed 's/ CN//;s/-CN//;s/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o Fonts/MORPHEUS.ttf
			otfccdump --no-bom --ignore-hints --pretty ttf/$englishFont     | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o Fonts/FRIZQT__.ttf
			otfccdump --no-bom --ignore-hints --pretty ttf/$englishChatFont | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o Fonts/ARIALN.ttf
			otfccdump --no-bom --ignore-hints --pretty ttf/$hansCombatFont  | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o Fonts/ARKai_C.ttf
			otfccdump --no-bom --ignore-hints --pretty ttf/$hansChatFont    | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o Fonts/ARHei.ttf
			otfccdump --no-bom --ignore-hints --pretty ttf/$hantCombatFont  | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o Fonts/bKAI00M.ttf
			otfccdump --no-bom --ignore-hints --pretty ttf/$hantNoteFont    | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o Fonts/bHEI00M.ttf
			otfccdump --no-bom --ignore-hints --pretty ttf/$hantChatFont    | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o Fonts/bHEI01B.ttf
			cp Fonts/FRIZQT__.ttf Fonts/skurri.ttf
			cp Fonts/FRIZQT__.ttf Fonts/FRIENDS.ttf
			cp warcraft-ext/$hansFont Fonts/ARKai_T.ttf
			cp warcraft-ext/$hantFont Fonts/bLEI00D.ttf
			cp ../release-utility/license-wow-pack.txt Fonts/LICENSE.txt
			7z a -t7z -m0=LZMA:d=512m:fb=273 -ms -mmt=on ${regionalVariantName[$rv]}-${chatFontWidthName[$cfw]}-$w-$ver.7z Fonts/
			rm -r Fonts
		done
	done
done