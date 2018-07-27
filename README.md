# Nowar Sans (有爱黑体 / 有愛黑體)

This is Nowar Sans, a fully-hinted Chinese font based on Noto Sans and Source Han Sans, optimised for _World of Warcraft_.

> Make Love, Not Warcraft.<br>
> 要有爱，不要魔兽争霸。<br>
> 要愛，不要魔獸。

The unhinted version of Nowar Sans, is originally made for customized _World of Warcraft_ font packs, `WoW 有爱黑体` and `WoW 有愛黑體`. And that’s why it was named after “Nowar” (“有爱” / “有愛”).

## To Build

**WARNING**: 60 GiB free disk space on SSD required. When running with "-j8", it requires 16 GiB free memory, and takes about 18 hours.

You need [Node.js](https://nodejs.org/en/) 8.5 (or newer), [otfcc](https://github.com/caryll/otfcc), [AFDKO](http://www.adobe.com/devnet/opentype/afdko.html) and [ttfautohint](https://www.freetype.org/ttfautohint) installed, then run:

```bash
npm install
```

after the NPM packages are installed, run

```bash
node build ttf
```

to build the TTF files, it would be in `build/out` directory.

To build TTC, type

```bash
node build ttc
```

instead, the files would be in `build/ttc` directory.

### I Need an Unhinted Version

It is possible but really difficult to edit the script to generate an unhinted version of the font.

It is recommanded to remove hint from generated ttf file:

```bash
for file in *.ttf ; do
    otfccdump --ignore-hints --pretty $file | sed 's/; ttfautohint (v*.*)//' | otfccbuild -o $file -O3
done
```

`sed` changes the version string, and `--pretty` decreases memory consumption by `sed`.

By the way, if you just want to build an unhinted font for WoW font pack (or any other purpose), merging with [FontForge](https://fontforge.github.io/) is a good choise.

## What Are the Names?

- Sans and UI
  - Sans: Quotes (`“”`) are full width.
  - UI: Quotes (`“”`) are narrow.
- Latin, Greek and Cyrillic Families
  - Default: Humanist sans-serif, based on Noto Sans.
- Compact and Condensed
  - Compact (which is part of Preferred Family): Latin, Greek and Cyrillic characters are condensed, while CJK Ideographs and Kana are not.
  - Condensed (which is part of Preferred Subfamily): All characters are condensed.
- CN and TW
  - CN: CJK Ideographs follow 通用规范汉字表.
  - TW: CJK Ideographs follow 國字標準字體.

### Premade WoW Font Packs

- Regional variants
  - CN: CN variant preferred (CN variant for English and 简体中文, TW variant for 繁體中文)
  - TW: TW variant preferred (TW variant for English and 繁體中文, CN variant for 简体中文)
- Chat fonts
  - 100: Chat font are normal width.
  - 95: Chat font use Compact variant (CJK Ideographs are full width).
  - 90: Chat font use Condensed variant (CJK Ideographs are condensed).
- Weights
  - L: Light (Morpheus is ExtraLight)
  - R: Regular (Morpheus is Medium)
  - M: Medium (Morpheus is Bold)
  - B: Bold (Morpheus is ExtraBold)

Besides, you can make your own WoW Font Pack by copy `ttf` files to `World of Warcraft/Fonts` and rename them to `ARIALN.ttf`, `FRIZQT__.ttf`, …. Search web for more information.

## Font Weight

There are 6 weights.

| Weight     | CJK Ideographs and Kana | Hint      |
| ---------- | ----------------------- | --------- |
| ExtraLight | ExtraLight              | Fair      |
| Light      | Light                   | Good      |
| Regular    | Regular                 | Excellent |
| Medium     | Medium                  | Fair      |
| Bold       | Bold                    | Good      |
| ExtraBold  | Heavy                   | Fair      |

### Why Are Latin, Greek and Cyrillic Characters “Semi-Condensed”?

If not, numbers may be displayed incompletely in WoW 简体中文 and 繁體中文, such as character level in legacy guild frame, and numbers of reagents in profession crafting frame.

## Credit

This project is based on [Sarasa Gothic](https://github.com/be5invis/Sarasa-Gothic) by **Belleve Invis**.

Hint parameters for CJK ideograph are from [Ideohint Template for Source Han Sans](https://github.com/be5invis/source-han-sans-ttf) by **Belleve Invis**.

Latin, Greek and Cyrillic characters are from [Noto Sans](https://github.com/googlei18n/noto-fonts) by **Google**.

CJK Ideographs and Kana are from [Source Han Sans](https://github.com/adobe-fonts/source-han-sans) by **Adobe**.
