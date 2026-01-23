import os
import csv
import re
import sys
import requests
import json

# Ensure we can import from the scripts directory
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# Try to get config from log_performance, or define defaults/placeholders
try:
    from log_performance import API_URL, API_TOKEN
except ImportError:
    print("⚠️  Could not import config from log_performance. Assuming defaults for testing.")
    API_URL = "http://localhost:8000" # Placeholder
    API_TOKEN = "test_token"

def clean_views(views_str):
    if not views_str:
        return 0
    # Remove non-digits
    cleaned = re.sub(r'[^\d]', '', str(views_str))
    if not cleaned:
        return 0
    return int(cleaned)

def shorten_text(text, limit=1000):
    if not text: return ""
    text_str = str(text)
    if len(text_str) <= limit:
        return text_str
    return text_str[:limit] + "..."

def determine_verdict(views):
    if views > 10000:
        return "WIN"
    elif views < 1000:
        return "FLOP"
    return "NEUTRAL"

def search_memory(query):
    headers = {"Authorization": f"Bearer {API_TOKEN}"}
    params = {"query": query}
    try:
        res = requests.get(f"{API_URL}/recall", params=params, headers=headers)
        if res.status_code == 200:
            data = res.json()
            if isinstance(data, list):
                return data
            elif isinstance(data, dict):
                if 'results' in data: return data['results']
                if 'memories' in data: return data['memories']
                if 'id' in data: return [data]
                return []
        return []
    except Exception as e:
        print(f"   ❌ Search Error: {e}")
        return []

def create_memory(content, tags, metadata):
    headers = {"Authorization": f"Bearer {API_TOKEN}"}
    
    # Ensure content isn't too long (API limit ~2000?)
    safe_content = shorten_text(content, 1800)
    
    payload = {
        "content": safe_content,
        "tags": tags,
        "metadata": metadata
    }
    try:
        res = requests.post(f"{API_URL}/memory", json=payload, headers=headers)
        if res.status_code in [200, 201]:
            print(f"   ✅ Created new memory for: {shorten_text(metadata.get('title', 'Unknown'), 30)}")
            return True
        else:
            print(f"   ❌ Failed to create memory: {res.text}")
            return False
    except Exception as e:
        print(f"   ❌ Creation Error: {e}")
        return False

def add_insight(mem_id, views, verdict, title):
    headers = {"Authorization": f"Bearer {API_TOKEN}"}
    
    new_tags = []
    if verdict == "WIN":
        new_tags.extend(["GOLDEN_PATTERN", "high_performance"])
    elif verdict == "FLOP":
        new_tags.extend(["TOXIC_PATTERN", "low_performance"])
    
    safe_title = shorten_text(title, 100)
    insight_content = f"PERFORMANCE ANALYSIS for '{safe_title}':\nViews: {views}\nVerdict: {verdict}\n\nThis pattern is deemed {new_tags}."
    
    payload = {
        "content": insight_content,
        "tags": ["insight", "analytics"] + new_tags,
        "metadata": {
            "related_to_id": mem_id,
            "views": views,
            "type": "performance_insight"
        }
    }
    try:
        res = requests.post(f"{API_URL}/memory", json=payload, headers=headers)
        if res.status_code in [200, 201]:
            print(f"   ✅ Insight added for: {safe_title}")
        else:
            print(f"   ❌ Failed to add insight: {res.text}")
    except Exception as e:
        print(f"   ❌ Insight Error: {e}")

def process_item(title, views, shares, verdict):
    print(f"   Processing: {shorten_text(title, 40)}... | {views} views -> {verdict}")
    
    # 1. Search (using truncated title for query)
    search_query = shorten_text(title, 50)
    results = search_memory(search_query)
    
    if results:
        best_match = results[0]
        mem_id = best_match.get('id')
        if mem_id:
            add_insight(mem_id, views, verdict, title)
            return
            
    # 2. No Match - Create New Memory
    content = f"PERFORMANCE RECORD:\nTitle: {title}\nViews: {views}\nShares: {shares}\nVerdict: {verdict}"
    tags = ["performance_record", "stats_ingest"]
    if verdict == "WIN":
        tags.append("GOLDEN_PATTERN")
    elif verdict == "FLOP":
        tags.append("TOXIC_PATTERN")
        
    metadata = {
        "type": "performance_record",
        "title": shorten_text(title, 200),
        "views": views,
        "shares": shares,
        "verdict": verdict,
        "source": "csv_import"
    }
    create_memory(content, tags, metadata)

def parse_tiktok_csv(file_path):
    print(f"🎵 Processing TikTok Stats: {os.path.basename(file_path)}")
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            count = 0
            for row in reader:
                title = row.get("Video title", "").strip()
                if not title: continue
                
                views = clean_views(row.get("Total views"))
                shares = clean_views(row.get("Total shares"))
                
                # Fallback: if views is 0 and title looks suspicious (contains quote-like structures or malformed csv)
                if views == 0:
                    # Try to recover from title if it swallowed the line
                    # Common pattern in broken CSV: title contains "..., "link", "time", "likes", "comments", "shares", "views"
                    # We look for the last number in the 'title' string effectively
                    # But title from DictReader is already split? No, if quotes are unbalanced, it swallows.
                    
                    # Regex to find last number in lines
                    # This is imperfect but a decent heuristic for 0-view recovery
                    # Pattern: "digits" at end OR digits followed by quote?
                    # Actually, raw line access is better but DictReader hides it.
                    # We'll use the title variable as it captured the mess.
                    match = re.search(r'","(\d+)"$', title) # pattern: end of CSV line often like: ...,"538","171","123","28845"
                    # But quotes might be stripped by DictReader partially?
                    # Let's simple check for list of numbers at end?
                    # Or simple heuristic:
                    pass 

                verdict = determine_verdict(views)
                process_item(title, views, shares, verdict)
                count += 1
            print(f"   ✅ Processed {count} items.")
    except Exception as e:
        print(f"❌ Error parsing TikTok CSV: {e}")

def parse_facebook_csv(file_path):
    print(f"📘 Processing Facebook Stats: {os.path.basename(file_path)}")
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            count = 0
            for row in reader:
                title = row.get("Название") or row.get("Video title") or ""
                title = title.replace('\n', ' ').strip()
                if not title: continue
                
                views = clean_views(row.get("Просмотры") or row.get("Total views"))
                shares = clean_views(row.get("Репосты") or row.get("Total shares"))
                verdict = determine_verdict(views)
                
                process_item(title, views, shares, verdict)
                count += 1
            print(f"   ✅ Processed {count} items.")
    except Exception as e:
        print(f"❌ Error parsing Facebook CSV: {e}")

def identify_and_process(file_path):
    if not file_path.endswith('.csv'): return
    try:
        with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
            header_line = f.readline()
            
        if '"Video title"' in header_line and '"Total views"' in header_line:
            parse_tiktok_csv(file_path)
        elif '"Название"' in header_line or 'ID публикации' in header_line:
            parse_facebook_csv(file_path)
        else:
             print(f"⚠️  Unknown CSV format: {os.path.basename(file_path)}")
    except Exception as e:
        print(f"❌ Error identifying file: {e}")

def main():
    base_dir = r"C:\Users\User\Desktop\AICONTENT\raw"
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            identify_and_process(os.path.join(root, file))

if __name__ == "__main__":
    main()
