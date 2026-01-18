
import requests
import sys
import json

API_URL = "http://148.251.167.227:8001"
API_TOKEN = "sk_mem_9f8e7d6c5b4a3z2y1x0w"

def update_memory_performance(query, views, retention, verdict):
    headers = {"Authorization": f"Bearer {API_TOKEN}"}
    
    # 1. Search for the memory
    print(f"🔍 Searching for: {query}")
    params = {"query": query}
    search_res = requests.get(f"{API_URL}/recall", params=params, headers=headers)
    
    if search_res.status_code != 200 or not search_res.json():
        print("❌ Memory not found.")
        return

    # Get best match
    results = search_res.json()
    if not isinstance(results, list) or not results:
        print(f"❌ No matching memory found (Response: {str(results)[:50]}...)")
        return
        
    best_match = results[0]
    mem_id = best_match['id']
    current_tags = best_match.get('tags', [])
    
    print(f"✅ Found ID: {mem_id}")
    
    # 2. Determine Tags
    new_tags = []
    if verdict.lower() == "success":
        new_tags.append("GOLDEN_PATTERN")
        new_tags.append("high_performance")
    elif verdict.lower() == "fail":
        new_tags.append("TOXIC_PATTERN")
        new_tags.append("low_performance")
        
    # Merge unique
    updated_tags = list(set(current_tags + new_tags))
    
    # 3. Update Memory (We actully need an Update endpoint or re-add)
    # AutoMem API v1 might not support PATCH yet, so we append a 'Performance Note' as a NEW memory linked to this topic.
    # This is safer to preserve the original.
    
    insight_content = f"PERFORMANCE ANALYSIS for '{query}':\nViews: {views}\nRetention: {retention}\nVerdict: {verdict}\n\nThis pattern is deemed {new_tags}."
    
    payload = {
        "content": insight_content,
        "tags": ["insight", "analytics"] + new_tags,
        "metadata": {
            "related_to_id": mem_id,
            "views": views,
            "retention": retention,
            "type": "performance_insight"
        }
    }
    
    res = requests.post(f"{API_URL}/memory", json=payload, headers=headers)
    
    if res.status_code in [200, 201]:
        print("✅ Insight saved to memory!")
    else:
        print(f"❌ Error saving insight: {res.text}")

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python log_performance.py 'query/topic' 'views' 'verdict(success/fail)'")
    else:
        q = sys.argv[1]
        v = sys.argv[2]
        verd = sys.argv[3]
        update_memory_performance(q, v, "N/A", verd)
