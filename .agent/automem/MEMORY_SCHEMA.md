# AutoMem Schema for AI Agents

## Memory Types

Мы будем использовать стандартные типы AutoMem, но с определённой структурой `content` и `metadata`.

### 1. `Post` (Memory)
Запоминаем каждый опубликованный пост.
- **Type**: `Context` (или Custom `Post`)
- **Tags**: `post`, `runner:<agent_name>`, `platform:<fb|tg>`, `status:<published>`
- **Content**: Текст поста или Summary.
- **Metadata**:
  ```json
  {
    "url": "https://...",
    "views": 1000,
    "likes": 50,
    "shares": 10,
    "date": "2025-10-25"
  }
  ```

### 2. `Topic` (Entity/Memory)
Темы, которые мы освещаем.
- **Type**: `Concept`
- **Tags**: `topic`, `category:<tech|science|politics>`
- **Content**: Описание темы (e.g., "AI Regulation in EU").

### 3. `Strategy` (Insight)
Что сработало, а что нет.
- **Type**: `Insight`
- **Tags**: `strategy`, `outcome:<success|fail>`
- **Content**: "Короткие хуки с вопросами работают лучше для новостей про AI".

---

## Connections (Edges)

AutoMem создает связи автоматически, но мы можем форсировать их:

- **RELATES_TO**: Пост -> Тема
- **DERIVED_FROM**: Пост -> Источник (URL)
- **NEXT_TO**: Пост -> Следующий пост (в серии)
- **CAUSES**: Стратегия -> Успех (High Views)

---

## Agent Usage Patterns

### Перед генерацией (Recall)
Агент должен спросить память:
1. "Что мы писали про [Тема] ранее?" -> Проверка на повторы.
2. "Какие стратегии работают для [Тема]?" -> Оптимизация стиля.

### После публикации (Store)
Агент сохраняет:
1. Сам пост.
2. Связь с темой.

### После сбора аналитики (Update/Enrich)
Агент (или скрипт аналитики) находит память поста и добавляет статистику (Views, Likes) в metadata, и, возможно, создает `Insight`, если пост "виральный" (>10k views).
