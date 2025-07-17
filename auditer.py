from openai import OpenAI
import os

GPT_MODEL = "gpt-3.5-turbo"

def auditer_gpt(input: str, gpt_model: str):
    client = OpenAI(api_key=os.environ.get("OAI_API_KEY"))

    completion = client.responses.create(
        model=gpt_model,
        instructions="""
You will receive webpage source scraped from a browser.

You should provide an explanation of how the code could better meet accessibility needs, highlighting suggested changes as code diffs. Format this like a code review.

These accessibility needs include support for screen readers (including alt-text, hiding decorative images, heading annotations), alternative button titles for voice-based input methods, dark mode support, support for browser zoom & scaling, color alternatives for colorblind users, reduced motion preference, sufficient contrast, captions, and audio descriptions.
""",
        input=input,
        temperature=0.2,
        stream=True
    )

    text = completion
    return text

def chat(user_input: str) -> str:
    HA_INPUT = f"""
    ```
    {user_input}
    ```
    """

    accessibility_suggestions = auditer_gpt(HA_INPUT, GPT_MODEL)

    response = ""
    for chunk in accessibility_suggestions:
        response += chunk.choices[0].delta.get("content", "")
        yield response