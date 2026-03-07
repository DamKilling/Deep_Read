import re
with open('dracula_full.txt', 'r', encoding='utf-8') as f:
    text = f.read()
chunks = re.split(r'(?im)(^(?:CHAPTER|SCENE|BOOK|PART|ADVENTURE|STORY|ACT)\s+[A-ZIVX0-9]+\.*.*)', text)

with open('debug_chunks.txt', 'w', encoding='utf-8') as f:
    f.write(f'CHUNK 53 (Title):\n{chunks[53]}\n\n')
    f.write(f'CHUNK 54 (Content):\n{chunks[54]}\n\n')
