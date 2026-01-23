---
description: Deep questioning mode - Agent asks 20 clarifying questions to fully understand the task
---

# /ask Workflow — Deep Understanding Protocol

## Purpose
When the user types `/ask [topic/task]`, the agent enters **Deep Questioning Mode** to extract maximum context before responding.

## Protocol

### Step 1: Acknowledge
Confirm activation:
```
🎯 DEEP UNDERSTANDING MODE ACTIVATED
Тема: [topic from user]
Задаю 20 уточняющих вопросов для полного понимания...
```

### Step 2: Generate 20 Strategic Questions
Ask 20 questions across these categories:

**КОНТЕКСТ (1-4)**
1. Целевая аудитория?
2. Платформа/формат?
3. Срочность?
4. Бюджет/ресурсы?

**ЦЕЛЬ (5-8)**
5. Главный результат?
6. Метрики успеха?
7. Чего избежать?
8. Идеальный outcome?

**СОДЕРЖАНИЕ (9-12)**
9. Обязательные элементы?
10. Что исключить?
11. Тон/стиль?
12. Референсы/примеры?

**ТЕХНИЧЕСКИЕ (13-16)**
13. Ограничения?
14. Интеграции?
15. Формат вывода?
16. Дедлайн?

**ГЛУБИНА (17-20)**
17. Почему именно это?
18. Предыдущие попытки?
19. Скрытые требования?
20. Что я мог упустить?

### Step 3: Collect Answers
Wait for user to answer all or some questions.

### Step 4: Synthesize & Confirm
After receiving answers:
1. Summarize understanding
2. Confirm key decisions
3. Proceed with task

### Step 5: Remember Context
Store critical context in agent memory for future reference:
- Save to `C:\Users\User\Desktop\AICONTENT\Alpha_News\.agent\memory\contexts\` (or respective agent folder)
- Use format: `YYYYMMDD_topic_context.md`

## Usage Examples
```
User: /ask viral video about AI courses
User: /ask как лучше структурировать курс
User: /ask optimizing my content strategy
```

## Notes
- Questions should be adapted to the specific topic
- Skip irrelevant categories
- Can be used with any agent
- All agents must recognize this command
