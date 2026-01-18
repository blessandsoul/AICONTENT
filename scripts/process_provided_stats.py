
import csv
import io
import sys
from scripts.log_performance import update_memory_performance

csv_data = """
"Time","Video title","Video link","Post time","Total likes","Total comments","Total shares","Total views"
"18 января","🏭 მეოთხე რევოლუცია დაიწყო ჯენსენ ჰუანგმა CES 2026-ზე...","https://www.tiktok.com/@andrewaltair/video/7593820674163100946","10 января","529","170","122","28590"
"18 января","🔞 Grok-მა ეთიკა გაიხადა ელონ მასკის "მეამბოხე" AI...","https://www.tiktok.com/@andrewaltair/video/7592618226463280400","7 января","1428","93","1087","54239"
"18 января","🚨 Grok-ის "შიშველი" ტერორი თქვენი სახე...","https://www.tiktok.com/@andrewaltair/video/7595253593532288273","14 января","84","4","8","5221"
"18 января","Google-მა და Character.AI-მ აღიარეს...","https://www.tiktok.com/@andrewaltair/video/7593398670037503233","9 января","48","22","22","2897"
"18 января","⏳ აპოკალიფსი გრაფიკშია კაცობრიობის განადგურების თარიღი...","https://www.tiktok.com/@andrewaltair/video/7592621307829685505","7 января","69","16","4","4771"
"18 января","☠️ Grok პენტაგონში: ციფრული მონსტრი...","https://www.tiktok.com/@andrewaltair/video/7595639088393227521","15 января","331","23","68","13350"
"18 января","💔 ურთიერთობა კოდთან: ადამიანური ურთიერთობების დასასრული...","https://www.tiktok.com/@andrewaltair/video/7594479314905615632","12 января","12","6","3","520"
"18 января","☠️ ციფრული კანიბალიზმი: Mercor-ი გიხდით...","https://www.tiktok.com/@andrewaltair/video/7594877571301412097","13 января","16","0","0","437"
"18 января","💊 AI "კაიფში": ციფრული ნარკოტიკების ბაზარი გაიხსნა...","https://www.tiktok.com/@andrewaltair/video/7594135262700047636","11 января","6","0","2","305"
"18 января","🤖 სასიკვდილო თამაში თქვენი მასწავლებელი მკვდარია...","https://www.tiktok.com/@andrewaltair/video/7592999195963870465","8 января","11","1","2","552"
"18 января","2-3? 👩🏫 #ფორიუ #fyp #viral #მათემატიკა ","https://www.tiktok.com/@andrewaltair/video/7495390241952386322","20 апреля","7792","1020","2267","259884"
"18 января","🍅 Claude: სიცოცხლისა და სიკვდილის ზღვარზე...","https://www.tiktok.com/@andrewaltair/video/7592301388466556161","6 января","13","0","0","518"
"18 января","თქვენი "მეორე ნახევარი" სტატისტიკური ცდომილებაა 💔🤖...","https://www.tiktok.com/@andrewaltair/video/7591905069826673937","5 января","7","1","0","265"
"""

def parse_and_log():
    reader = csv.DictReader(io.StringIO(csv_data.strip()))
    
    print("📊 Analysis of provided statistics:")
    print("-" * 50)
    
    for row in reader:
        title = row["Video title"][:50] + "..."
        views = int(row["Total views"])
        shares = int(row["Total shares"])
        
        verdict = "NEUTRAL"
        if views > 10000:
            verdict = "WIN"
        elif views < 1000:
            verdict = "FLOP"
            
        print(f"🎬 {title}")
        print(f"   👁️ {views} | 🔄 {shares} -> {verdict}")
        
        # In a real scenario, we would match the title to the Memory ID more robustly
        # Here we use the title prefix as the query
        search_query = row["Video title"][:30] # First 30 chars for search
        
        update_memory_performance(search_query, str(views), "N/A", verdict)
        print("-" * 50)

if __name__ == "__main__":
    parse_and_log()
