"""Builds assets/fonts/NotoSansSC-Subset.ttf, the Chinese font for PDF reports.

The PDF library can't use system fonts, so Chinese text in a report needs a
bundled font. The full Noto Sans SC is ~10.5 MB, so this keeps only:
  - every character in GB2312 (6,763 common Simplified hanzi + symbols),
    which covers what owners are likely to type (pet names, notes)
  - every character in the app's Chinese strings (lib/l10n/app_zh.arb)
  - Latin, punctuation and full-width forms

Rare characters outside that set fall back to empty boxes in the PDF only;
the app itself uses the system font. Re-run after adding Chinese strings:

  pip install fonttools
  python3 tool/fonts/subset_noto_sans_sc.py path/to/NotoSansSC-Regular.ttf

The source font is Google Fonts' Noto Sans SC Regular (OFL; the licence is
assets/fonts/OFL-notosanssc.txt).
"""
import json
import sys

from fontTools import subset

OUT = 'assets/fonts/NotoSansSC-Subset.ttf'


def gb2312():
    chars = set()
    for hi in range(0xA1, 0xF8):
        for lo in range(0xA1, 0xFF):
            try:
                chars.update(bytes([hi, lo]).decode('gb2312'))
            except UnicodeDecodeError:
                pass
    return chars


def main(source):
    chars = gb2312()
    chars.update(''.join(v for k, v in json.load(
        open('lib/l10n/app_zh.arb', encoding='utf-8')).items()
        if not k.startswith('@') and isinstance(v, str)))
    codepoints = {ord(c) for c in chars}
    codepoints.update(range(0x20, 0x7F))      # ASCII
    codepoints.update(range(0xA0, 0x100))     # Latin-1
    codepoints.update(range(0x2000, 0x2070))  # general punctuation
    codepoints.update(range(0x3000, 0x3040))  # CJK symbols and punctuation
    codepoints.update(range(0xFF00, 0xFFF0))  # full-width forms

    options = subset.Options()
    options.layout_features = ['*']
    options.name_IDs = ['*']
    options.notdef_outline = True
    font = subset.load_font(source, options)
    subsetter = subset.Subsetter(options)
    subsetter.populate(unicodes=codepoints)
    subsetter.subset(font)
    subset.save_font(font, OUT, options)
    print(f'{OUT}: {len(codepoints)} code points')


if __name__ == '__main__':
    main(sys.argv[1])
