import re

content = """
   CHAPTER I
This is a chapter.
"""

chunks = re.split(r'(?im)(^(?:CHAPTER|SCENE)\s+[A-ZIVX0-9]+\.*.*)', content)
print(len(chunks))
