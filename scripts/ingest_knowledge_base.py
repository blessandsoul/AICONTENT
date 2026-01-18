
import os
import requests
from pathlib import Path

API_URL = "http://148.251.167.227:8001"
API_TOKEN = "sk_mem_9f8e7d6c5b4a3z2y1x0w"
ROOT_DIR = r"c:\Users\User\Desktop\AICONTENT"

# Mapping folders/filenames to Tags for easy filtering
CONFIG_MAP = {
    "BIBLE": ["system_rules", "constitution"],
    "entities": ["entity_profile", "dossier"],
    "COMMON_ASSETS": ["visuals", "assets"],
    "results.md": ["analytics", "performance"],
    "failures.md": ["analytics", "failure_log"],
    "performance_log.md": ["analytics", "success_log"],
    "deep.json": ["deep_content", "research"],
    "deep.md": ["deep_content", "research"],
    "SKILL.md": ["agent_skill", "instruction"]
}

def ingest_file(path_str, tags):
    path = Path(path_str)
    try:
        content = path.read_text(encoding='utf-8')
    except:
        return

    if len(content) < 50: return

    # Chunking
    CHUNK_SIZE = 4000
    chunks = [content[i:i+CHUNK_SIZE] for i in range(0, len(content), CHUNK_SIZE)]
    
    print(f"📦 Processing {path.name} ({len(chunks)} chunks)...")
    
    for i, chunk in enumerate(chunks):
        payload = {
            "content": chunk,
            # Mix specific tags + generic filename
            "tags": tags + [path.stem],
            "metadata": {
                "source_path": str(path),
                "type": "knowledge_base",
                "filename": path.name
            }
        }
        
        try:
            headers = {"Authorization": f"Bearer {API_TOKEN}"}
            requests.post(f"{API_URL}/memory", json=payload, headers=headers)
        except Exception as e:
            print(f"Error: {e}")

def main():
    print("🚀 Starting Knowledge Base Ingestion...")
    count = 0
    
    for root, dirs, files in os.walk(ROOT_DIR):
        for file in files:
            file_path = os.path.join(root, file)
            tags = []
            
            # 1. Check filename matches
            if file in CONFIG_MAP:
                tags = CONFIG_MAP[file]
            # 2. Check parent folder matches
            elif any(key in root for key in CONFIG_MAP if key not in ["results.md", "deep.json", "failures.md", "deep.md"]):
                 # Find which folder key matches
                 for key in CONFIG_MAP:
                     if key in root and "." not in key: # simple folder check
                         tags = CONFIG_MAP[key]
            
            # If we found relevant tags, ingest!
            if tags:
                # Specific overrides for BIBLE core files
                if "ABSOLUTE_RULES.md" in file:
                    tags = ["CRITICAL_RULES", "BIBLE"]
                    
                ingest_file(file_path, tags)
                count += 1

    print(f"✅ Ingested {count} knowledge files.")

if __name__ == "__main__":
    main()
