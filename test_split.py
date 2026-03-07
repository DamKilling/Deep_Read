import re

content = """Title
Author
Table of Contents
CHAPTER I .... 1
CHAPTER II ... 2
CHAPTER III .. 3

CHAPTER I
This is the first chapter content. It needs to be long enough.
""" * 10

raw_chunks = re.split(r'(?im)(^(?:CHAPTER|SCENE|BOOK|PART|ADVENTURE|STORY|ACT)\s+[A-ZIVX0-9]+\.*.*)', content)
for i, chunk in enumerate(raw_chunks[:10]):
    print(f"--- Chunk {i} ---")
    print(chunk)
