with open('dracula_full.txt', 'r', encoding='utf-8') as f:
    text = f.read()

import re
chunks = re.split(r'(?im)(^(?:CHAPTER|SCENE|BOOK|PART|ADVENTURE|STORY|ACT)\s+[A-ZIVX0-9]+\.*.*)', text)

raw_chapters = []
for i in range(1, len(chunks), 2):
    title = chunks[i].strip()
    content = chunks[i+1]
    raw_chapters.append((title, content))

for i, (t, c) in enumerate(raw_chapters[:35]):
    print(f"Chapter {i} title: {t[:30]} | Content length: {len(c)}")

