import os
import requests
import json
from typing import List, Dict, Optional, Union

class AutoMemClient:
    def __init__(self, base_url: str = None, token: str = None):
        """
        Инициализация клиента. 
        Читает настройки из переменных окружения, если не переданы явно.
        """
        self.base_url = base_url or os.getenv("AUTOMEM_API_URL", "http://148.251.167.227:8001")
        # Hardcoded token with fallback to env variable
        self.token = token or os.getenv("AUTOMEM_API_TOKEN", "sk_mem_9f8e7d6c5b4a3z2y1x0w")
        self.headers = {
            "Authorization": f"Bearer {self.token}",
            "Content-Type": "application/json"
        }

    def add_memory(self, 
                   content: str, 
                   tags: List[str] = None, 
                   metadata: Dict = None, 
                   memory_type: str = "Context", 
                   importance: float = 0.5) -> Dict:
        """
        Сохранить новое воспоминание.
        """
        payload = {
            "content": content,
            "type": memory_type,
            "importance": importance,
            "tags": tags or [],
            "metadata": metadata or {}
        }
        
        try:
            response = requests.post(f"{self.base_url}/memory", headers=self.headers, json=payload)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            print(f"Error adding memory: {e}")
            if hasattr(e, 'response') and e.response is not None:
                print(f"Response: {e.response.text}")
            return None

    def recall(self, 
               query: str, 
               tags: List[str] = None, 
               limit: int = 5, 
               min_relevance: float = 0.0) -> List[Dict]:
        """
        Поиск воспоминаний (Recall).
        """
        params = {
            "query": query,
            "limit": limit,
            "min_relevance": min_relevance
        }
        if tags:
            params["tags"] = ",".join(tags)

        try:
            response = requests.get(f"{self.base_url}/recall", headers=self.headers, params=params)
            response.raise_for_status()
            raw_results = response.json().get("results", [])
            # Flatten: content is inside 'memory' sub-object
            return [
                {
                    "content": r.get("memory", {}).get("content", "N/A"),
                    "tags": r.get("memory", {}).get("tags", []),
                    "relevance": r.get("score", 0),
                    "id": r.get("id", "unknown")
                }
                for r in raw_results
            ]
        except requests.exceptions.RequestException as e:
            print(f"Error recalling memory: {e}")
            return []

    def create_relationship(self, 
                          source_id: str, 
                          target_id: str, 
                          rel_type: str = "RELATES_TO", 
                          strength: float = 0.5) -> Dict:
        """
        Создать связь между двумя воспоминаниями.
        """
        payload = {
            "memory1_id": source_id,
            "memory2_id": target_id,
            "type": rel_type,
            "strength": strength
        }
        
        try:
            response = requests.post(f"{self.base_url}/associate", headers=self.headers, json=payload)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            print(f"Error creating relationship: {e}")
            return None

# CLI Usage:
# python automem_client.py recall "query"
# python automem_client.py add "content"
if __name__ == "__main__":
    import sys
    client = AutoMemClient()
    
    if len(sys.argv) < 3:
        print("Usage:")
        print("  python automem_client.py recall \"query\" [--tags eden_ai]")
        print("  python automem_client.py add \"content\" [--tags eden_ai]")
        print("\nExamples:")
        print("  python automem_client.py recall \"What topics?\" --tags eden_ai")
        print("  python automem_client.py recall \"Elon Musk\" --tags eden_ai,performance")
        sys.exit(0)
    
    command = sys.argv[1].lower()
    query = sys.argv[2]
    
    # Parse optional --tags argument
    tags = None
    if len(sys.argv) > 3 and sys.argv[3] == "--tags" and len(sys.argv) > 4:
        tags = sys.argv[4].split(",")
    
    if command == "recall":
        results = client.recall(query, tags=tags)
        if results:
            print(f"📚 Found {len(results)} memories:\n")
            for i, r in enumerate(results, 1):
                content = r.get('content', 'N/A')
                relevance = r.get('relevance', 0)
                tags = r.get('tags', [])
                print(f"--- Memory #{i} [Relevance: {relevance:.2f}] ---")
                print(f"Content: {content}")
                if tags:
                    print(f"Tags: {', '.join(tags)}")
                print()
        else:
            print("❌ No matching memories found.")
    elif command == "add":
        # Use tags from CLI if provided, otherwise default to ["agent_log"]
        use_tags = tags if tags else ["agent_log"]
        mem = client.add_memory(content=query, tags=use_tags)
        if mem:
            print(f"✅ Memory saved: {mem.get('id', 'unknown')}")
        else:
            print("❌ Failed to save memory.")
    else:
        print(f"Unknown command: {command}")
