Usage() {
    cd out/
    bash ../release-utility/generate-ttf-pack.bash
}

ver=$(cat ../package.json | grep version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')

cp ../LICENSE ttf/
cp ../LICENSE ttc/

cd ttc/

7z a -t7z -m0=LZMA:d=512m:fb=273 -ms -mmt=on ../NowarSansTTC-$ver.7z *

cd ../ttf/

target=../NowarSansTTF-$ver.7z

7z a -t7z -m0=LZMA:d=512m:fb=273 -ms -mmt=on $target LICENSE

7z a -t7z -m0=LZMA:d=512m:fb=273 -ms -mmt=on $target *-R.ttf *-Cond.ttf *-It.ttf *-CondIt.ttf

for weight in ExLt Lt M Bd ExBd; do
	7z a -t7z -m0=LZMA:d=512m:fb=273 -ms -mmt=on $target *-${weight}.ttf *-Cond${weight}.ttf *-${weight}It.ttf *-Cond${weight}It.ttf
done
