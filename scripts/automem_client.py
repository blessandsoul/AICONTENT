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
        self.base_url = base_url or os.getenv("AUTOMEM_API_URL", "http://localhost:8001")
        self.token = token or os.getenv("AUTOMEM_API_TOKEN")
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
            return response.json().get("results", [])
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

# Пример использования:
if __name__ == "__main__":
    # Для теста можно создать .env с AUTOMEM_API_URL и AUTOMEM_API_TOKEN
    client = AutoMemClient()
    
    if os.getenv("AUTOMEM_API_TOKEN"):
        # 1. Сохранить
        mem = client.add_memory(
            content="Alpha News published a post about AI Regulation.",
            tags=["news", "ai", "alpha_news"],
            memory_type="Action"
        )
        print("Memory saved:", mem)
        
        # 2. Найти
        if mem:
            results = client.recall("What did Alpha News publish?")
            print("Recall results:", json.dumps(results, indent=2))
    else:
        print("Set AUTOMEM_API_TOKEN to run tests.")
