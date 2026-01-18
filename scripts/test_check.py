
from scripts.automem_client import AutoMemClient

def check():
    client = AutoMemClient()
    
    queries = [
        ("Tylenol Post", "Tylenol pregnancy autism"),
        ("Bible Rules", "ABSOLUTE_RULES forbidden"),
        ("Garden Results", "Garden Portrait results performance")
    ]
    
    for name, q in queries:
        print(f"\n🔍 Checking {name}...")
        results = client.recall(q)
        if results and len(results) > 0:
            # Get best match
            best = results[0]
            score = best.get('final_score', 0)
            text = best.get('content', '')[:100].replace('\n', ' ')
            print(f"   ✅ FOUND (Score: {score:.2f})")
            print(f"   📜 Content: \"{text}...\"")
            meta = best.get('metadata', {})
            print(f"   📂 Source: {meta.get('filename', 'Unknown')}")
        else:
            print("   ❌ NOT FOUND")

if __name__ == "__main__":
    check()
