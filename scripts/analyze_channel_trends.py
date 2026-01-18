
import csv
import re

def parse_channel_trends(filename):
    print("📊 ANALYZING CHANNEL TRENDS...")
    
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()

    # Split into sections
    # Separator: TIKTOK_DATA_SEPARATOR
    parts = content.split("TIKTOK_DATA_SEPARATOR")
    
    fb_data = parts[0]
    tiktok_data = parts[1] if len(parts) > 1 else ""
    
    # ---------------- FACEBOOK ----------------
    print("\n📘 FACEBOOK DAILY TRENDS")
    print("-" * 40)
    fb_lines = fb_data.strip().split('\n')
    fb_header = fb_lines[0].replace('"','').split(',')
    # Expected: ID, Page, Comment, Date, Imp, Int, NetSubs, React, Comments, Shares, Viewers, Views
    
    # Indices might vary, let's find 'Дата' and 'Просмотры'
    try:
        date_idx = -1
        views_idx = -1
        
        # Simple heuristic since headers are quoted
        headers = [h.strip() for h in fb_header]
        for i, h in enumerate(headers):
            if 'Дата' in h: date_idx = i
            if 'Просмотры' in h and i > 5: views_idx = i # There might be multiple? Use last one usually "Views" or "Просмотры"
            
        # The last column is usually Views based on sample
        # Sample: ... Зрители,Просмотры
        # CSV reader handles quotes better
        import io
        reader = csv.reader(io.StringIO(fb_data))
        headers = next(reader)
        
        # Find index for Date and Views (last column)
        date_idx = headers.index('Дата')
        views_idx = len(headers) - 1 # Last one
        
        fb_stats = []
        for row in reader:
            if not row or len(row) < 5: continue
            date = row[date_idx]
            views = int(row[views_idx])
            fb_stats.append((date, views))
            
        # Analyze
        fb_stats.sort(key=lambda x: x[1], reverse=True)
        print("🏆 Best Days for FB Views:")
        for date, views in fb_stats[:5]:
            print(f"  📅 {date}: {views} views")
            
    except Exception as e:
        print(f"❌ Error parsing FB: {e}")

    # ---------------- TIKTOK ----------------
    print("\n🎵 TIKTOK FOLLOWER GROWTH")
    print("-" * 40)
    
    # Need to split TikTok into Hourly and Daily. They are separated by empty lines or structure change.
    # The snippet has "Date","Hour"... section and then "Date","Followers" section later.
    # Let's verify standard split usually done by "TIKTOK_DATA_SEPARATOR" but that was mine.
    # The second part contains two tables.
    
    tt_parts = tiktok_data.strip().split('"Date","Followers"')
    
    # Part 1: Hourly (Activity) -> We want to find peak hours
    hourly_data = tt_parts[0]
    # Part 2: Daily (Growth) -> We want to find biggest spikes
    
    if len(tt_parts) > 1:
        daily_csv = '"Date","Followers"' + tt_parts[1]
        reader = csv.DictReader(io.StringIO(daily_csv))
        
        growth_days = []
        for row in reader:
            date = row.get('Date')
            diff = row.get('Difference in followers from previous day', '0')
            try:
                diff_val = int(diff)
                if diff_val > 0:
                    growth_days.append((date, diff_val))
            except:
                pass
        
        growth_days.sort(key=lambda x: x[1], reverse=True)
        print("📈 Biggest TikTok Growth Spikes:")
        for date, diff in growth_days[:5]:
            print(f"  📅 {date}: +{diff} followers")

    # Hourly Analysis (Activity windows)
    # "Date","Hour","Active followers"
    reader = csv.DictReader(io.StringIO(hourly_data))
    hour_activity = {} # hour -> total activity (sum) to find peak global hour
    
    count = 0
    for row in reader:
        try:
            h = int(row['Hour'])
            act = int(row['Active followers'])
            hour_activity[h] = hour_activity.get(h, 0) + act
            count += 1
        except:
            pass
            
    if hour_activity:
        sorted_hours = sorted(hour_activity.items(), key=lambda x: x[1], reverse=True)
        print("\n⏰ Peak Audience Hours (Aggregated):")
        for h, score in sorted_hours[:5]:
            print(f"  🕒 {h}:00")

if __name__ == "__main__":
    parse_channel_trends("channel_trends.csv")
