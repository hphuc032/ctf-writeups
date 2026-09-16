"""Static MP4 inspection and decoded-frame comparison for Bo ba lan."""
from pathlib import Path
import sys
import subprocess
import struct
import hashlib
import json

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / 'deps'))
import numpy as np
from PIL import Image, ImageDraw
import imageio_ffmpeg

FFMPEG = imageio_ffmpeg.get_ffmpeg_exe()
FILES = sorted((ROOT / 'public').glob('*.mp4'))

def run(*args):
    return subprocess.run([FFMPEG, '-nostdin', '-hide_banner', *map(str, args)], capture_output=True, check=False)

def atoms(data, start=0, end=None, prefix=''):
    end = len(data) if end is None else end
    while start + 8 <= end:
        size, typ = struct.unpack_from('>I4s', data, start)
        header = 8
        if size == 1:
            size = struct.unpack_from('>Q', data, start + 8)[0]
            header = 16
        elif size == 0:
            size = end - start
        if size < header or start + size > end:
            print('UNPARSED', start, end-start)
            break
        name = typ.decode('latin1')
        payload = data[start+header:start+size]
        print(prefix + name, start, size, hashlib.sha256(payload).hexdigest()[:12])
        if typ in [b'moov', b'trak', b'mdia', b'minf', b'stbl', b'udta']:
            atoms(data, start+header, start+size, prefix+'  ')
        start += size

def inspect():
    for path in FILES[:2]:
        print('\nFILE', path.name)
        atoms(path.read_bytes())
        print(run('-i', path).stderr.decode(errors='replace'))

def sheets():
    sheet = Image.new('RGB', (5*240, 8*265), 'white')
    draw = ImageDraw.Draw(sheet)
    for i, path in enumerate(FILES):
        raw = run('-i', path, '-frames:v', 1, '-vf', 'scale=240:240', '-f', 'rawvideo', '-pix_fmt', 'rgb24', '-').stdout
        frame = Image.frombytes('RGB', (240,240), raw)
        x,y=(i%5)*240,(i//5)*265
        sheet.paste(frame,(x,y))
        draw.text((x+5,y+242),path.name,fill='black')
    sheet.save(ROOT/'contact.png')
    print(ROOT/'contact.png')

def compare():
    for path in FILES[:3]:
        audio = run('-i', path, '-map', '0:a', '-c', 'copy', '-f', 'adts', '-').stdout
        print(path.name, 'audio', hashlib.sha256(audio).hexdigest(), flush=True)
    raws=[]
    for path in FILES[:2]:
        raw=run('-i', path, '-an', '-pix_fmt', 'gray', '-f', 'rawvideo', '-').stdout
        raws.append(np.frombuffer(raw,dtype=np.uint8).reshape(-1,344,512))
    a,b=raws
    dif=np.abs(a.astype(np.int16)-b.astype(np.int16))
    scores=dif.mean(axis=(1,2))
    top=np.argsort(scores)[-20:][::-1]
    print('frames',len(a),'difference max',float(scores.max()), 'top', [(int(i),round(float(scores[i]),4)) for i in top])
    print('nonzero frames',np.flatnonzero(scores).tolist()[:100])
    sheet=Image.new('RGB',(512*3,344*6))
    draw=ImageDraw.Draw(sheet)
    for row,i in enumerate(top[:6]):
        for col,arr in enumerate([a[i],b[i],np.minimum(dif[i]*8,255).astype(np.uint8)]):
            sheet.paste(Image.fromarray(arr).convert('RGB'),(col*512,row*344))
        draw.text((5,row*344+5),str(i),fill='red')
    sheet.save(ROOT/'differences.png')

def labels():
    def frames(path):
        result=run('-i',path,'-an','-vf','crop=160:44:352:300','-pix_fmt','gray','-f','rawvideo','-')
        if result.returncode:
            raise RuntimeError(result.stderr.decode(errors='replace'))
        return np.frombuffer(result.stdout,dtype=np.uint8).reshape(-1,44,160)
    baseline=np.median(np.stack([frames(p) for p in FILES[:3]]),axis=0).astype(np.int16)
    sheet=Image.new('RGB',(800,40*64),'white')
    draw=ImageDraw.Draw(sheet)
    records=[]
    for row,path in enumerate(FILES):
        arr=frames(path)
        scores=np.abs(arr.astype(np.int16)-baseline).mean(axis=(1,2))
        top=np.argsort(scores)[-2:][::-1]
        rec={'file':path.name,'frames':[int(i) for i in top],'scores':[float(scores[i]) for i in top]}
        records.append(rec)
        print(rec,flush=True)
        draw.text((5,row*64+5),path.stem,fill='black')
        for col,i in enumerate(top):
            crop=Image.fromarray(arr[i]).convert('RGB').resize((240,66))
            sheet.paste(crop,(150+col*320,row*64))
            draw.text((150+col*320,row*64),str(i),fill='red')
    sheet.save(ROOT/'labels.png')
    (ROOT/'label_frames.json').write_text(json.dumps(records,indent=2))

if __name__ == '__main__':
    {'inspect':inspect, 'sheets':sheets, 'compare':compare, 'labels':labels}[sys.argv[1]]()
