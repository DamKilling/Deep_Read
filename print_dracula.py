with open('dracula_full.txt', 'r', encoding='utf-8') as f:
    lines = f.readlines()
for i in range(20, 100):
    print(lines[i].strip())
