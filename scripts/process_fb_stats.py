
import csv
import io
import sys
import re
from scripts.log_performance import update_memory_performance

# Since the input is massive and truncated here, I will structure the parser 
# to take a filename as input, or paste the content into a temporary file.
# For this execution, I'll create a file with the provided sample data.

def parse_fb_stats(file_path):
    print(f"📂 Reading Facebook Stats from {file_path}...")
    results = []
    
    with open(file_path, 'r', encoding='utf-8') as f:
        # The CSV has a header line which is specific
        reader = csv.DictReader(f)
        
        for row in reader:
            # Extract key metrics
            try:
                # FB Headers are a bit tricky in the provided snippet:
                # "ID публикации","ID Страницы","Название Страницы",Название,"Длительность (с.)" ...
                # We need to map them correctly.
                
                title_raw = row.get('Название') or row.get('Description') or row.get('Video title') or ""
                if not title_raw: continue
                
                # Cleanup title (remove Georgian/Russian newlines for log)
                title = title_raw.replace('\n', ' ')[:50]
                
                # Metrics
                views_str = row.get('Просмотры') or row.get('Total views') or "0"
                # Handle cases like "1,200" or empty
                views = int(re.sub(r'[^\d]', '', views_str)) if views_str else 0
                
                shares_str = row.get('Репосты') or row.get('Распространение') or "0"
                shares = int(re.sub(r'[^\d]', '', shares_str)) if shares_str else 0
                
                # Verdict Logic for FB (different scale than TikTok?)
                # Let's say: > 1000 is good for FB text? Or use user's scale.
                # User's previous scale: >10k WIN. 
                # Let's inspect data:
                # 30245 views (Grok Pentagon) -> WIN
                # 753 views (Deadly Game) -> FLOP
                
                verdict = "NEUTRAL"
                if views > 10000:
                    verdict = "WIN"
                elif views < 1000:
                    verdict = "FLOP"
                
                print(f"🎬 {title}...")
                print(f"   👁️ {views} | 🔄 {shares} -> {verdict}")
                
                # Search Query
                search_query = title_raw[:30]
                
                update_memory_performance(search_query, str(views), "N/A", verdict)
                print("-" * 30)

                results.append({
                    "title": title,
                    "views": views,
                    "shares": shares,
                    "verdict": verdict
                })
                
            except Exception as e:
                print(f"❌ Error parsing row: {e}")

    # Print Summary Report
    print("\n" + "="*50)
    print("📊 FACEBOOK PERFORMANCE SUMMARY")
    print("="*50)
    
    # Sort by views descending
    results.sort(key=lambda x: x['views'], reverse=True)
    
    print("\n🏆 TOP 5 WINNERS:")
    for r in results[:5]:
        if r['verdict'] == 'WIN':
            print(f"✅ {r['views']} views | {r['title']}")
            
    print("\n💀 BOTTOM 5 FLOPS:")
    # Filter for flops and sort ascending
    flops = [r for r in results if r['verdict'] == 'FLOP']
    flops.sort(key=lambda x: x['views'])
    for r in flops[:5]:
        print(f"❌ {r['views']} views | {r['title']}")


if __name__ == "__main__":
    if len(sys.argv) > 1:
        parse_fb_stats(sys.argv[1])
    else:
        print("Please provide a CSV file path.")
