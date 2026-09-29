#!/usr/bin/env python3
from __future__ import annotations
import hashlib, json, pathlib, sys
ROOT = pathlib.Path(__file__).resolve().parents[1]
MANIFEST = ROOT / '.well-known' / 'provenance.json'

def sha256(p: pathlib.Path) -> str:
    h=hashlib.sha256()
    with p.open('rb') as f:
        for chunk in iter(lambda:f.read(1<<20), b''): h.update(chunk)
    return h.hexdigest()

def main() -> int:
    doc=json.loads(MANIFEST.read_text(encoding='utf-8'))
    failures=[]
    for rel, expected in doc['files'].items():
        p=ROOT/rel
        actual=sha256(p) if p.exists() else '<missing>'
        if actual != expected: failures.append((rel,expected,actual))
    print(f"origin_id={doc['origin_id']}")
    print(f"original_author={doc['original_author']}")
    if failures:
        print(f"TAMPER DETECTED: {len(failures)} file(s) differ")
        for rel,_,actual in failures: print(f" - {rel}: {actual}")
        return 2
    print(f"VERIFIED: {len(doc['files'])} protected files match the origin manifest")
    return 0
if __name__=='__main__': raise SystemExit(main())
