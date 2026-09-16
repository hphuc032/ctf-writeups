"""Reconstruct the flag from visually verified single-frame video labels.

Run: python solve.py
To reproduce frame extraction, install numpy, pillow, imageio-ffmpeg and run
python analyze.py labels (public/video_001.mp4 ... video_040.mp4 required).
The labels below are transcribed from labels.png, not OCR guesses.
"""
import base64
import re

LABELS = '''
0U:V 1U:V 2U:R 3U:F 4U:Q 5-:1 6U:R 7U:G 8L:E 9L:Z
10U:B 11L:S 12U:R 13U:F 14-:9 15L:I 16U:V 17U:X 18U:R 19L:F
20U:Z 21L:Z 22U:B 23L:S 24U:R 25U:F 26-:9 27U:N 28L:B 29-:2
30-:9 31L:V 32L:B 33-:2 34-:9 35L:V 36L:B 37-:2 38-:9 39L:V
40L:B 41-:2 42-:9 43L:V 44L:B 45-:2 46-:9 47L:V 48L:B 49-:2
50-:9 51L:V 52L:B 53-:2 54-:9 55L:V 56L:B 57-:3 58-:0 59-:=
'''

def solve():
    chars = {}
    for label in LABELS.split():
        match = re.fullmatch(r'(\d+)([UL-]):(.)', label)
        if not match:
            raise ValueError(f'Invalid label: {label}')
        index, mode, char = match.groups()
        index = int(index)
        if index in chars:
            raise ValueError(f'Duplicate index: {index}')
        chars[index] = char.upper() if mode == 'U' else char.lower() if mode == 'L' else char
    if sorted(chars) != list(range(60)):
        raise ValueError('Expected all 60 indices, 0 through 59')
    encoded = ''.join(chars[index] for index in sorted(chars))
    flag = base64.b64decode(encoded, validate=True).decode('ascii')
    if not re.fullmatch(r'UTECTF\{[^{}]+\}', flag):
        raise ValueError(f'Invalid flag: {flag!r}')
    print('Base64:', encoded)
    print('Flag:', flag)
    print('Number of lowercase o characters:', flag.count('o'))
    return flag

if __name__ == '__main__':
    solve()
