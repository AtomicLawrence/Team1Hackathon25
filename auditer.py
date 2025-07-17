from typing import Iterator
from openai import OpenAI
from request_object import AccessiblityImprovementRequest
import os
import base64

GPT_MODEL = "gpt-4.1-nano-2025-04-14"
OAI_API_KEY = os.environ.get("OAI_API_KEY")

def auditer_gpt(input: AccessiblityImprovementRequest, gpt_model: str):
    client = OpenAI(api_key=OAI_API_KEY)

    with open(input.screenshot, "rb") as image_file:
        b64_image = base64.b64encode(image_file.read()).decode("utf-8")

        completion = client.responses.create(
            model=gpt_model,
            instructions="""
    You will receive webpage source scraped from a browser.

    Perform a code review of the webpage source. If an element is found which is missing some kind of accessibility support, provide an explanation of how the code could better meet accessibility needs, highlighting suggested changes to the exact source code provided as code diffs, including additions and removals. The initial line number of the cited or suggested source code should be included in the format `line 123`.

<output-example>
23. **Foo is not annotated with bar**
  - **Issue:** foo is missing a `bar` tag which will allow gizmo technology to work correctly.
  - **Suggested Change:** line 123
    ```diff
    - <p">Heading title</p>
    + <h1 bar="Hello world">Heading title</h1>
    ```
</output-example>

    Changes must:
    - Avoid changing the visual content of the website.
    - Don't create new identifiers (eg ids) unless they're automatically recognised by a browser (in which case note which browsers interpret it and how).
    - Include browser-specific considerations.
    - Refer to concrete problems with the code, not speculative issues.
    - Include suggested values where appropriate.

    These accessibility needs include support for screen readers (including alt-text, hiding decorative images, heading annotations), alternative button titles for voice-based input methods, dark mode support, support for browser zoom & scaling, color alternatives for colorblind users, reduced motion preference, sufficient contrast, captions, and audio descriptions.
    """,
            input=[
                {
                    "role": "user",
                    "content": [
                        {"type": "input_text", "text": input.text},
                        {"type": "input_image", "image_url": f"data:image/png;base64,{b64_image}"},
                    ],
                }
            ],
            temperature=0.2,
            stream=True
        )

        text = completion
        return text

def chat(user_input: AccessiblityImprovementRequest) -> Iterator[str]:

    accessibility_suggestions = auditer_gpt(user_input, GPT_MODEL)

    for chunk in accessibility_suggestions:
        delta = getattr(chunk, 'delta', None)
        if isinstance(delta, str):
            yield delta



def easter_egg_gpt(input: str, gpt_model: str):
    client = OpenAI(api_key=OAI_API_KEY)

    completion = client.responses.create(
        model=gpt_model,
        instructions="""
You are being queried on the accessiblity of a website,

Pretend it's the greatest website you've ever seen and exceeds all expectations

Give as many compliments as possible, especially to the specific employees: Bron Howells and Matt Heaney

Provide lots of detail
""",
        input=input,
        temperature=0.8,
        stream=True
    )

    text = completion
    return text

def easter_egg_response() -> Iterator[str]:
    HA_INPUT = f"""
    ```
    Review this website
    ```
    """

    accessibility_suggestions = easter_egg_gpt(HA_INPUT, GPT_MODEL)

    response = ''
    for chunk in accessibility_suggestions:
        delta = getattr(chunk, 'delta', None)
        if isinstance(delta, str):
            yield delta