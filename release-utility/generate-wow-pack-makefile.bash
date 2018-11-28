Usage() {
	cd out/
	bash ../release-utility/generate-wow-pack-makefile.bash
	make -jN
}

ver=$(cat ../package.json | grep version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')

regionalVariant=(CN TW HK CL)

warcraftFamily=(WarcraftSans NeoWarcraftSans)
declare -A warcraftFamilyMap
warcraftFamilyMap=([WarcraftSans]=Sans [NeoWarcraftSans]=NeoSans)
declare -A warcraftRenameMap
warcraftRenameMap=([WarcraftSans]="s/Nowar Sans/Nowar Warcraft Sans/;s/Nowar-Sans/Nowar-Warcraft-Sans/;s/有爱黑体/有爱魔兽黑体/;s/有愛黑體/有愛魔獸黑體/" [NeoWarcraftSans]="s/Nowar Neo Sans/Nowar Neo Warcraft Sans/;s/Nowar-Neo-Sans/Nowar-Neo-Warcraft-Sans/")

weight=(L R M B)
declare -A weightFilenameMap
weightFilenameMap=([L]=Lt [R]=R [M]=M [B]=Bd)
declare -A weightCondensedFilenameMap
weightCondensedFilenameMap=([L]=CondLt [R]=Cond [M]=CondM [B]=CondBd)

chatFontWidth=(Compact Condensed)
declare -A chatFontWidthName
chatFontWidthName=([Normal]=100 [Compact]=95 [Condensed]=90)



cat >Makefile <<EOF
all: $(echo {,Neo-}{CN,TW,HK,CL}-95-{L,R,M,B}-$ver.7z)

EOF

# prepare Warcraft Sans

for rv in ${regionalVariant[@]}; do
	for warf in ${warcraftFamily[@]}; do
		for w in ${weight[@]}; do
			mainFile=Nowar-${warcraftFamilyMap[$warf]}-$rv-${weightFilenameMap[$w]}
			numberFile=${warcraftFamilyMap[$warf]}-CN-${weightCondensedFilenameMap[$w]}
			outfile=Nowar-$warf-$rv-${weightFilenameMap[$w]}

			cat >>Makefile <<EOF
warcraft-ext/$outfile.ttf: warcraft-ext/$outfile.otd
	otfccbuild -O3 --keep-average-char-width \$^ -o \$@

warcraft-ext/$outfile.otd: warcraft-ext/$mainFile.otd warcraft-ext/$numberFile.otd
	python ../release-utility/merge-numbers.py warcraft-ext/$mainFile.otd warcraft-ext/$numberFile.otd warcraft-ext/$outfile.otd

warcraft-ext/$mainFile.otd: ttf/$mainFile.ttf
	mkdir -p warcraft-ext
	otfccdump --pretty --no-bom --ignore-hints \$^ | sed "s/; ttfautohint (v*.*)//;${warcraftRenameMap[$warf]}" > \$@

warcraft-ext/$numberFile.otd: ../build/pass1/$numberFile.ttf
	mkdir -p warcraft-ext
	otfccdump --pretty --no-bom --ignore-hints \$^ -o \$@

EOF
		done
	done
done

# Humanist

getMorpheus() {
	# getMorpheus weight
	case $1 in
		L) echo CompactUI-CN-ExLt.ttf;;
		R) echo CompactUI-CN-M.ttf;;
		M) echo CompactUI-CN-Bd.ttf;;
		B) echo CompactUI-CN-ExBd.ttf;;
	esac
}

getSkurri() {
	# getSkurri weight
	echo WideUI-CN-${weightFilenameMap[$1]}.ttf
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
	if [[ "$1" == "CL" ]]; then
		echo Nowar-WarcraftSans-$1-${weightFilenameMap[$3]}.ttf
	else
		echo Nowar-WarcraftSans-CN-${weightFilenameMap[$3]}.ttf
	fi
}

getHansCombatFont() {
	# getHansFont regionalVariant chatFontWidth weight
	if [[ "$1" == "CL" ]]; then
		echo Nowar-WideSans-$1-${weightFilenameMap[$3]}.ttf
	else
		echo Nowar-WideSans-CN-${weightFilenameMap[$3]}.ttf
	fi
}

getHansChatFont() {
	# getHansChatFont regionalVariant chatFontWidth weight
	if [[ "$1" == "CL" ]]; then
		case $2 in
			Normal) echo Nowar-Sans-$1-${weightFilenameMap[$3]}.ttf;;
			Compact) echo Nowar-CompactSans-$1-${weightFilenameMap[$3]}.ttf;;
			Condensed) echo Nowar-Sans-$1-${weightCondensedFilenameMap[$3]}.ttf;;
		esac
	else
		case $2 in
			Normal) echo Nowar-Sans-CN-${weightFilenameMap[$3]}.ttf;;
			Compact) echo Nowar-CompactSans-CN-${weightFilenameMap[$3]}.ttf;;
			Condensed) echo Nowar-Sans-CN-${weightCondensedFilenameMap[$3]}.ttf;;
		esac
	fi
}

getHantFont() {
	# getHantFont regionalVariant chatFontWidth weight
	if [[ "$1" == "HK" || "$1" == "CL" ]]; then
		echo Nowar-WarcraftSans-$1-${weightFilenameMap[$3]}.ttf
	else
		echo Nowar-WarcraftSans-TW-${weightFilenameMap[$3]}.ttf
	fi
}

getHantCombatFont() {
	# getHantFont regionalVariant chatFontWidth weight
	if [[ "$1" == "HK" || "$1" == "CL" ]]; then
		echo Nowar-WideSans-$1-${weightFilenameMap[$3]}.ttf
	else
		echo Nowar-WideSans-TW-${weightFilenameMap[$3]}.ttf
	fi
}

getHantNoteFont() {
	# getHantFont regionalVariant chatFontWidth weight
	if [[ "$1" == "HK" || "$1" == "CL" ]]; then
		echo Nowar-Sans-$1-${weightFilenameMap[$3]}.ttf
	else
		echo Nowar-Sans-TW-${weightFilenameMap[$3]}.ttf
	fi
}

getHantChatFont() {
	# getHantChatFont regionalVariant chatFontWidth weight
	if [[ "$1" == "HK" || "$1" == "CL" ]]; then
		case $2 in
			Normal) echo Nowar-Sans-$1-${weightFilenameMap[$3]}.ttf;;
			Compact) echo Nowar-CompactSans-$1-${weightFilenameMap[$3]}.ttf;;
			Condensed) echo Nowar-Sans-$1-${weightCondensedFilenameMap[$3]}.ttf;;
		esac
	else
		case $2 in
			Normal) echo Nowar-Sans-TW-${weightFilenameMap[$3]}.ttf;;
			Compact) echo Nowar-CompactSans-TW-${weightFilenameMap[$3]}.ttf;;
			Condensed) echo Nowar-Sans-TW-${weightCondensedFilenameMap[$3]}.ttf;;
		esac
	fi
}

getKoreanFont() {
	# getKoreanFont regionalVariant chatFontWidth weight
	echo Nowar-WarcraftSans-CL-${weightFilenameMap[$3]}.ttf
}

getKoreanCombatFont() {
	# getKoreanCombatFont regionalVariant chatFontWidth weight
	echo Nowar-WideSans-CL-${weightFilenameMap[$3]}.ttf
}

getKoreanDisplayFont() {
	# getKoreanFont regionalVariant chatFontWidth weight
	echo Nowar-CompactSans-CL-${weightFilenameMap[$3]}.ttf
}

for rv in ${regionalVariant[@]}; do
	for cfw in ${chatFontWidth[@]}; do
		for w in ${weight[@]}; do
			target=$rv-${chatFontWidthName[$cfw]}-$w
			morpheus=$(getMorpheus $w)
			skurri=$(getSkurri $w)
			englishFont=$(getEnglishFont $rv $cfw $w)
			englishChatFont=$(getEnglishChatFont $rv $cfw $w)
			hansFont=$(getHansFont $rv $cfw $w)
			hansCombatFont=$(getHansCombatFont $rv $cfw $w)
			hansChatFont=$(getHansChatFont $rv $cfw $w)
			hantFont=$(getHantFont $rv $cfw $w)
			hantCombatFont=$(getHantCombatFont $rv $cfw $w)
			hantNoteFont=$(getHantNoteFont $rv $cfw $w)
			hantChatFont=$(getHantChatFont $rv $cfw $w)
			koreanFont=$(getKoreanFont $rv $cfw $w)
			koreanCombatFont=$(getKoreanCombatFont $rv $cfw $w)
			koreanDisplayFont=$(getKoreanDisplayFont $rv $cfw $w)

			cat >>Makefile <<EOF
$target-$ver.7z: $target/Fonts/MORPHEUS.ttf $target/Fonts/FRIZQT__.ttf $target/Fonts/ARIALN.ttf $target/Fonts/skurri.ttf \\
                 $target/Fonts/MORPHEUS_CYR.ttf $target/Fonts/FRIZQT___CYR.ttf $target/Fonts/SKURRI_CYR.ttf \\
                 $target/Fonts/ARKai_C.ttf $target/Fonts/ARKai_T.ttf $target/Fonts/ARHei.ttf \\
                 $target/Fonts/bKAI00M.ttf $target/Fonts/bHEI00M.ttf $target/Fonts/bHEI01B.ttf $target/Fonts/blei00d.ttf \\
                 $target/Fonts/2002.ttf $target/Fonts/2002B.ttf $target/Fonts/K_Damage.ttf $target/Fonts/K_Pagetext.ttf
	cd $target ; \\
	cp ../../release-utility/license-wow-pack.txt Fonts/LICENSE.txt ; \\
	7z a -t7z -m0=LZMA:d=512m:fb=273 -ms -mmt=on ../\$@ Fonts/

$target/Fonts/MORPHEUS.ttf: warcraft/$morpheus
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/MORPHEUS_CYR.ttf: warcraft/$morpheus
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/FRIZQT__.ttf: warcraft/$englishFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/FRIZQT___CYR.ttf: warcraft/$englishFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/ARIALN.ttf: warcraft/$englishChatFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/skurri.ttf: warcraft/$skurri
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/SKURRI_CYR.ttf: warcraft/$skurri
	mkdir -p $target/Fonts
	cp \$^ \$@

$target/Fonts/ARKai_C.ttf: warcraft/$hansCombatFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/ARKai_T.ttf: warcraft-ext/$hansFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/ARHei.ttf: warcraft/$hansChatFont
	mkdir -p $target/Fonts
	cp \$^ \$@

$target/Fonts/bKAI00M.ttf: warcraft/$hantCombatFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/bHEI00M.ttf: warcraft/$hantNoteFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/bHEI01B.ttf: warcraft/$hantChatFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/blei00d.ttf: warcraft-ext/$hantFont
	mkdir -p $target/Fonts
	cp \$^ \$@

$target/Fonts/2002.ttf: warcraft-ext/$koreanFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/2002B.ttf: warcraft/$koreanCombatFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/K_Damage.ttf: warcraft/$koreanCombatFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/K_Pagetext.ttf: warcraft/$koreanDisplayFont
	mkdir -p $target/Fonts
	cp \$^ \$@

warcraft/$morpheus: ../build/pass1/$morpheus
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/ CN//;s/-CN//;s/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$skurri: ../build/pass1/$skurri
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/ CN//;s/-CN//;s/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$englishFont: ttf/$englishFont
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$englishChatFont: ttf/$englishChatFont
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$hansCombatFont: ttf/$hansCombatFont
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$hansChatFont: ttf/$hansChatFont
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$hantCombatFont: ttf/$hantCombatFont
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$hantNoteFont: ttf/$hantNoteFont
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$hantChatFont: ttf/$hantChatFont
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$koreanCombatFont: ttf/$koreanCombatFont
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$koreanDisplayFont: ttf/$koreanDisplayFont
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@

EOF
		done
	done
done

# Neo-Grotesque

getMorpheus() {
	# getMorpheus weight
	case $1 in
		L) echo NeoCompactUI-CN-Lt.ttf;;
		R) echo NeoCompactUI-CN-M.ttf;;
		M) echo NeoCompactUI-CN-Bd.ttf;;
		B) echo NeoCompactUI-CN-Bd.ttf;;
	esac
}

getSkurri() {
	# getSkurri weight
	echo NeoUI-CN-${weightFilenameMap[$1]}.ttf
}

getEnglishFont() {
	# getEnglishFont regionalVariant chatFontWidth weight
	echo Nowar-NeoUI-$1-${weightFilenameMap[$3]}.ttf
}

getEnglishChatFont() {
	# getEnglishChatFont regionalVariant chatFontWidth weight
	case $2 in
		Normal) echo Nowar-NeoUI-$1-${weightFilenameMap[$3]}.ttf;;
		Compact) echo Nowar-NeoCompactUI-$1-${weightFilenameMap[$3]}.ttf;;
		Condensed) echo Nowar-NeoUI-$1-${weightCondensedFilenameMap[$3]}.ttf;;
	esac
}

getHansFont() {
	# getHansFont regionalVariant chatFontWidth weight
	if [[ "$1" == "CL" ]]; then
		echo Nowar-NeoWarcraftSans-$1-${weightFilenameMap[$3]}.ttf
	else
		echo Nowar-NeoWarcraftSans-CN-${weightFilenameMap[$3]}.ttf
	fi
}

getHansCombatFont() {
	# getHansFont regionalVariant chatFontWidth weight
	if [[ "$1" == "CL" ]]; then
		echo Nowar-NeoSans-$1-${weightFilenameMap[$3]}.ttf
	else
		echo Nowar-NeoSans-CN-${weightFilenameMap[$3]}.ttf
	fi
}

getHansChatFont() {
	# getHansChatFont regionalVariant chatFontWidth weight
	if [[ "$1" == "CL" ]]; then
		case $2 in
			Normal) echo Nowar-NeoSans-$1-${weightFilenameMap[$3]}.ttf;;
			Compact) echo Nowar-NeoCompactSans-$1-${weightFilenameMap[$3]}.ttf;;
			Condensed) echo Nowar-NeoSans-$1-${weightCondensedFilenameMap[$3]}.ttf;;
		esac
	else
		case $2 in
			Normal) echo Nowar-NeoSans-CN-${weightFilenameMap[$3]}.ttf;;
			Compact) echo Nowar-NeoCompactSans-CN-${weightFilenameMap[$3]}.ttf;;
			Condensed) echo Nowar-NeoSans-CN-${weightCondensedFilenameMap[$3]}.ttf;;
		esac
	fi
}

getHantFont() {
	# getHantFont regionalVariant chatFontWidth weight
	if [[ "$1" == "HK" || "$1" == "CL" ]]; then
		echo Nowar-NeoWarcraftSans-$1-${weightFilenameMap[$3]}.ttf
	else
		echo Nowar-NeoWarcraftSans-TW-${weightFilenameMap[$3]}.ttf
	fi
}

getHantCombatFont() {
	# getHantFont regionalVariant chatFontWidth weight
	if [[ "$1" == "HK" || "$1" == "CL" ]]; then
		echo Nowar-NeoSans-$1-${weightFilenameMap[$3]}.ttf
	else
		echo Nowar-NeoSans-TW-${weightFilenameMap[$3]}.ttf
	fi
}

getHantNoteFont() {
	# getHantFont regionalVariant chatFontWidth weight
	if [[ "$1" == "HK" || "$1" == "CL" ]]; then
		echo Nowar-NeoSans-$1-${weightFilenameMap[$3]}.ttf
	else
		echo Nowar-NeoSans-TW-${weightFilenameMap[$3]}.ttf
	fi
}

getHantChatFont() {
	# getHantChatFont regionalVariant chatFontWidth weight
	if [[ "$1" == "HK" || "$1" == "CL" ]]; then
		case $2 in
			Normal) echo Nowar-NeoSans-$1-${weightFilenameMap[$3]}.ttf;;
			Compact) echo Nowar-NeoCompactSans-$1-${weightFilenameMap[$3]}.ttf;;
			Condensed) echo Nowar-NeoSans-$1-${weightCondensedFilenameMap[$3]}.ttf;;
		esac
	else
		case $2 in
			Normal) echo Nowar-NeoSans-TW-${weightFilenameMap[$3]}.ttf;;
			Compact) echo Nowar-NeoCompactSans-TW-${weightFilenameMap[$3]}.ttf;;
			Condensed) echo Nowar-NeoSans-TW-${weightCondensedFilenameMap[$3]}.ttf;;
		esac
	fi
}

getKoreanFont() {
	# getKoreanFont regionalVariant chatFontWidth weight
	echo Nowar-NeoWarcraftSans-CL-${weightFilenameMap[$3]}.ttf
}

getKoreanCombatFont() {
	# getKoreanCombatFont regionalVariant chatFontWidth weight
	echo Nowar-NeoSans-CL-${weightFilenameMap[$3]}.ttf
}

getKoreanDisplayFont() {
	# getKoreanFont regionalVariant chatFontWidth weight
	echo Nowar-NeoCompactSans-CL-${weightFilenameMap[$3]}.ttf
}

for rv in ${regionalVariant[@]}; do
	for cfw in ${chatFontWidth[@]}; do
		for w in ${weight[@]}; do
			target=Neo-$rv-${chatFontWidthName[$cfw]}-$w
			morpheus=$(getMorpheus $w)
			skurri=$(getSkurri $w)
			englishFont=$(getEnglishFont $rv $cfw $w)
			englishChatFont=$(getEnglishChatFont $rv $cfw $w)
			hansFont=$(getHansFont $rv $cfw $w)
			hansCombatFont=$(getHansCombatFont $rv $cfw $w)
			hansChatFont=$(getHansChatFont $rv $cfw $w)
			hantFont=$(getHantFont $rv $cfw $w)
			hantCombatFont=$(getHantCombatFont $rv $cfw $w)
			hantNoteFont=$(getHantNoteFont $rv $cfw $w)
			hantChatFont=$(getHantChatFont $rv $cfw $w)
			koreanFont=$(getKoreanFont $rv $cfw $w)
			koreanCombatFont=$(getKoreanCombatFont $rv $cfw $w)
			koreanDisplayFont=$(getKoreanDisplayFont $rv $cfw $w)

			cat >>Makefile <<EOF
$target-$ver.7z: $target/Fonts/MORPHEUS.ttf $target/Fonts/FRIZQT__.ttf $target/Fonts/ARIALN.ttf $target/Fonts/skurri.ttf \\
                 $target/Fonts/MORPHEUS_CYR.ttf $target/Fonts/FRIZQT___CYR.ttf $target/Fonts/SKURRI_CYR.ttf \\
                 $target/Fonts/ARKai_C.ttf $target/Fonts/ARKai_T.ttf $target/Fonts/ARHei.ttf \\
                 $target/Fonts/bKAI00M.ttf $target/Fonts/bHEI00M.ttf $target/Fonts/bHEI01B.ttf $target/Fonts/blei00d.ttf \\
                 $target/Fonts/2002.ttf $target/Fonts/2002B.ttf $target/Fonts/K_Damage.ttf $target/Fonts/K_Pagetext.ttf
	cd $target ; \\
	cp ../../release-utility/license-wow-pack-roboto.txt Fonts/LICENSE.txt ; \\
	7z a -t7z -m0=LZMA:d=512m:fb=273 -ms -mmt=on ../\$@ Fonts/

$target/Fonts/MORPHEUS.ttf: warcraft/$morpheus
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/MORPHEUS_CYR.ttf: warcraft/$morpheus
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/FRIZQT__.ttf: warcraft/$englishFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/FRIZQT___CYR.ttf: warcraft/$englishFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/ARIALN.ttf: warcraft/$englishChatFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/skurri.ttf: warcraft/$skurri
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/SKURRI_CYR.ttf: warcraft/$skurri
	mkdir -p $target/Fonts
	cp \$^ \$@

$target/Fonts/ARKai_C.ttf: warcraft/$hansCombatFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/ARKai_T.ttf: warcraft-ext/$hansFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/ARHei.ttf: warcraft/$hansChatFont
	mkdir -p $target/Fonts
	cp \$^ \$@

$target/Fonts/bKAI00M.ttf: warcraft/$hantCombatFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/bHEI00M.ttf: warcraft/$hantNoteFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/bHEI01B.ttf: warcraft/$hantChatFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/blei00d.ttf: warcraft-ext/$hantFont
	mkdir -p $target/Fonts
	cp \$^ \$@

$target/Fonts/2002.ttf: warcraft-ext/$koreanFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/2002B.ttf: warcraft/$koreanCombatFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/K_Damage.ttf: warcraft/$koreanCombatFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/K_Pagetext.ttf: warcraft/$koreanDisplayFont
	mkdir -p $target/Fonts
	cp \$^ \$@

warcraft/$morpheus: ../build/pass1/$morpheus
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/ CN//;s/-CN//;s/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$skurri: ../build/pass1/$skurri
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/ CN//;s/-CN//;s/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$englishFont: ttf/$englishFont
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$englishChatFont: ttf/$englishChatFont
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$hansCombatFont: ttf/$hansCombatFont
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$hansChatFont: ttf/$hansChatFont
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$hantCombatFont: ttf/$hantCombatFont
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$hantNoteFont: ttf/$hantNoteFont
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$hantChatFont: ttf/$hantChatFont
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$koreanCombatFont: ttf/$koreanCombatFont
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@
warcraft/$koreanDisplayFont: ttf/$koreanDisplayFont
	mkdir -p warcraft
	otfccdump --no-bom --ignore-hints --pretty \$^ | sed 's/; ttfautohint (v*.*)//' | otfccbuild --keep-average-char-width -O3 -o \$@

EOF
		done
	done
done
