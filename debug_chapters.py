import re
with open('dracula_full.txt', 'r', encoding='utf-8') as f:
    content = f.read()

raw_chunks = re.split(r'(?im)(^(?:CHAPTER|SCENE|BOOK|PART|ADVENTURE|STORY|ACT)\s+[A-ZIVX0-9]+\.*.*)', content)

raw_chapters = []
if raw_chunks[0].strip():
    raw_chapters.append(("Prologue / Intro", raw_chunks[0].strip()))
    
for i in range(1, len(raw_chunks), 2):
    scene_title = raw_chunks[i].strip()
    scene_content = raw_chunks[i+1] if i+1 < len(raw_chunks) else ""
    full_content = scene_title + "\n\n" + scene_content.strip()
    raw_chapters.append((scene_title, full_content))

for idx, (t, c) in enumerate(raw_chapters):
    print(f"Chap {idx}: title='{t[:20]}...', content_len={len(c)}")
