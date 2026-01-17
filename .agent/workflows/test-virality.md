---
description: Test the virality potential of a topic using the prediction engine.
---
# Test Virality Workflow

This workflow analyzes a given topic or text against the `prediction_model.md` of either Eden AI or Alpha News to predict its viral success.

## Steps

1.  **Identify Target Agent**
    -   If the input involves "True Crime", "Villains", or "Stories" -> **Eden AI**.
    -   If the input involves "News", "Tools", "Updates", "Tech" -> **Alpha News**.

2.  **Read Prediction Model**
    -   If Eden AI: Read `c:\Users\User\Desktop\AICONTENT\Eden_AI\analytics\prediction_model.md`
    -   If Alpha News: Read `c:\Users\User\Desktop\AICONTENT\Alpha_News\analytics\prediction_model.md`

3.  **Analyze & Score**
    -   Compare the user input against the 4 scoring factors in the model.
    -   Assign a score for each factor based *strictly* on the definitions.
    -   Sum the scores.

4.  **Generate Report**
    -   Output a report using this format:

    ```markdown
    # 🔮 Virality Oracle Report

    **Topic:** [Topic Name]
    **Target Agent:** [Eden AI / Alpha News]
    **Total Score:** [X]/100

    ## 📊 Factor Breakdown
    1. [Factor 1 Name]: [Score] - [Reason]
    2. [Factor 2 Name]: [Score] - [Reason]
    3. [Factor 3 Name]: [Score] - [Reason]
    4. [Factor 4 Name]: [Score] - [Reason]

    ## 🏁 Verdict
    [VIRAL LOCK / HIGH POTENTIAL / MID / FLOP]

    ## 💡 Missing Ingredients
    - [Specific advice on how to improve the score based on the model]
    ```

