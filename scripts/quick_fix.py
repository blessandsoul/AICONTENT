import json
import re

file_path = r'C:\Users\User\Desktop\AICONTENT\Alpha_News\output\published\20260121_ai_suicide_chamber\deep.json'

with open(file_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

def fix_text(text):
    if not isinstance(text, str):
        return text
    # Remove bold
    text = text.replace('**', '')
    
    # Replace Colon with Dash in Headlines/Titles (heuristics)
    # Pattern: Emoji (optional) + Text + : + Space
    # We want to avoid replacing http: or https:
    # We also want to target the specific occurrences in this file.
    
    # Simple strategy: replace ": " with " - " if it's not preceded by http/https
    # Using negative lookbehind (?<!https)(?<!http) is good.
    text = re.sub(r'(?<!https)(?<!http): ', ' - ', text)
    return text

# Fix meta title
if 'meta' in data and 'title' in data['meta']:
    data['meta']['title'] = fix_text(data['meta']['title'])

# Fix content
if 'content' in data:
    for item in data['content']:
        if 'content' in item:
            item['content'] = fix_text(item['content'])

# Fix SEO excerpt (just in case)
if 'seo' in data and 'excerpt' in data['seo']:
    data['seo']['excerpt'] = fix_text(data['seo']['excerpt'])

with open(file_path, 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print("SUCCESS: Fixed colons and bold text.")
