import re
import sys
with open('dracula_full.txt', 'r', encoding='utf-8') as f:
    content = f.read()
raw_chunks = re.split(r'(?im)(^(?:CHAPTER|SCENE|BOOK|PART|ADVENTURE|STORY|ACT)\s+[A-ZIVX0-9]+\.*.*)', content)
print(len(raw_chunks))
