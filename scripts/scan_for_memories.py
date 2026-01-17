
import os
from pathlib import Path

ROOT_DIR = r"c:\Users\User\Desktop\AICONTENT"

def scan_content():
    found_posts = []
    
    # Walk through all directories
    for root, dirs, files in os.walk(ROOT_DIR):
        if "post.md" in files:
            path = Path(os.path.join(root, "post.md"))
            
            # Determine Agent based on path
            agent = "Unknown"
            if "Alpha_News" in str(path): agent = "Alpha News"
            elif "Eden_AI" in str(path): agent = "Eden AI"
            elif "Deep_Science" in str(path): agent = "Deep Science"
            elif "Prompt_Master" in str(path): agent = "Prompt Master"
            elif "Alpha_OnGe" in str(path): agent = "Alpha OnGe"
            
            # Get basic info
            try:
                content = path.read_text(encoding='utf-8')
                snippet = content[:50].replace('\n', ' ')
            except:
                snippet = "Error reading file"
                
            found_posts.append({
                "agent": agent,
                "path": str(path),
                "snippet": snippet
            })

    # Summary
    print(f"🔍 SCAN COMPLETE. Found {len(found_posts)} candidates for memory.")
    
    by_agent = {}
    for p in found_posts:
        a = p['agent']
        by_agent[a] = by_agent.get(a, 0) + 1
        
    print("\n📊 Breakdown by Agent:")
    for agent, count in by_agent.items():
        print(f"- {agent}: {count} files")
        
    print("\n📜 File List:")
    for p in found_posts:
        print(f"[{p['agent']}] {p['path']}")

if __name__ == "__main__":
    scan_content()
