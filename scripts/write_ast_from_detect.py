import json,re
from pathlib import Path
p=Path('..') if Path('.').name=='scripts' else Path('.')
D=json.loads((p/'.graphify_detect.json').read_text())
nodes=[]
for ftype, lst in D['files'].items():
    for f in lst:
        nid=re.sub(r'[^0-9A-Za-z_-]','_',f)
        label=Path(f).name
        nodes.append({
            'id': nid,
            'label': label,
            'file_type': ftype,
            'source_file': f,
            'source_location': None,
            'source_url': None,
            'captured_at': None,
            'author': None,
            'contributor': None
        })
out={'nodes':nodes,'edges':[], 'input_tokens':0,'output_tokens':0}
(p/'.graphify_ast.json').write_text(json.dumps(out,indent=2),encoding='utf8')
print('WROTE AST', len(nodes))
