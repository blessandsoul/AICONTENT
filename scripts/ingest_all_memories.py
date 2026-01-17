
import os
import requests
from pathlib import Path
import re

# Configuration
API_URL = "http://148.251.167.227:8001"
API_TOKEN = "sk_mem_9f8e7d6c5b4a3z2y1x0w"
ROOT_DIR = r"c:\Users\User\Desktop\AICONTENT"

def ingest_file(path_str, agent):
    path = Path(path_str)
    try:
        content = path.read_text(encoding='utf-8')
    except Exception as e:
        print(f"❌ Error reading {path.name}: {e}")
        return

    if len(content) < 50:
        print(f"⚠️ Skipping {path.name} (too short)")
        return

    folder_name = path.parent.name
    
    # Chunking Logic
    CHUNK_SIZE = 2000
    chunks = [content[i:i+CHUNK_SIZE] for i in range(0, len(content), CHUNK_SIZE)]
    
    print(f"📦 Processing {folder_name}: {len(chunks)} chunks...")
    
    for i, chunk in enumerate(chunks):
        payload = {
            "content": chunk,
            "tags": [agent, "history_import", folder_name, f"part_{i+1}"],
            "metadata": {
                "source_path": str(path),
                "import_date": "2026-01-18",
                "folder": folder_name,
                "chunk_index": i,
                "total_chunks": len(chunks)
            }
        }

        try:
            headers = {"Authorization": f"Bearer {API_TOKEN}"}
            # Add small delay to not ddos self
            response = requests.post(f"{API_URL}/memory", json=payload, headers=headers)
            
            # Accept 200, 201 (Created), 202 (Accepted)
            if response.status_code not in [200, 201, 202]:
                print(f"  ❌ Chunk {i+1} failed ({response.status_code}): {response.text[:100]}...")
            else:
                pass # Silent success for chunks to avoid spam
                
        except Exception as e:
            print(f"  ❌ Error: {e}")
            
    print(f"  ✅ Done.")

def main():
    print("🚀 Starting Mass Memory Ingestion...")
    print(f"Target: {API_URL}")
    
    count = 0
    # Walk through all directories
    for root, dirs, files in os.walk(ROOT_DIR):
        
        # 1. Alpha / Deep / Prompt Master (post.md)
        if "post.md" in files:
            path = os.path.join(root, "post.md")
            agent = "unknown_agent"
            if "Alpha_News" in path: agent = "alpha_news"
            elif "Deep_Science" in path: agent = "deep_science"
            elif "Prompt_Master" in path: agent = "prompt_master"
            elif "Alpha_OnGe" in path: agent = "alpha_onge"
            
            # Skip templates/examples if they are in the mix (usually they are in .agent/skills/.../examples but walked path might hit them)
            if "examples" in path or "templates" in path:
                continue
                
            ingest_file(path, agent)
            count += 1
            
        # 2. Eden AI (description_post.md)
        if "description_post.md" in files:
            path = os.path.join(root, "description_post.md")
            # Ensure it's Eden
            if "Eden_AI" in path:
                ingest_file(path, "eden_ai")
                count += 1

    print(f"\n🏁 Ingestion Complete. Processed {count} files.")

if __name__ == "__main__":
    main()
