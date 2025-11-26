import re
import os
import sys
from pathlib import Path

pattern = re.compile(r'//.*?$|/\*.*?\*/', re.DOTALL | re.MULTILINE)

def remove_comments(text):
    return pattern.sub('', text)

def main():
    root = Path('.')
    for path in root.rglob('*.dart'):
        try:
            text = path.read_text(encoding='utf-8')
            new = remove_comments(text)
            if new != text:
                path.write_text(new, encoding='utf-8')
                print(f"Updated {path}")
        except Exception as e:
            print(f"Failed {path}: {e}", file=sys.stderr)

if __name__ == '__main__':
    main()