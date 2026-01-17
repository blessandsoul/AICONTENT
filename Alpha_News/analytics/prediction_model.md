# 🔮 Alpha News Virality Prediction Model

**Purpose:** Predict success probability of news stories.
**Core Insight:** Users prefer "Secret Tools" and "Forbidden Knowledge" over standard tech news.

---

## ⚖️ Scoring Matrix (Total: 100 Points)

### 1. 🛠️ Utility / "Secret Weapon" Value (Weight: 40%)
*Does this give the user a 'superpower' or unfair advantage?*

| Level | Score | Description | Example |
|-------|-------|-------------|---------|
| **FORBIDDEN** | **40** | "Secret prompted," "Hacks," "What they hide". | "7 Forbidden Prompts", "Jailbreak". |
| **SYSTEM** | **30** | A clear "How-to" guide or blueprint. | "Billionaire Routine", "Learning Plan". |
| **TOOL** | **15** | Just a new tool announcement. | "New feature in ChatGPT released." |
| **NEWS** | **5** | Just information/reporting. | "OpenAI revenue report." |

### 2. ☠️ Personal Impact (Weight: 25%)
*Does this threaten their job/privacy or promise wealth?*

| Level | Score | Description | Example |
|-------|-------|-------------|---------|
| **WEALTH/THREAT** | **25** | "Make $1k/day" or "You will lose job". | "Your future is sold for $0". |
| **PRIVACY** | **15** | "They are watching you". | "Siri is listening." |
| **ABSTRACT** | **5** | Corporate impact only. | "Microsoft buys Activision." |

### 3. 🔥 Hook Strength / "Clickbait-ability" (Weight: 20%)
*Does the headline sound like a movie or war?*

| Level | Score | Description | Example |
|-------|-------|-------------|---------|
| **WAR/PANIC** | **20** | Uses "Panic", "Dead", "War", "Crisis". | "Microsoft Panic." |
| **MYSTERY** | **15** | "The Secret," "The Truth". | "The Truth about Gemini." |
| **STANDARD** | **5** | "Update," "Launch," "News". | "Android 15 Update." |

### 4. 🧠 Intellectual Superiority (Weight: 15%)
*Does reading this make the user feel smarter than others?*

| Level | Score | Description | Example |
|-------|-------|-------------|---------|
| **ELITE** | **15** | "99% don't know this," "Matrix Mode". | "Become the top 1%." |
| **INSIDER** | **10** | "Leaked info," "Industry secret". | "Internal memo leaked." |
| **GENERAL** | **0** | Public knowledge. | "What is AI?" |

---

## 📊 Score Interpretation

| Total Score | Classification | Recommendation |
|-------------|----------------|----------------|
| **85 - 100** | 🔥🔥🔥 **VIRAL LOCK** | **Build as "Forbidden Knowledge" System.** |
| **65 - 84** | 🔥 **HIGH POTENTIAL** | Focus on the "Advantage" it gives. |
| **40 - 64** | ⚠️ **MID/RISKY** | **Add a "How-to" section.** Turn news into a tool. |
| **0 - 39** | ❌ **FLOP** | **DO NOT GENERATE.** Boring news. |

---

## 🧪 Historical Validation

**Post 1: 7 Forbidden Prompts (Actual: 6k Views / High Engagement)**
- **Utility (40):** Forbidden (40) - "Forbidden prompts".
- **Impact (25):** Wealth (25) - "Billionaire brain".
- **Hook (20):** Mystery (15) - "Magic Wand".
- **Elite (15):** Elite (15) - "Top 1%".
- **TOTAL:** **95/100** (Viral Lock)

**Post 2: Siri Dead (Actual: 2k Views / Low Engagement)**
- **Utility (40):** News (5) - Reporting failure.
- **Impact (25):** Abstract (5) - "Architecture crash".
- **Hook (20):** War/Panic (20) - "Dead", "White Flag".
- **Elite (15):** General (0).
- **TOTAL:** **30/100** (Flop/Risky - correctly predicted)

