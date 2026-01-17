---
description: Generate a viral True Crime story using the Viral Architect skill
---

# Viral Story Workflow

Use this workflow to generate True Crime content in Georgian.

## Steps

1. **Get Topic**
   Ask the user: "What topic/story should I cover?"

2. **Load Skill**
   Read and follow instructions from `.agent/skills/viral_architect/SKILL.md`

3. **Plan the Loop**
   Before writing, plan:
   - Start Subject (Proper Noun)
   - End Connector
   - Verify causality

4. **Generate Story**
   Write all 7 blocks in Georgian following the template

5. **Video Prompts**
   Include VID text prompts for each block (for Runway/Pika/etc.)

6. **Save Output**
   Save the complete story to: `output/[YYYY-MM-DD]_[topic].md`

7. **Present to User**
   Show the completed story with metadata

