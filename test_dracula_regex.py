import re

toc = """Contents

CHAPTER I. Jonathan Harker's Journal
CHAPTER II. Jonathan Harker's Journal
CHAPTER III. Jonathan Harker's Journal
"""

chunks = re.split(r'(?im)(^(?:CHAPTER|SCENE|BOOK|PART|ADVENTURE|STORY|ACT)\s+[A-ZIVX0-9]+\.*.*)', toc)
print(f"Chunks len: {len(chunks)}")
for i, c in enumerate(chunks):
    print(f"[{i}]: {repr(c)}")
