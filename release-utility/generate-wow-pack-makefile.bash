Usage() {
	cd out/
	bash ../release-utility/generate-wow-pack-makefile.bash
	make -jN
}

ver=$(cat ../package.json | grep version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')

regionalVariant=(CN TW HK)

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
all: $(echo {,Neo-}{CN,TW,HK}-{90,95}-{L,R,M,B}-$ver.7z)

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
	if [[ "$1" == "HK" ]]; then
		echo Nowar-WarcraftSans-HK-${weightFilenameMap[$3]}.ttf
	else
		echo Nowar-WarcraftSans-TW-${weightFilenameMap[$3]}.ttf
	fi
}

getHantCombatFont() {
	# getHantFont regionalVariant chatFontWidth weight
	if [[ "$1" == "HK" ]]; then
		echo Nowar-WideSans-HK-${weightFilenameMap[$3]}.ttf
	else
		echo Nowar-WideSans-TW-${weightFilenameMap[$3]}.ttf
	fi
}

getHantNoteFont() {
	# getHantFont regionalVariant chatFontWidth weight
	if [[ "$1" == "HK" ]]; then
		echo Nowar-Sans-HK-${weightFilenameMap[$3]}.ttf
	else
		echo Nowar-Sans-TW-${weightFilenameMap[$3]}.ttf
	fi
}

getHantChatFont() {
	# getHantChatFont regionalVariant chatFontWidth weight
	if [[ "$1" == "HK" ]]; then
		case $2 in
			Normal) echo Nowar-Sans-HK-${weightFilenameMap[$3]}.ttf;;
			Compact) echo Nowar-CompactSans-HK-${weightFilenameMap[$3]}.ttf;;
			Condensed) echo Nowar-Sans-HK-${weightCondensedFilenameMap[$3]}.ttf;;
		esac
	else
		case $2 in
			Normal) echo Nowar-Sans-TW-${weightFilenameMap[$3]}.ttf;;
			Compact) echo Nowar-CompactSans-TW-${weightFilenameMap[$3]}.ttf;;
			Condensed) echo Nowar-Sans-TW-${weightCondensedFilenameMap[$3]}.ttf;;
		esac
	fi
}

for rv in ${regionalVariant[@]}; do
	for cfw in ${chatFontWidth[@]}; do
		for w in ${weight[@]}; do
			target=$rv-${chatFontWidthName[$cfw]}-$w
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

			cat >>Makefile <<EOF
$target-$ver.7z: $target/Fonts/MORPHEUS.ttf $target/Fonts/FRIZQT__.ttf $target/Fonts/ARIALN.ttf $target/Fonts/skurri.ttf $target/Fonts/FRIENDS.ttf \
                 $target/Fonts/ARKai_C.ttf $target/Fonts/ARKai_T.ttf $target/Fonts/ARHei.ttf \
                 $target/Fonts/bKAI00M.ttf $target/Fonts/bHEI00M.ttf $target/Fonts/bHEI01B.ttf $target/Fonts/bLEI00D.ttf
	cd $target ; \
	cp ../../release-utility/license-wow-pack.txt Fonts/LICENSE.txt ; \
	7z a -t7z -m0=LZMA:d=512m:fb=273 -ms -mmt=on ../\$@ Fonts/

$target/Fonts/MORPHEUS.ttf: warcraft/$morpheus
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/FRIZQT__.ttf: warcraft/$englishFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/ARIALN.ttf: warcraft/$englishChatFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/skurri.ttf: warcraft/$englishFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/FRIENDS.ttf: warcraft/$englishFont
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
$target/Fonts/bLEI00D.ttf: warcraft-ext/$hantFont
	mkdir -p $target/Fonts
	cp \$^ \$@

warcraft/$morpheus: ../build/pass1/$morpheus
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

EOF
		done
	done
done

# Neo-Grotesque

getMorpheus() {
	# getMorpheus weight
	case $1 in
		L) echo NeoUI-CN-CondLt.ttf;;
		R) echo NeoUI-CN-Cond.ttf;;
		M) echo NeoUI-CN-CondM.ttf;;
		B) echo NeoUI-CN-CondBd.ttf;;
	esac
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
	echo Nowar-NeoWarcraftSans-CN-${weightFilenameMap[$3]}.ttf
}

getHansCombatFont() {
	# getHansFont regionalVariant chatFontWidth weight
	echo Nowar-NeoSans-CN-${weightFilenameMap[$3]}.ttf
}

getHansChatFont() {
	# getHansChatFont regionalVariant chatFontWidth weight
	case $2 in
		Normal) echo Nowar-NeoSans-CN-${weightFilenameMap[$3]}.ttf;;
		Compact) echo Nowar-NeoCompactSans-CN-${weightFilenameMap[$3]}.ttf;;
		Condensed) echo Nowar-NeoSans-CN-${weightCondensedFilenameMap[$3]}.ttf;;
	esac
}

getHantFont() {
	# getHantFont regionalVariant chatFontWidth weight
	if [[ "$1" == "HK" ]]; then
		echo Nowar-NeoWarcraftSans-HK-${weightFilenameMap[$3]}.ttf
	else
		echo Nowar-NeoWarcraftSans-TW-${weightFilenameMap[$3]}.ttf
	fi
}

getHantCombatFont() {
	# getHantFont regionalVariant chatFontWidth weight
	if [[ "$1" == "HK" ]]; then
		echo Nowar-NeoSans-HK-${weightFilenameMap[$3]}.ttf
	else
		echo Nowar-NeoSans-TW-${weightFilenameMap[$3]}.ttf
	fi
}

getHantNoteFont() {
	# getHantFont regionalVariant chatFontWidth weight
	if [[ "$1" == "HK" ]]; then
		echo Nowar-NeoSans-HK-${weightFilenameMap[$3]}.ttf
	else
		echo Nowar-NeoSans-TW-${weightFilenameMap[$3]}.ttf
	fi
}

getHantChatFont() {
	# getHantChatFont regionalVariant chatFontWidth weight
	if [[ "$1" == "HK" ]]; then
		case $2 in
			Normal) echo Nowar-NeoSans-HK-${weightFilenameMap[$3]}.ttf;;
			Compact) echo Nowar-NeoCompactSans-HK-${weightFilenameMap[$3]}.ttf;;
			Condensed) echo Nowar-NeoSans-HK-${weightCondensedFilenameMap[$3]}.ttf;;
		esac
	else
		case $2 in
			Normal) echo Nowar-NeoSans-TW-${weightFilenameMap[$3]}.ttf;;
			Compact) echo Nowar-NeoCompactSans-TW-${weightFilenameMap[$3]}.ttf;;
			Condensed) echo Nowar-NeoSans-TW-${weightCondensedFilenameMap[$3]}.ttf;;
		esac
	fi
}

for rv in ${regionalVariant[@]}; do
	for cfw in ${chatFontWidth[@]}; do
		for w in ${weight[@]}; do
			target=Neo-$rv-${chatFontWidthName[$cfw]}-$w
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

			cat >>Makefile <<EOF
$target-$ver.7z: $target/Fonts/MORPHEUS.ttf $target/Fonts/FRIZQT__.ttf $target/Fonts/ARIALN.ttf $target/Fonts/skurri.ttf $target/Fonts/FRIENDS.ttf \
                 $target/Fonts/ARKai_C.ttf $target/Fonts/ARKai_T.ttf $target/Fonts/ARHei.ttf \
                 $target/Fonts/bKAI00M.ttf $target/Fonts/bHEI00M.ttf $target/Fonts/bHEI01B.ttf $target/Fonts/bLEI00D.ttf
	cd $target ; \
	cp ../../release-utility/license-wow-pack-roboto.txt Fonts/LICENSE.txt ; \
	7z a -t7z -m0=LZMA:d=512m:fb=273 -ms -mmt=on ../\$@ Fonts/

$target/Fonts/MORPHEUS.ttf: warcraft/$morpheus
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/FRIZQT__.ttf: warcraft/$englishFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/ARIALN.ttf: warcraft/$englishChatFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/skurri.ttf: warcraft/$englishFont
	mkdir -p $target/Fonts
	cp \$^ \$@
$target/Fonts/FRIENDS.ttf: warcraft/$englishFont
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
$target/Fonts/bLEI00D.ttf: warcraft-ext/$hantFont
	mkdir -p $target/Fonts
	cp \$^ \$@

warcraft/$morpheus: ../build/pass1/$morpheus
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

EOF
		done
	done
done
