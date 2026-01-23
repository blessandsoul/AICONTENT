"""
Sync local Markdown files to AutoMem API.
Syncs context/, memory/, and content files for semantic search.

Usage:
    python sync_to_automem.py --full     # Full sync of all files
    python sync_to_automem.py --context  # Sync only context/ files
    python sync_to_automem.py --memory   # Sync only memory/ files
    python sync_to_automem.py --content  # Sync Eden/Alpha content
    python sync_to_automem.py --watch    # Watch mode (future)
"""

import os
import sys
import hashlib
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Optional
from automem_client import AutoMemClient

# Base paths
AICONTENT_ROOT = Path(__file__).parent.parent
SECOND_BRAIN = AICONTENT_ROOT / "Second_Brain" / ".agent" / "skills" / "second_brain"
EDEN_AI = AICONTENT_ROOT / "Eden_AI"
ALPHA_NEWS = AICONTENT_ROOT / "Alpha_News"
DEEP_SCIENCE = AICONTENT_ROOT / "Deep_Science"

# Sync configurations
SYNC_CONFIGS = {
    "context": {
        "path": SECOND_BRAIN / "context",
        "tags": ["second_brain", "context"],
        "importance": 0.9,
        "memory_type": "Context"
    },
    "memory": {
        "path": SECOND_BRAIN / "memory",
        "tags": ["second_brain", "memory"],
        "importance": 0.8,
        "memory_type": "Memory"
    },
    "protocols": {
        "path": SECOND_BRAIN / "protocols",
        "tags": ["second_brain", "protocol"],
        "importance": 0.7,
        "memory_type": "Protocol"
    },
    "eden_content": {
        "path": EDEN_AI / "output" / "content",
        "tags": ["eden_ai", "content"],
        "importance": 0.6,
        "memory_type": "Content"
    },
    "eden_analytics": {
        "path": EDEN_AI / "analytics",
        "tags": ["eden_ai", "analytics", "performance"],
        "importance": 0.85,
        "memory_type": "Analytics"
    },
    "alpha_content": {
        "path": ALPHA_NEWS / "output",
        "tags": ["alpha_news", "content"],
        "importance": 0.6,
        "memory_type": "Content"
    },
    "deep_content": {
        "path": DEEP_SCIENCE / "output" / "content",
        "tags": ["deep_science", "content"],
        "importance": 0.6,
        "memory_type": "Content"
    }
}


def get_file_hash(content: str) -> str:
    """Generate MD5 hash of content for deduplication."""
    return hashlib.md5(content.encode()).hexdigest()[:12]


def read_markdown_file(file_path: Path) -> Optional[str]:
    """Read and return markdown file content."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return f.read()
    except Exception as e:
        print(f"  ⚠️ Error reading {file_path.name}: {e}")
        return None


def chunk_text(text: str, chunk_size: int = 1500, overlap: int = 200) -> List[str]:
    """Split text into chunks with overlap."""
    if len(text) <= chunk_size:
        return [text]
    
    chunks = []
    start = 0
    while start < len(text):
        end = start + chunk_size
        
        # If not at the end, try to find a newline to break on
        if end < len(text):
            # Look for last newline in the last 10% of the chunk
            search_start = max(start, end - int(chunk_size * 0.1))
            last_newline = text.rfind('\n', search_start, end)
            if last_newline != -1:
                end = last_newline + 1
        
        chunks.append(text[start:end])
        start = end - overlap
        
    return chunks


def sync_file(client: AutoMemClient, file_path: Path, base_tags: List[str], 
              importance: float, memory_type: str) -> bool:
    """Sync a single file to AutoMem, chunking if necessary."""
    content = read_markdown_file(file_path)
    if not content or len(content.strip()) < 50:
        return False
    
    # Build tags
    file_tags = base_tags.copy()
    file_tags.append(file_path.stem)
    
    # Add date tag if content folder
    if "content" in str(file_path):
        parts = file_path.parent.name.split("_")
        if len(parts) >= 2 and parts[0].isdigit():
            file_tags.append(f"date_{parts[0]}")
            file_tags.append("_".join(parts[1:]))

    # Chunk content
    chunks = chunk_text(content)
    success = True
    
    for i, chunk in enumerate(chunks):
        chunk_metadata = {
            "source_file": str(file_path),
            "synced_at": datetime.now().isoformat(),
            "file_hash": get_file_hash(content), # Hash of full content
            "char_count": len(chunk),
            "chunk_index": i,
            "total_chunks": len(chunks)
        }
        
        # Sync to AutoMem
        result = client.add_memory(
            content=chunk,
            tags=file_tags,
            metadata=chunk_metadata,
            memory_type=memory_type,
            importance=importance
        )
        
        if not result:
            print(f"    ⚠️ Failed to sync chunk {i+1}/{len(chunks)} of {file_path.name}")
            success = False
    
    return success


def sync_directory(client: AutoMemClient, config_name: str, config: Dict) -> Dict:
    """Sync all markdown files in a directory."""
    path = config["path"]
    stats = {"synced": 0, "skipped": 0, "errors": 0}
    
    if not path.exists():
        print(f"  ⚠️ Path not found: {path}")
        return stats
    
    # Find all markdown files
    md_files = list(path.rglob("*.md"))
    
    if not md_files:
        print(f"  ℹ️ No .md files found in {path}")
        return stats
    
    print(f"  📁 Found {len(md_files)} files in {config_name}")
    
    for file_path in md_files:
        result = sync_file(
            client=client,
            file_path=file_path,
            base_tags=config["tags"],
            importance=config["importance"],
            memory_type=config["memory_type"]
        )
        
        if result:
            print(f"    ✅ {file_path.name}")
            stats["synced"] += 1
        else:
            stats["skipped"] += 1
    
    return stats


def full_sync(client: AutoMemClient):
    """Perform full sync of all configured directories."""
    print("\n🚀 Starting FULL SYNC to AutoMem...")
    print("=" * 50)
    
    total_stats = {"synced": 0, "skipped": 0, "errors": 0}
    
    for config_name, config in SYNC_CONFIGS.items():
        print(f"\n📂 Syncing: {config_name}")
        stats = sync_directory(client, config_name, config)
        
        for key in total_stats:
            total_stats[key] += stats[key]
    
    print("\n" + "=" * 50)
    print(f"✅ SYNC COMPLETE")
    print(f"   Synced:  {total_stats['synced']} files")
    print(f"   Skipped: {total_stats['skipped']} files")
    print(f"   Errors:  {total_stats['errors']} files")


def sync_category(client: AutoMemClient, category: str):
    """Sync a specific category."""
    if category not in SYNC_CONFIGS:
        print(f"❌ Unknown category: {category}")
        print(f"   Available: {', '.join(SYNC_CONFIGS.keys())}")
        return
    
    print(f"\n🚀 Syncing category: {category}")
    print("=" * 50)
    
    stats = sync_directory(client, category, SYNC_CONFIGS[category])
    
    print("\n" + "=" * 50)
    print(f"✅ Synced: {stats['synced']} | Skipped: {stats['skipped']}")


def main():
    client = AutoMemClient()
    
    if len(sys.argv) < 2:
        print(__doc__)
        return
    
    arg = sys.argv[1].lower().replace("--", "")
    
    if arg == "full":
        full_sync(client)
    elif arg == "context":
        sync_category(client, "context")
    elif arg == "memory":
        sync_category(client, "memory")
    elif arg == "protocols":
        sync_category(client, "protocols")
    elif arg == "content":
        sync_category(client, "eden_content")
        sync_category(client, "alpha_content")
        sync_category(client, "deep_content")
    elif arg == "analytics":
        sync_category(client, "eden_analytics")
    elif arg == "watch":
        print("⏳ Watch mode coming soon...")
    else:
        print(f"❌ Unknown argument: {arg}")
        print(__doc__)


if __name__ == "__main__":
    main()
