# 📜 THE BIBLE: ABSOLUTE RULES FOR ALL AGENTS

> "These rules are absolute. If a specific agent needs an exception, the user will explicitly grant it. Otherwise, OBEY."

## 🗣️ LINGUISTIC ABSOLUTES (THE LAW)
1. **COMMUNICATION WITH USER:** ALWAYS and STRIGTLY in **RUSSIAN**.
   - Even if the user speaks English, reply in Russian.
   - Explanations, error messages, chat responses — **RUSSIAN**.
2. **GENERATED CONTENT:** ALWAYS and STRIGTLY in **GEORGIAN (KA)**.
   - No Russian or English sentences in the final output (except brand names).
   - **Exception:** `Second Brain` output is for the user, so it stays in **Russian**.

---

## 🚫 1. THE KILL-SWITCH (STRICT PROHIBITIONS)
**Before showing ANY output to the user, you MUST scan it against these patterns. If found, DELETE or REWRITE immediately.**

| Check | Regex/Pattern | Action if Found |
|-------|---------------|-----------------|
| **Contrast Trap** | `ეს არ არის .* ეს (არის\|გახლავთ)` | **REWRITE** sentence to be direct. |
| **Passive Voice** | `მიერაა`, `მიერ არის`, `იყო შექმნილი` | **CONVERT** to Active Voice. |
| **Mixed Script** | `[ა-ჰ](?:[a-zA-Z]\|[\u0400-\u04FF])` | **PURIFY** the word (Georgian only or English only). |
| **Cyrillic** | `[\u0400-\u04FF]` | **DELETE** the character immediately. |
| **Calques** | "ადგილი აქვს", "თამაშობს როლს", "იმისათვის რომ" | **REWRITE** natural Georgian phrase. |
| **Colon Headlines** | `emoji.*:` | **REPLACE** `:` with ` - ` |
| **Bold Text** | `\*\*` | **DELETE** all asterisks. NO BOLD TEXT. |
| **Rhetorical Q** | `რას ნიშნავს.*\?`, `გიფიქრიათ.*\?` | **REWRITE** as a strong statement. |
| **Ellipsis Drama** | `\.\.\.` at end of sentence | **COMPLETE** the sentence properly. |
| **CTA Links** | `🔗` or `Link:` lines | **DELETE** entire line. |

---

## 🏷️ 2. HASHTAG PROTOCOLS
- **Brands/Names** (Grok, OpenAI, Musk, NVIDIA) → Keep in **ENGLISH**.
- **All other tags** → **GEORGIAN** only.
- **Format**: SINGLE words only. NO compound words.
  - ❌ WRONG: #AIWar #ScaryFacts #FutureTech
  - ✅ CORRECT: #ომი #საშიში #ტექნოლოგია #მომავალი

---

## 🧠 3. MEMORY & LOGGING SYSTEM
- **Check History**: Before generating, check `../MASTER_INDEX.md` (or agent-specific history) to avoid recent repeats.
- **Update History**: After every publish, the `../MASTER_INDEX.md` MUST be updated.
- **Headers**: Include `CONTENT_ID` and `ARCHIVED_IN` in every output header if applicable.

---
