import re
from ingestion.text_cleaner import clean_gutenberg_text

with open('dracula_full.txt', 'r', encoding='utf-8') as f:
    content = f.read()

cleaned = clean_gutenberg_text(content)

raw_chunks = re.split(r'(?im)(^(?:CHAPTER|SCENE|BOOK|PART|ADVENTURE|STORY|ACT)\s+[A-ZIVX0-9]+\.*.*)', cleaned)

for i in range(min(5, len(raw_chunks))):
    print(f"CHUNK {i} (len={len(raw_chunks[i])}):\n{raw_chunks[i][:100]}...\n")

