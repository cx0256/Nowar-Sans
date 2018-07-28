Usage() {
	cd out/
	bash ../release-utility/generate-warcraft-ext.bash
}

regionalVariant=(CN TW)

warcraftFamily=(WarcraftSans NeoWarcraftSans)
declare -A warcraftFamilyMap
warcraftFamilyMap=([WarcraftSans]=Sans [NeoWarcraftSans]=NeoSans)
declare -A warcraftRenameMap
warcraftRenameMap=([WarcraftSans]="s/Nowar Sans/Nowar Warcraft Sans/;s/Nowar-Sans/Nowar-Warcraft-Sans/;s/有爱黑体/有爱魔兽黑体/;s/有愛黑體/有愛魔獸黑體/" [NeoWarcraftSans]="s/Nowar Neo Sans/Nowar Neo Warcraft Sans/;s/Nowar-Neo-Sans/Nowar-Neo-Warcraft-Sans/;s/有爱新异黑/有爱新异魔兽黑/;s/有愛新異黑/有愛新異魔獸黑/")

weight=(L R M B)
declare -A weightFilenameMap
weightFilenameMap=([L]=Lt [R]=R [M]=M [B]=Bd)
declare -A weightCondensedFilenameMap
weightCondensedFilenameMap=([L]=CondLt [R]=Cond [M]=CondM [B]=CondBd)

mkdir -p warcraft-ext/

for rv in ${regionalVariant[@]}; do
	for warf in ${warcraftFamily[@]}; do
		for w in ${weight[@]}; do
			mainFile=Nowar-${warcraftFamilyMap[$warf]}-$rv-${weightFilenameMap[$w]}
			numberFile=Nowar-${warcraftFamilyMap[$warf]}-$rv-${weightCondensedFilenameMap[$w]}
			outfile=Nowar-$warf-$rv-${weightFilenameMap[$w]}
			otfccdump --pretty --no-bom --ignore-hints ttf/$mainFile.ttf | sed "${warcraftRenameMap[$warf]}" > warcraft-ext/$mainFile.otd
			otfccdump --pretty --no-bom --ignore-hints ttf/$numberFile.ttf -o warcraft-ext/$numberFile.otd
			python <<EOF
import json
font = json.load(open("warcraft-ext/$mainFile.otd"))
number = json.load(open("warcraft-ext/$numberFile.otd"))
for n in ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]:
	font["glyf"][n] = number["glyf"][n]
json.dump(font, open("warcraft-ext/$outfile.otd", "w"), ensure_ascii=False)
EOF
			otfccbuild -O3 --keep-average-char-width warcraft-ext/$outfile.otd -o warcraft-ext/$outfile.ttf
		done
	done
done

rm warcraft-ext/*.otd
