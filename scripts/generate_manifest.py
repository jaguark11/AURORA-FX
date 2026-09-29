#!/usr/bin/env python3
import hashlib,json,pathlib
ROOT=pathlib.Path(__file__).resolve().parents[1]
protected=[]
for base in ['src','app','tests','docs']:
    protected += [p for p in (ROOT/base).rglob('*') if p.is_file()]
protected += [ROOT/'README.md',ROOT/'LICENSE',ROOT/'CITATION.cff',ROOT/'AUTHORS']
files={str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(protected)}
doc={
  'schema':'AURORA-PROV/1',
  'origin_id':'AURORA-FX-KRISTIAN-20260929-7F3C9A11',
  'original_author':'Kristian',
  'project':'AURORA-FX',
  'created_utc':'2026-09-29T17:38:00Z',
  'note':'Tamper-evident provenance manifest. For stronger proof, sign releases/commits cryptographically.',
  'files':files,
}
path=ROOT/'.well-known'/'provenance.json'; path.write_text(json.dumps(doc,indent=2,sort_keys=True)+'\n')
print(path)
