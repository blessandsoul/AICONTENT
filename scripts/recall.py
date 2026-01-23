
import sys
import json
from automem_client import AutoMemClient

def main():
    if len(sys.argv) < 2:
        print("Usage: python recall.py \"query\" [tags]")
        sys.exit(1)

    query = sys.argv[1]
    tags = None
    if len(sys.argv) > 2:
        tags = sys.argv[2].split(",")

    client = AutoMemClient()
    results = client.recall(query, tags=tags, limit=5, min_relevance=0.4)

    if not results:
        print(f"NO_MEMORY_FOUND for: {query}")
        return

    print(f"Found {len(results)} relevant memories for '{query}':\n")
    
    for i, mem in enumerate(results, 1):
        print(f"--- MEMORY {i} (Relevance: {mem.get('relevance', 0):.2f}) ---")
        print(f"CONTENT: {mem.get('content')}")
        if mem.get('tags'):
            print(f"TAGS: {', '.join(mem.get('tags'))}")
        print("-" * 40 + "\n")

if __name__ == "__main__":
    main()
