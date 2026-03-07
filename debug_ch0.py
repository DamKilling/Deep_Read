import re
with open('dracula_full.txt', 'r', encoding='utf-8') as f:
    text = f.read()
chunks = re.split(r'(?im)(^(?:CHAPTER|SCENE|BOOK|PART|ADVENTURE|STORY|ACT)\s+[A-ZIVX0-9]+\.*.*)', text)
print(f"Total chunks: {len(chunks)}")
print(f"Chunk 0 length: {len(chunks[0])}")

with open('debug_ch0.txt', 'w', encoding='utf-8') as f:
    f.write(chunks[0][:2000])

