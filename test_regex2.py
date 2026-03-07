import re

content = """Contents

CHAPTER I. Jonathan Harker's Journal
CHAPTER II. Jonathan Harker's Journal
CHAPTER III. Jonathan Harker's Journal
CHAPTER IV. Jonathan Harker's Journal

CHAPTER I
The actual chapter..."""

raw_chunks = re.split(r'(?im)(^(?:CHAPTER|SCENE|BOOK|PART|ADVENTURE|STORY|ACT)\s+[A-ZIVX0-9]+\.*.*)', content)

for i, c in enumerate(raw_chunks):
    print(f"[{i}]: {repr(c)}")
