
import os
import json
import time
import requests
from pathlib import Path
import hashlib

# Configuration
API_URL = "http://148.251.167.227:8001"
API_TOKEN = "sk_mem_9f8e7d6c5b4a3z2y1x0w"
ROOT_DIR = r"c:\Users\User\Desktop\AICONTENT"
STATE_FILE = r"c:\Users\User\Desktop\AICONTENT\.agent\automem\memory_state.json"

# Files to watch (Glob patterns)
WATCH_LIST = {
    "post.md": ["content", "post"],
    "description_post.md": ["content", "video_script"],
    "deep.json": ["content", "deep_dive"],
    "deep.md": ["content", "deep_dive"],
    "results.md": ["analytics", "performance"],
    "performance_log.md": ["analytics", "success_log"],
    "failures.md": ["analytics", "failure_log"],
    "ABSOLUTE_RULES.md": ["BIBLE", "CRITICAL_RULES"],
    "SKILL.md": ["agent_skill", "instruction"],
    "entity_*.md": ["entity_profile", "dossier"] # Generalized
}

# Special directory handling
DIR_TAGS = {
    "entities": ["entity_profile", "dossier"],
    "COMMON_ASSETS": ["assets", "visuals"],
    "Second_Brain": ["second_brain", "notes"]
}

def load_state():
    if os.path.exists(STATE_FILE):
        try:
            return json.loads(Path(STATE_FILE).read_text())
        except:
            return {}
    return {}

def save_state(state):
    Path(STATE_FILE).write_text(json.dumps(state, indent=2))

def get_file_hash(path):
    """Simple modification check using Update Time, not full content hash for speed."""
    return str(os.path.getmtime(path))

def ingest_file(path, tags):
    try:
        content = Path(path).read_text(encoding='utf-8')
    except:
        return False

    if len(content) < 50: return True # Skip but mark as seen

    # Determine Agent/Folder context
    path_obj = Path(path)
    folder_name = path_obj.parent.name
    agent = "unknown"
    if "Alpha_News" in str(path): agent = "alpha_news"
    elif "Eden_AI" in str(path): agent = "eden_ai"
    elif "Deep_Science" in str(path): agent = "deep_science"
    elif "Prompt_Master" in str(path): agent = "prompt_master"

    # Chunking limits
    CHUNK_SIZE = 1500
    if len(content) > CHUNK_SIZE * 10: # Limit massive files
        print(f"⚠️  Large file {path_obj.name}, taking first 15k chars.")
        content = content[:15000]

    chunks = [content[i:i+CHUNK_SIZE] for i in range(0, len(content), CHUNK_SIZE)]
    
    print(f"🔄 Syncing {path_obj.name} ({len(chunks)} chunks)...")

    success = True
    for i, chunk in enumerate(chunks):
        # Merge and sanitize tags
        raw_tags = tags + [agent, folder_name]
        final_tags = []
        for t in raw_tags:
            if t:
                # Sanitize: lowercase, no spaces
                clean_tag = str(t).lower().replace(" ", "_")
                final_tags.append(clean_tag)
        
        final_tags = list(set(final_tags))
        
        payload = {
            "content": chunk,
            "tags": final_tags,
            "metadata": {
                "source_path": str(path),
                "sync_timestamp": str(time.time()), # Convert to string
                "filename": str(path_obj.name)
            }
        }
        
        try:
            headers = {"Authorization": f"Bearer {API_TOKEN}"}
            res = requests.post(f"{API_URL}/memory", json=payload, headers=headers)
            if res.status_code not in [200, 201, 202]:
                print(f"❌ Failed to upload chunk {i}: {res.status_code}")
                success = False
        except Exception as e:
            print(f"❌ API Error: {e}")
            success = False
            
    return success

def main():
    print("🧠 Starting Smart Memory Sync...")
    state = load_state()
    updates_count = 0
    
    for root, dirs, files in os.walk(ROOT_DIR):
        for file in files:
            file_path = os.path.join(root, file)
            tags = []
            
            # 1. Match File Name
            if file in WATCH_LIST:
                tags = WATCH_LIST[file]
            # 2. Match Glob-ish (entities)
            elif "entity_" in file and file.endswith(".md"):
                 tags = ["entity_profile", "dossier"]
            # 3. Match Directory Context
            else:
                 for dir_key, dir_tags in DIR_TAGS.items():
                     if dir_key in root:
                         if file.endswith(".md"): # Only MD files in these folders
                             tags = dir_tags
                             break
            
            if not tags:
                continue
                
            # Check if modified
            current_mtime = get_file_hash(file_path)
            last_mtime = state.get(file_path)
            
            if current_mtime != last_mtime:
                # File changed or new!
                if ingest_file(file_path, tags):
                    state[file_path] = current_mtime
                    updates_count += 1
            
    save_state(state)
    if updates_count == 0:
        print("✨ Memory is up to date. No changes found.")
    else:
        print(f"✅ Synced {updates_count} files to AutoMem.")

if __name__ == "__main__":
    main()
