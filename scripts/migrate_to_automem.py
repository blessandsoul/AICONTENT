import os
import re
import datetime
from pathlib import Path
from automem_client import AutoMemClient

# Путь к Master Index
MASTER_INDEX_PATH = Path(r"c:\Users\User\Desktop\AICONTENT\MASTER_INDEX.md")
# Корневая папка (чтобы резолвить относительные пути из master index)
ROOT_DIR = Path(r"c:\Users\User\Desktop\AICONTENT")

def parse_master_index(file_path):
    """
    Парсит MASTER_INDEX.md и возвращает список записей.
    Пропускает заголовки и разделители.
    """
    entries = []
    current_agent = "Unknown"
    
    with open(file_path, "r", encoding="utf-8") as f:
        lines = f.readlines()
        
    for line in lines:
        line = line.strip()
        
        # Определение текущего агента по заголовку секции
        if "EDEN AI" in line:
            current_agent = "Eden_AI"
        elif "ALPHA NEWS" in line:
            current_agent = "Alpha_News"
        elif "SECOND BRAIN" in line:
            current_agent = "Second_Brain"
            
        # Парсинг строки таблицы
        # Ожидаем: | Date | ID | Title | Folder | Platform | Status |
        if line.startswith("|") and not "---" in line and not "Date" in line and not "No entries" in line:
            parts = [p.strip() for p in line.split("|") if p.strip()]
            if len(parts) >= 6:
                entry = {
                    "date": parts[0],
                    "id": parts[1],
                    "title": parts[2],
                    "folder": parts[3].strip("`"), # Убираем backticks
                    "platform": parts[4],
                    "status": parts[5],
                    "agent": current_agent
                }
                entries.append(entry)
                
    return entries

def read_post_content(folder_path):
    """
    Ищет post.md или deep.json/md в папке.
    """
    full_path = ROOT_DIR / folder_path
    
    # Приоритет: post.md -> deep.md -> results.md
    for filename in ["post.md", "deep.md", "results.md"]:
        p = full_path / filename
        if p.exists():
            try:
                with open(p, "r", encoding="utf-8") as f:
                    return f.read()
            except Exception as e:
                print(f"Warning: Failed to read {p}: {e}")
                
    return None

def migrate():
    # Проверка наличия клиента
    api_token = os.getenv("AUTOMEM_API_TOKEN")
    if not api_token:
        print("ERROR: AUTOMEM_API_TOKEN is not set.")
        return

    client = AutoMemClient()
    
    print("Parsing MASTER_INDEX.md...")
    entries = parse_master_index(MASTER_INDEX_PATH)
    print(f"Found {len(entries)} entries.")
    
    for entry in entries:
        print(f"Processing {entry['id']}...")
        
        content = read_post_content(entry['folder'])
        if not content:
            print(f"  Skipping {entry['id']}: No content file found in {entry['folder']}")
            continue
            
        # Формируем теги
        tags = [
            "post", 
            f"agent:{entry['agent']}", 
            f"status:{entry['status']}"
        ]
        # Добавляем платформы как отдельные теги
        platforms = entry['platform'].replace("/", ",").split(",")
        for p in platforms:
            tags.append(f"platform:{p.strip()}")
            
        # Metadata
        metadata = {
            "id": entry['id'],
            "date": entry['date'],
            "title": entry['title'],
            "folder": entry['folder'],
            "source": "migration_script"
        }
        
        # Сохраняем в память
        try:
            res = client.add_memory(
                content=content,
                tags=tags,
                metadata=metadata,
                memory_type="Context", # Используем Context как общий тип для постов
                importance=0.8 # Исторические данные важны
            )
            print(f"  Saved memory: {res.get('id', 'unknown')}")
        except Exception as e:
            print(f"  Error saving {entry['id']}: {e}")

if __name__ == "__main__":
    migrate()
