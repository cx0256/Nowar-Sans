# Nowar Sans (有爱黑体 / 有愛黑體)

This is Nowar Sans, a fully-hinted Chinese font family based on Noto Sans, Roboto and Source Han Sans, optimised for _World of Warcraft_.

> Make Love, Not Warcraft.<br>
> 要有爱，不要魔兽争霸。<br>
> 要愛，不要魔獸。

The unhinted version of Nowar Sans, is originally made for customized _World of Warcraft_ font packs, `WoW 有爱黑体` and `WoW 有愛黑體`. And that’s why it is named after “Nowar” (“有爱” / “有愛”).

## Guide for Getting Nowar Sans

Nowar Sans font files can be found at [Releases](https://github.com/CyanoHao/Nowar-Sans/releases).

“Nowar Sans _version_” are general purpose fonts, provided in `ttf` and `ttc` format.
- `NowarSansTTC-<version>.7z` contains all `ttc` files. These `ttc` files contain too much fonts, which are not available in legacy Windows. If they’re not available, try `ttf` files instead.
- `NowarSansTTF-<version>.7z` contains all `ttf` files. `ttf` files are more compatible (even available in Windows 98) but **really huge** (~ 21 GiB).

“WoW Font Pack _version_ (Humanist/Neo-Grotesque)” are _World of Warcraft_ font pack.
- “Humanist” and “Neo-Grotesque” are different in Latin, Greek and Cyrillic family (see “What are the names?” below).
- See “What Are the Names? → Premade WoW Font Packs” for more information about font styles.

To apply WoW font pack, download the one you like, then extract it and move `Fonts` to `World of Warcraft/`.

## What Are the Names?

- Sans and UI
  - Sans: Quotes (`“”`) are full width.
  - UI: Quotes (`“”`) are narrow.
- Latin, Greek and Cyrillic family
  - Default: Humanist sans-serif, based on Noto Sans.
  - Neo: Neo-grotesque sans-serif, based on Roboto.
- Width
  - Compact (which is part of Preferred Family): Latin, Greek and Cyrillic characters are condensed, while CJK Ideographs and Kana are not.
  - Condensed (which is part of Preferred Subfamily): All characters are condensed.
  - Wide (which is part of Preferred Family): Latin, Greek and Cyrillic characters are extended, while CJK Ideographs and Kana are not.
- Regional variants
  - CN: CJK Ideographs follow 通用规范汉字表.
  - TW: CJK Ideographs follow 國字標準字體.
  - HK: CJK Ideographs follow 中文電腦字形參考指引.
  - CL: CJK Ideographs follow traditional printing style.

### Premade WoW Font Packs

- Regional variants
  - CN: CN variant preferred (CN variant for English and 简体中文, TW variant for 繁體中文, CL variant for 한국어)
  - TW: TW variant preferred (TW variant for English and 繁體中文, CN variant for 简体中文, CL variant for 한국어)
  - HK: HK variant preferred (HK variant for English and 繁體中文, CN variant for 简体中文, CL variant for 한국어)
  - CL: Force to CL variant (CL variant for all languages)
- Weights
  - L: Light
  - R: Regular
  - M: Medium
  - B: Bold
  - [Morpheus (English title font) may be bolder or lighter.]

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

## To Build

You need [Node.js](https://nodejs.org/en/) 8.5 (or newer), [otfcc](https://github.com/caryll/otfcc), [AFDKO](http://www.adobe.com/devnet/opentype/afdko.html) and [ttfautohint](https://www.freetype.org/ttfautohint) installed, then run:

```bash
npm install
```

after the NPM packages are installed, run

```bash
node build ttf
```

to build the TTF files, it would be in `build/out` directory.

**WARNING**:
- The directory `Nowar-Sans/` will eat up 160 GiB disk space when building `ttf`. (And it will shortly shrink to 48 GiB.)
- When running with `-j8`, it requires up to 20 GiB memory, and takes more than 24 hours.

To build TTC, type

```bash
node build ttc
```

instead, the files would be in `build/ttc` directory.

**WARNING**:
- The directory `Nowar-Sans/` will eat up 200 GiB disk space when building `ttc`. (And it will finally shrink to 52 GiB.)
- When running with `-j8`, it requires up to 24 GiB memory, and takes about 6 hours if `ttf` has been already built.

### Boost Building Process

Since [Nowar Sans 0.3.9](https://github.com/CyanoHao/Nowar-Sans/releases/tag/v0.3.9), ideohint cache files are also provided. With existing cache files, building time will be reduced by up to 60%.

To make use of cache file, just download `Nowar-IdeohintCache-<version>.7z`, then extract it and move `hint-_sg{1,2,3,4,5,6}.hgc` to `Nowar-Sans/hint/build/` before building.

Note: These cache files were built on Windows. If you are to build on Linux or macOS, backslashes (`\\`) in filenames should be replaced to slashes (`/`). `head hint-_sg1.hgc` may be helpful.

### I Need an Unhinted Version

It is possible but really difficult to edit the script to generate an unhinted version of the fonts.

It is recommanded to remove hint from generated `ttf` files:

```bash
for file in *.ttf ; do
    otfccdump --ignore-hints --pretty $file | sed 's/; ttfautohint (v*.*)//' | otfccbuild -o $file -O3
done
```

`sed` changes the version string, and `--pretty` decreases memory consumption by `sed`.

By the way, if you just want to build an unhinted font for WoW font pack (or any other purpose), merging with [FontForge](https://fontforge.github.io/) is a good choise.

## Credit

This project is based on [Sarasa Gothic](https://github.com/be5invis/Sarasa-Gothic) by **Belleve Invis**.

Hint parameters for CJK ideograph are from [Ideohint Template for Source Han Sans](https://github.com/be5invis/source-han-sans-ttf) by **Belleve Invis**.

Latin, Greek and Cyrillic characters are from [Noto Sans](https://github.com/googlei18n/noto-fonts) and [Roboto](https://github.com/google/roboto) by **Google**.

CJK Ideographs and Kana are from [Source Han Sans](https://github.com/adobe-fonts/source-han-sans) by **Adobe**.
