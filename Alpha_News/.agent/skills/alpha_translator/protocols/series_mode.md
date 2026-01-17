# 🔗 Series Mode Protocol

## Creating Connected Multi-Part Content

---

## 🎯 WHEN TO ACTIVATE

Activate Series Mode when:
1. Topic has major update (Part 2)
2. Story is too complex for one post
3. Building anticipation works
4. Previous related post performed well

---

## 🔍 DETECTION

Before generating, check `output/history_index.md`:

```
IF topic appears in last 30 days
AND previous post score > 35
THEN offer Series Mode
```

### Example Prompt to User
```
📺 Detected: You covered "OpenAI" on 2026-01-10.
That post scored 44/49.

Would you like to:
A) Create "Part 2" as a series continuation
B) Fresh post (no connection)
```

---

## 📋 SERIES FORMAT

### Part 2+ Posts Must Include:

#### 1. Callback Hook
Start with reference to previous post:
```
"გახსოვთ, რა გითხარით OpenAI-ზე? ახლა უარესია."
(Remember what we told you about OpenAI? It's worse now.)
```

#### 2. Recap Line
One sentence summary of Part 1:
```
"წინა პოსტში ვაჩვენეთ, რომ 200 ადამიანი გაათავისუფლეს. დღეს - რა მოხდა შემდეგ."
(Last post showed 200 fired. Today - what happened next.)
```

#### 3. Part Label
Clearly mark the series:
```
📺 OpenAI Saga: ნაწილი 2/3
(OpenAI Saga: Part 2/3)
```

#### 4. Cliffhanger (if more parts coming)
End with hook for next part:
```
"მაგრამ ეს მხოლოდ დასაწყისია. მალე გეტყვით, ვინ დგას ამის უკან."
(But this is just the beginning. Soon we'll tell you who's behind this.)
```

---

## 📊 SERIES TRACKING

In `output/history_index.md`, track series:

```markdown
## Active Series

| Series Name | Parts | Started | Status |
|-------------|-------|---------|--------|
| OpenAI Saga | 2/3 | 2026-01-10 | Active |
| Musk vs AI | 1/2 | 2026-01-12 | Pending |
```

---

## 🎨 VISUAL CONSISTENCY

For series posts:
1. Use SAME character across all parts
2. Use similar environment (with progression)
3. Keep color palette consistent
4. Add "Part X" text to image prompts

### Image Prompt Addition
```
Text overlay: "ნაწილი 2" in bold, corner position, glowing effect
```

---

## 📈 SERIES STRATEGY

### Part 1: Setup
- Introduce the problem
- Name the villain
- Create curiosity gap
- Score target: 35+

### Part 2: Escalation
- New information revealed
- Stakes raised
- More specific details
- Reference Part 1 themes

### Part 3: Resolution (if applicable)
- Conclusion or prediction
- Call to action or warning
- Wrap up the narrative
- Tease future topics

---

## ⚠️ RULES

1. Maximum 4 parts per series (attention span limit)
2. Minimum 2 days between parts (build anticipation)
3. Maximum 7 days between parts (don't lose thread)
4. Each part must stand alone (new readers)
5. Always reference previous parts

