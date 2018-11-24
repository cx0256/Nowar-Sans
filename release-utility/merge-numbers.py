import json
import sys

font = json.load(open(sys.argv[1]))
number = json.load(open(sys.argv[2]))
for n in ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]:
	font["glyf"][n] = number["glyf"][n]
out = json.dumps(font, ensure_ascii=False)
open(sys.argv[3], "w").write(out)