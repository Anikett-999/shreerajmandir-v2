import json,sys,traceback
from pathlib import Path
p = Path('.')
try:
    from graphify.detect import detect
except Exception as e:
    print('IMPORT_ERROR', e)
    traceback.print_exc()
    sys.exit(2)
try:
    result = detect(p)
    out = p / '.graphify_detect.json'
    out.write_text(json.dumps(result), encoding='utf8')
    print('WROTE', str(out))
except Exception as e:
    print('DETECT_ERROR', e)
    traceback.print_exc()
    sys.exit(3)
