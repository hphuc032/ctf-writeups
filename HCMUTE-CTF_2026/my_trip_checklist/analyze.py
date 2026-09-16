"""Read-only CTF workbook inspection; decrypted artifacts go to separate files."""
from pathlib import Path
import sys
import io
import zipfile
import xml.etree.ElementTree as ET
import base64
import re

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / 'deps'))
import msoffcrypto

def decrypt():
    candidates = ['VelvetSweatshop', '123456', 'password', 'planning',
        'Enjoy_this_song_https://youtu.be/CTdGQIeWQM0?si=k6r7nocSprXxHx69',
        'https://youtu.be/CTdGQIeWQM0?si=k6r7nocSprXxHx69']
    candidates += ['1234','12345','123','12345678','123456789','1234567890',
        '1234567','111111','000000','0000','1111','123123','admin','123321',
        'Password','Password1','password1','Password123','password123','Password123!',
        'qwerty','abc123','letmein','welcome','test','secret','excel','planning123',
        'Planning','trip','travel','checklist','mytrip','My trip checklist','MyTrip',
        'Enjoy_this_song_','Enjoy_this_song','Enjoy this song','CTdGQIeWQM0',
        'UTECTF','UTECTF2026','utectf','2026','2025','iloveyou','sunshine','dragon']
    if len(sys.argv) > 2:
        candidates = [sys.argv[2]]
    elif (ROOT/'planning.pot').exists():
        candidates = [line.split(':',1)[1] for line in (ROOT/'planning.pot').read_text().splitlines()] + candidates
    for password in candidates:
        with (ROOT / 'planning.xlsx').open('rb') as src:
            office = msoffcrypto.OfficeFile(src)
            try:
                office.load_key(password=password, verify_password=True)
            except (msoffcrypto.exceptions.InvalidKeyError, msoffcrypto.exceptions.DecryptionError):
                print('Incorrect:', repr(password), flush=True)
                continue
            out = io.BytesIO()
            office.decrypt(out, verify_integrity=True)
            (ROOT / 'planning.decrypted.xlsx').write_bytes(out.getvalue())
            print('PASSWORD:', repr(password), flush=True)
            return
    raise RuntimeError('No candidate worked')

def inspect():
    with zipfile.ZipFile(ROOT/'planning.decrypted.xlsx') as z:
        ns={'s':'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
        for item in z.infolist():
            print(item.filename, item.file_size)
        strings=[]
        if 'xl/sharedStrings.xml' in z.namelist():
            root=ET.fromstring(z.read('xl/sharedStrings.xml'))
            strings=[''.join(n.itertext()) for n in root.findall('s:si',ns)]
        for item in z.infolist():
            if item.filename.startswith('xl/worksheets/sheet') and item.filename.endswith('.xml'):
                root=ET.fromstring(z.read(item))
                print('\nSHEET',item.filename)
                for row in root.findall('s:sheetData/s:row',ns):
                    cells=[]
                    for c in row.findall('s:c',ns):
                        val=c.findtext('s:v',default='',namespaces=ns)
                        if c.get('t')=='s' and val:
                            val=strings[int(val)]
                        elif c.get('t')=='inlineStr':
                            val=''.join(c.find('s:is',ns).itertext())
                        formula=c.findtext('s:f',default='',namespaces=ns)
                        if val or formula:
                            cells.append((c.get('r'),val,formula))
                    if cells:
                        print('ROW',row.attrib,cells)
            elif item.filename.endswith(('.xml','.rels')) and not any(x in item.filename for x in ['theme','styles','sharedStrings']):
                data=z.read(item)
                print('\nPART',item.filename)
                print(data.decode(errors='replace')[:25000])
            if item.filename.endswith(('.xml','.rels')):
                for match in re.findall(rb'UTECTF\{[^}]{1,300}\}',z.read(item)):
                    print('FLAG CANDIDATE',item.filename,match.decode(errors='replace'))
            if item.filename.startswith(('xl/media/','xl/embeddings/')):
                target=ROOT/'extracted'/item.filename
                target.parent.mkdir(parents=True,exist_ok=True)
                target.write_bytes(z.read(item))

def office_hash():
    import olefile
    with olefile.OleFileIO(ROOT/'planning.xlsx') as ole:
        xml=ET.fromstring(ole.openstream('EncryptionInfo').read()[8:])
    node=xml.find('.//{http://schemas.microsoft.com/office/2006/keyEncryptor/password}encryptedKey')
    p=node.attrib
    value='$office$*2013*{spinCount}*{keyBits}*{saltSize}*'.format(**p)
    value+='*'.join(base64.b64decode(p[key]).hex() for key in ['saltValue','encryptedVerifierHashInput'])
    value+='*'+base64.b64decode(p['encryptedVerifierHashValue'])[:32].hex()
    (ROOT/'office.hash').write_text(value+'\n',encoding='ascii')
    print(value)

if __name__ == '__main__':
    {'decrypt':decrypt,'inspect':inspect,'hash':office_hash}[sys.argv[1]]()
