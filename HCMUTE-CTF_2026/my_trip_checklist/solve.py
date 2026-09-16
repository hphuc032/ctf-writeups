"""Decrypt the CTF workbook and recover both flag fragments from OOXML.

Dependencies: pip install msoffcrypto-tool
Usage: python solve.py [planning.xlsx] [--password PASSWORD]
No Excel instance, macro execution, network, or workbook modification is needed.
"""
import argparse
import io
import json
from pathlib import Path
import posixpath
import re
import sys
import zipfile
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT/'deps'))
import msoffcrypto

NS = {
    's': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main',
    'r': 'http://schemas.openxmlformats.org/officeDocument/2006/relationships',
    'p': 'http://schemas.openxmlformats.org/package/2006/relationships',
    'xdr': 'http://schemas.openxmlformats.org/drawingml/2006/spreadsheetDrawing',
}

def relationships(z, part):
    folder, name = posixpath.split(part)
    path = posixpath.join(folder, '_rels', name+'.rels')
    if path not in z.namelist():
        return {}
    result = {}
    for rel in ET.fromstring(z.read(path)):
        if rel.get('TargetMode') == 'External':
            continue
        target = rel.attrib['Target']
        result[rel.attrib['Id']] = (
            target.lstrip('/') if target.startswith('/')
            else posixpath.normpath(posixpath.join(folder, target))
        )
    return result

def recover(path, password):
    with path.open('rb') as src:
        office = msoffcrypto.OfficeFile(src)
        office.load_key(password=password, verify_password=True)
        decrypted = io.BytesIO()
        office.decrypt(decrypted, verify_integrity=True)
    with zipfile.ZipFile(decrypted) as z:
        bad = z.testzip()
        if bad:
            raise ValueError(f'ZIP CRC failed: {bad}')
        strings = [
            ''.join(t.text or '' for t in si.findall('.//s:t', NS))
            for si in ET.fromstring(z.read('xl/sharedStrings.xml')).findall('s:si', NS)
        ]
        book = ET.fromstring(z.read('xl/workbook.xml'))
        book_rels = relationships(z, 'xl/workbook.xml')
        found = []
        for sheet in book.findall('s:sheets/s:sheet', NS):
            sheet_part = book_rels[sheet.attrib['{'+NS['r']+'}id']]
            xml = ET.fromstring(z.read(sheet_part))
            prefixes=[]
            for c in xml.findall('.//s:sheetData/s:row/s:c', NS):
                value=c.findtext('s:v', default='', namespaces=NS)
                if c.get('t')=='s' and value:
                    value=strings[int(value)]
                elif c.get('t')=='inlineStr':
                    value=''.join(t.text or '' for t in c.findall('.//s:t', NS))
                if value.startswith('UTECTF{'):
                    prefixes.append((c.attrib['r'],value))
            sheet_rels=relationships(z,sheet_part)
            for drawing in xml.findall('s:drawing', NS):
                drawing_part=sheet_rels[drawing.attrib['{'+NS['r']+'}id']]
                drawing_xml=ET.fromstring(z.read(drawing_part))
                for obj in drawing_xml.findall('.//xdr:cNvPr', NS):
                    suffix=obj.get('descr','')
                    for cell,prefix in prefixes:
                        flag=prefix+suffix
                        if re.fullmatch(r'UTECTF\{[^{}\s]+\}',flag):
                            found.append({
                                'flag':flag, 'sheet':sheet.attrib['name'],
                                'state':sheet.get('state','visible'), 'cell':cell,
                                'prefix':prefix, 'suffix':suffix,
                                'drawing_part':drawing_part,
                                'object_id':obj.get('id'), 'object_name':obj.get('name'),
                            })
        if len(found)!=1:
            raise ValueError(f'Expected one complete flag, found {len(found)}')
        return found[0]

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('input', nargs='?', type=Path, default=ROOT/'planning.xlsx')
    parser.add_argument('--password', default='P@ssW0rd')
    args=parser.parse_args()
    evidence=recover(args.input,args.password)
    print(json.dumps(evidence,ensure_ascii=False,indent=2))
    print('\n'+evidence['flag'])
