#!/usr/bin/env bash
# Sella la versión de la app antes de cada commit a main.
# Actualiza APP_BUILD en index.html y version.json con la misma marca,
# para que la app abierta detecte que hay una versión nueva y avise.
set -euo pipefail
cd "$(dirname "$0")/.."
BUILD="$(date -u +%Y.%m.%d-%H%M)"
python3 - "$BUILD" <<'PY'
import re,sys
b=sys.argv[1]
p='index.html'
s=open(p,encoding='utf-8',newline='').read()
s2,n=re.subn(r"var APP_BUILD='[^']*';","var APP_BUILD='%s';"%b,s,count=1)
if n!=1: sys.exit('No se encontró APP_BUILD en index.html')
open(p,'w',encoding='utf-8',newline='').write(s2)
open('version.json','w',encoding='utf-8').write('{"build":"%s"}\n'%b)
print('Versión sellada:',b)
PY
