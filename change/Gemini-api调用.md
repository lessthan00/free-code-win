# Gemini API

We recommend using the **Interactions API** for all new projects. It is optimized for agentic workflows, state management, and the latest models. Learn more in the [Interactions API Overview](https://ai.google.dev/gemini-api/docs/interactions-overview).

The fastest path from prompt to production with Gemini, Veo, Nano Banana, and more.

### Python

    from google import genai

    client = genai.Client()

    interaction = client.interactions.create(
        model="gemini-3.5-flash",
        input="Explain how AI works in a few words"
    )

    print(interaction.output_text)

### JavaScript

    import { GoogleGenAI } from "@google/genai";

    const ai = new GoogleGenAI({});

    const interaction = await ai.interactions.create({
      model: "gemini-3.5-flash",
      input: "Explain how AI works in a few words",
    });

    console.log(interaction.output_text);

### REST

    curl -X POST "https://generativelanguage.googleapis.com/v1beta/interactions" \
      -H "x-goog-api-key: $GEMINI_API_KEY" \
      -H 'Content-Type: application/json' \
      -d '{
        "model": "gemini-3.5-flash",
        "input": "Explain how AI works in a few words"
      }'

[Start building](https://ai.google.dev/gemini-api/docs/quickstart) Follow our Quickstart guide to get an API key and make your first API call in minutes.

*** ** * ** ***

## Meet the models

[View all](https://ai.google.dev/gemini-api/docs/models) [Gemini 3.1 Pro
New
Our most intelligent model, the best in the world for multimodal understanding, all built on state-of-the-art reasoning.](https://ai.google.dev/gemini-api/docs/models/gemini-3.1-pro-preview) [Gemini 3.5 Flash
New
Frontier-class performance rivaling larger models at a fraction of the cost.](https://ai.google.dev/gemini-api/docs/models/gemini-3.5-flash) [Gemini 3.1 Flash-Lite
New
High-volume, cost-sensitive model with the performance and quality of the Gemini 3 series.](https://ai.google.dev/gemini-api/docs/models/gemini-3.1-flash-lite) [Gemini 3 Flash
Frontier-class performance rivaling larger models at a fraction of the cost.](https://ai.google.dev/gemini-api/docs/models/gemini-3-flash-preview) [Nano Banana 2 and Nano Banana Pro
State-of-the-art image generation and editing models.](https://ai.google.dev/gemini-api/docs/image-generation) [Veo 3.1
Our state-of-the-art video generation model, with native audio.](https://ai.google.dev/gemini-api/docs/video) [Gemini Robotics
A vision-language model (VLM) that brings Gemini's agentic capabilities to robotics and enables advanced reasoning in the physical world.](https://ai.google.dev/gemini-api/docs/robotics-overview)

## Explore Capabilities

[Native Image Generation (Nano Banana)
Generate and edit highly contextual images natively with Gemini 2.5 Flash Image.](https://ai.google.dev/gemini-api/docs/image-generation) [Long Context
Input millions of tokens to Gemini models and derive understanding from unstructured images, videos, and documents.](https://ai.google.dev/gemini-api/docs/long-context) [Structured Outputs
Constrain Gemini to respond with JSON, a structured data format suitable for automated processing.](https://ai.google.dev/gemini-api/docs/structured-output) [Function Calling
Build agentic workflows by connecting Gemini to external APIs and tools.](https://ai.google.dev/gemini-api/docs/function-calling) [Video Generation with Veo 3.1
Create high-quality video content from text or image prompts with our state-of-the-art model.](https://ai.google.dev/gemini-api/docs/video) [Voice Agents with Live API
Build real-time voice applications and agents with the Live API.](https://ai.google.dev/gemini-api/docs/live) [Tools
Connect Gemini to the world through built-in tools like Google Search, URL Context, Google Maps, Code Execution and Computer Use.](https://ai.google.dev/gemini-api/docs/tools) [Document Understanding
Process up to 1000 pages of PDF files with full multimodal understanding or other text-based file types.](https://ai.google.dev/gemini-api/docs/document-processing) [Thinking
Explore how thinking capabilities improve reasoning for complex tasks and agents.](https://ai.google.dev/gemini-api/docs/thinking) [Google AI Studio
Test prompts, manage your API keys, monitor usage, and build prototypes.](https://aistudio.google.com) [Developer Community
Ask questions and find solutions from other developers and Google engineers.](https://discuss.ai.google.dev/c/gemini-api/4) [API Reference
Find detailed information about the Gemini API in the official reference documentation.](https://ai.google.dev/api) [Status
Check the status of Gemini API, Google AI Studio, and our model services.](https://aistudio.google.com/status)



# Getting started

<br />

> [!NOTE]
> **Note:** This version of the page covers the **Interactions API** . You can use the toggle on this page to switch to the [generateContent API version of this
> page](https://ai.google.dev/gemini-api/docs/generate-content/get-started).

This guide gets you started with the Gemini API using the [Interactions API](https://ai.google.dev/gemini-api/docs/interactions-overview). You'll make your first API call in under a minute and explore text generation, multimodal understanding, image generation, structured output, tools, function calling, agents, and background execution.

> [!NOTE]
> **Using a coding agent?** Install the skill so your agent stays current with Interactions API patterns:
>
> ```
> npx skills add google-gemini/gemini-skills --skill gemini-interactions-api
> ```

The Interactions API is available through the [Python](https://github.com/googleapis/python-genai) and [JavaScript](https://github.com/googleapis/js-genai) SDKs, as well as through REST.

## 1. Get an API key

To use the Gemini API, you need an [API key](https://ai.google.dev/gemini-api/docs/api-key). Create one for free to get started:

[Create a Gemini API Key](https://aistudio.google.com/apikey)

Then set it as an environment variable:

    export GEMINI_API_KEY="YOUR_API_KEY"

## 2. Install the SDK and make your first call

Install the SDK and generate text with a single API call.

### Python

Install the SDK:

    pip install -U google-genai

Initialize the client and make a request:

    from google import genai

    client = genai.Client()

    interaction = client.interactions.create(
        model="gemini-3.5-flash",
        input="Explain how AI works in a few words"
    )
    print(interaction.output_text)

### JavaScript

Install the SDK:

    npm install @google/genai

Initialize the client and make a request:

    import { GoogleGenAI } from "@google/genai";

    const ai = new GoogleGenAI({});

    const interaction = await ai.interactions.create({
      model: "gemini-3.5-flash",
      input: "Explain how AI works in a few words",
    });
    console.log(interaction.output_text);

### REST

    curl -X POST "https://generativelanguage.googleapis.com/v1beta/interactions" \
      -H "x-goog-api-key: $GEMINI_API_KEY" \
      -H 'Content-Type: application/json' \
      -d '{
        "model": "gemini-3.5-flash",
        "input": "Explain how AI works in a few words"
      }'

**Response:**

    {
      "id": "v1_ChdpQUFvYXI...",
      "status": "completed",
      "usage": {
        "total_tokens": 197,
        "total_input_tokens": 8,
        "total_output_tokens": 12
      },
      "created": "2026-06-09T12:01:25Z",
      "steps": [
        {
          "type": "thought",
          "signature": "EvEFCu4FAQw..."
        },
        {
          "type": "model_output",
          "content": [
            {
              "type": "text",
              "text": "AI learns patterns from data, then uses those patterns to make predictions or decisions on new data."
            }
          ]
        }
      ],
      "object": "interaction",
      "model": "gemini-3.5-flash",
    }

When using REST, the API returns the full `Interaction` resource containing metadata, usage statistics, and the step-by-step history of the turn.

While the SDKs expose the full response, they also provide convenience properties like `interaction.output_text` and `interaction.output_image` to access final outputs directly. Learn more about the response structure in the [Interactions overview](https://ai.google.dev/gemini-api/docs/interactions-overview) or read the [text generation guide](https://ai.google.dev/gemini-api/docs/text-generation) for details on system instructions and generation config.

## 3. Stream the response

For more fluid interactions, stream the response as it's generated. Each `step.delta` event delivers a chunk of text you can display immediately.

### Python

    from google import genai

    client = genai.Client()

    stream = client.interactions.create(
        model="gemini-3.5-flash",
        input="Explain how AI works",
        stream=True
    )
    for event in stream:
        print(event)

### JavaScript

    import { GoogleGenAI } from "@google/genai";

    const ai = new GoogleGenAI({});

    const stream = await ai.interactions.create({
      model: "gemini-3.5-flash",
      input: "Explain how AI works",
      stream: true,
    });

    for await (const event of stream) {
      console.log(event);
    }

### REST

    curl -X POST "https://generativelanguage.googleapis.com/v1beta/interactions?alt=sse" \
      -H "x-goog-api-key: $GEMINI_API_KEY" \
      -H 'Content-Type: application/json' \
      --no-buffer \
      -d '{
        "model": "gemini-3.5-flash",
        "input": "Explain how AI works",
        "stream": true
      }'

When streaming, the server responds with a stream of server-sent events (SSE). Each event includes a type and JSON data.

**Response:**

    event: interaction.created
    data: {"interaction":{"id":"v1_Chd...","status":"in_progress","model":"gemini-3.5-flash"},"event_type":"interaction.created"}

    event: step.start
    data: {"index":0,"step":{"type":"thought"},"event_type":"step.start"}

    event: step.delta
    data: {"index":0,"delta":{"signature":"EvEFCu4F...","type":"thought_signature"},"event_type":"step.delta"}

    event: step.stop
    data: {"index":0,"event_type":"step.stop"}

    event: step.start
    data: {"index":1,"step":{"type":"model_output"},"event_type":"step.start"}

    event: step.delta
    data: {"index":1,"delta":{"text":"AI ","type":"text"},"event_type":"step.delta"}

    event: step.delta
    data: {"index":1,"delta":{"text":"works ","type":"text"},"event_type":"step.delta"}

    event: step.stop
    data: {"index":1,"event_type":"step.stop"}

    event: interaction.completed
    data: {"interaction":{"id":"v1_Chd...","status":"completed","usage":{"total_tokens":197}},"event_type":"interaction.completed"}

For a detailed look at handling streaming events and delta types, see the [streaming interactions guide](https://ai.google.dev/gemini-api/docs/streaming).

## 4. Multi-turn conversations

The Interactions API supports multi-turn conversations with two approaches:

- **Stateful (recommended)** : Continue a conversation on the server using `previous_interaction_id`. Ideal for most chat and agentic workflows where you want the server to manage history and optimize caching.
- **Stateless**: Manage the conversation history on the client by passing all previous turns (including intermediate model thought and tool steps) in each request.

### Stateful (recommended)

Chain interactions by passing `previous_interaction_id`. The server manages the full conversation history for you.

### Python

    from google import genai

    client = genai.Client()

    # Server-side state (recommended)
    interaction1 = client.interactions.create(
        model="gemini-3.5-flash",
        input="I have 2 dogs in my house.",
    )
    print("Response 1:", interaction1.output_text)

    interaction2 = client.interactions.create(
        model="gemini-3.5-flash",
        input="How many paws are in my house?",
        previous_interaction_id=interaction1.id,
    )
    print("Response 2:", interaction2.output_text)

### JavaScript

    import { GoogleGenAI } from "@google/genai";

    const ai = new GoogleGenAI({});

    // Server-side state (recommended)
    const interaction1 = await ai.interactions.create({
      model: "gemini-3.5-flash",
      input: "I have 2 dogs in my house.",
    });
    console.log("Response 1:", interaction1.output_text);

    const interaction2 = await ai.interactions.create({
      model: "gemini-3.5-flash",
      input: "How many paws are in my house?",
      previous_interaction_id: interaction1.id,
    });
    console.log("Response 2:", interaction2.output_text);

### REST

    RESPONSE1=$(curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/interactions" \
      -H "x-goog-api-key: $GEMINI_API_KEY" \
      -H 'Content-Type: application/json' \
      -d '{
        "model": "gemini-3.5-flash",
        "input": "I have 2 dogs in my house."
      }')

    INTERACTION_ID=$(echo "$RESPONSE1" | jq -r '.id')
    echo "Interaction 1 ID: $INTERACTION_ID"

    curl -X POST "https://generativelanguage.googleapis.com/v1beta/interactions" \
      -H "x-goog-api-key: $GEMINI_API_KEY" \
      -H 'Content-Type: application/json' \
      -d '{
        "model": "gemini-3.5-flash",
        "input": "How many paws are in my house?",
        "previous_interaction_id": "'$INTERACTION_ID'"
      }'

### Stateless

Set `store=false` and manage conversation history on the client side. You must preserve and resend all model-generated steps (including `thought` and `function_call` steps) exactly as received.

### Python

    from google import genai

    client = genai.Client()

    history = [
        {
            "type": "user_input",
            "content": [{"type": "text", "text": "I have 2 dogs in my house."}]
        }
    ]

    interaction1 = client.interactions.create(
        model="gemini-3.5-flash",
        store=False,
        input=history
    )
    print("Response 1:", interaction1.steps[-1].content[0].text)

    for step in interaction1.steps:
        history.append(step.model_dump())

    history.append({
        "type": "user_input",
        "content": [{"type": "text", "text": "How many paws are in my house?"}]
    })

    interaction2 = client.interactions.create(
        model="gemini-3.5-flash",
        store=False,
        input=history
    )
    print("Response 2:", interaction2.steps[-1].content[0].text)

### JavaScript

    import { GoogleGenAI } from "@google/genai";

    const ai = new GoogleGenAI({});

    const history = [
      {
        type: "user_input",
        content: [{ type: "text", text: "I have 2 dogs in my house." }]
      }
    ];

    const interaction1 = await ai.interactions.create({
      model: "gemini-3.5-flash",
      store: false,
      input: history
    });
    console.log("Response 1:", interaction1.steps.at(-1).content[0].text);

    history.push(...interaction1.steps);

    history.push({
      type: "user_input",
      content: [{ type: "text", text: "How many paws are in my house?" }]
    });

    const interaction2 = await ai.interactions.create({
      model: "gemini-3.5-flash",
      store: false,
      input: history
    });
    console.log("Response 2:", interaction2.steps.at(-1).content[0].text);

### REST

    # Turn 1: Send with store: false
    RESPONSE1=$(curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/interactions" \
      -H "x-goog-api-key: $GEMINI_API_KEY" \
      -H 'Content-Type: application/json' \
      -d '{
        "model": "gemini-3.5-flash",
        "store": false,
        "input": [
          {
            "type": "user_input",
            "content": "I have 2 dogs in my house."
          }
        ]
      }')

    MODEL_STEPS=$(echo "$RESPONSE1" | jq '.steps')

    # Turn 2: Build full history
    HISTORY=$(jq -n \
      --argjson first_input '[{"type": "user_input", "content": "I have 2 dogs in my house."}]' \
      --argjson model_steps "$MODEL_STEPS" \
      --argjson second_input '[{"type": "user_input", "content": "How many paws are in my house?"}]' \
      '$first_input + $model_steps + $second_input')

    curl -X POST "https://generativelanguage.googleapis.com/v1beta/interactions" \
      -H "x-goog-api-key: $GEMINI_API_KEY" \
      -H 'Content-Type: application/json' \
      -d "{
        \"model\": \"gemini-3.5-flash\",
        \"store\": false,
        \"input\": $HISTORY
      }"

**Response:**

    {
      "id": "v2_Chd...",
      "status": "completed",
      "usage": {
        "total_tokens": 240,
        "total_input_tokens": 60,
        "total_output_tokens": 20
      },
      "steps": [
        {
          "type": "model_output",
          "content": [
            {
              "type": "text",
              "text": "There are 8 paws in your house. 2 dogs \u00d7 4 paws = 8 paws."
            }
          ]
        }
      ],
      "object": "interaction",
      "model": "gemini-3.5-flash"
    }

The second interaction returns a complete response object that includes only the new steps, but is grounded in the previous turn's context. Learn more about maintaining state in the [multi-turn conversations guide](https://ai.google.dev/gemini-api/docs/text-generation#multi-turn-conversations), or explore [stateless mode](https://ai.google.dev/gemini-api/docs/text-generation#stateless-conversations) for client-side history management.

## 5. Multimodal understanding

Gemini models understand images, audio, video, and documents natively. Pass media alongside text in a single request.

### Python

    import base64
    from google import genai

    client = genai.Client()

    # Load a local image
    with open("sample.jpg", "rb") as f:
        image_bytes = f.read()
    image_b64 = base64.b64encode(image_bytes).decode("utf-8")

    interaction = client.interactions.create(
        model="gemini-3.5-flash",
        input=[
            {"type": "text", "text": "Compare this local image and this remote audio file."},
            {
                "type": "image",
                "data": image_b64,
                "mime_type": "image/jpeg"
            },
            {
                "type": "audio",
                "uri": "https://storage.googleapis.com/generativeai-downloads/data/sample.mp3",
                "mime_type": "audio/mp3"
            }
        ]
    )
    print(interaction.output_text)

### JavaScript

    import fs from "fs";
    import { GoogleGenAI } from "@google/genai";

    const ai = new GoogleGenAI({});

    // Load a local image
    const imageBytes = fs.readFileSync("sample.jpg");
    const imageB64 = imageBytes.toString("base64");

    const interaction = await ai.interactions.create({
      model: "gemini-3.5-flash",
      input: [
        { type: "text", text: "Compare this local image and this remote audio file." },
        {
          type: "image",
          data: imageB64,
          mime_type: "image/jpeg"
        },
        {
          type: "audio",
          uri: "https://storage.googleapis.com/generativeai-downloads/data/sample.mp3",
          mime_type: "audio/mp3"
        }
      ],
    });
    console.log(interaction.output_text);

### REST

    # Base64-encode local image
    BASE64_IMAGE=$(base64 -w 0 sample.jpg)

    curl -X POST "https://generativelanguage.googleapis.com/v1beta/interactions"   -H "x-goog-api-key: $GEMINI_API_KEY"   -H 'Content-Type: application/json'   -H "Api-Revision: 2026-05-20"   -d '{
        "model": "gemini-3.5-flash",
        "input": [
          {
            "type": "text",
            "text": "Compare this local image and this remote audio file."
          },
          {
            "type": "image",
            "data": "'$BASE64_IMAGE'",
            "mime_type": "image/jpeg"
          },
          {
            "type": "audio",
            "uri": "https://storage.googleapis.com/generativeai-downloads/data/sample.mp3",
            "mime_type": "audio/mp3"
          }
        ]
      }'

**Response:**

    {
      "id": "v1_Chd...",
      "status": "completed",
      "usage": {
        "total_tokens": 300
      },
      "steps": [
        {
          "type": "model_output",
          "content": [
            {
              "type": "text",
              "text": "The local image displays a pipe organ while the remote audio file is a sample MP3 clip..."
            }
          ]
        }
      ],
      "object": "interaction",
      "model": "gemini-3.5-flash",
    }

Explore how to pass images, video, and audio files in the [image understanding guide](https://ai.google.dev/gemini-api/docs/image-understanding).
[Audio understanding
Transcribe, summarize, or answer questions about audio files.](https://ai.google.dev/gemini-api/docs/audio) [Video understanding
Analyze video content, locate events, and describe actions.](https://ai.google.dev/gemini-api/docs/video-understanding) [Document processing
Extract information from PDFs and other document formats.](https://ai.google.dev/gemini-api/docs/document-processing)

## 6. Multimodal generation

Gemini can generate images natively using the [Nano Banana](https://ai.google.dev/gemini-api/docs/image-generation) image models.

### Python

    import base64
    from google import genai

    client = genai.Client()

    interaction = client.interactions.create(
        model="gemini-3.1-flash-image",
        input="Generate an image of a futuristic city skyline at sunset",
    )

    with open("generated_image.png", "wb") as f:
        f.write(base64.b64decode(interaction.output_image.data))

### JavaScript

    import { GoogleGenAI } from "@google/genai";
    import * as fs from "node:fs";

    const ai = new GoogleGenAI({});

    const interaction = await ai.interactions.create({
      model: "gemini-3.1-flash-image",
      input: "Generate an image of a futuristic city skyline at sunset",
    });

    const generatedImage = interaction.output_image;
    if (generatedImage) {
      const buffer = Buffer.from(generatedImage.data, "base64");
      fs.writeFileSync("generated_image.png", buffer);
    }

### REST

    curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/interactions" \
      -H "x-goog-api-key: $GEMINI_API_KEY" \
      -H 'Content-Type: application/json' \
      -d '{
        "model": "gemini-3.1-flash-image",
        "input": [
          {"type": "text", "text": "Generate an image of a futuristic city skyline at sunset"}
        ]
      }'

**Response:**

    {
      "id": "v1_Chd...",
      "status": "completed",
      "steps": [
        {
          "type": "model_output",
          "content": [
            {
              "type": "image",
              "data": "BASE64_ENCODED_IMAGE",
              "mime_type": "image/png"
            }
          ]
        }
      ],
      "object": "interaction",
      "model": "gemini-3.1-flash-image",
    }

When the model generates an image, it returns the base64-encoded image data in a step within the `steps` array, as well as via the `output_image` convenience property. Check out the [image generation guide](https://ai.google.dev/gemini-api/docs/image-generation) to learn about aspect ratios, image editing, and references.
[Speech generation
Generate expressive, multi-speaker speech with Gemini 3.1 Flash TTS.](https://ai.google.dev/gemini-api/docs/speech-generation) [Music generation
Create clips and full-length songs with Lyria 3.](https://ai.google.dev/gemini-api/docs/music-generation)

## 7. Use structured output

Configure the model to return JSON that matches a schema you define. Structured output works with [Pydantic](https://docs.pydantic.dev/latest/) (Python) and [Zod](https://zod.dev/) (JavaScript).

### Python

    from google import genai
    from pydantic import BaseModel, Field
    from typing import List, Optional

    class Recipe(BaseModel):
        recipe_name: str = Field(description="Name of the recipe.")
        ingredients: List[str] = Field(description="List of ingredients.")
        prep_time_minutes: Optional[int] = Field(description="Prep time in minutes.")

    client = genai.Client()

    interaction = client.interactions.create(
        model="gemini-3.5-flash",
        input="Give me a recipe for banana bread",
        response_format={
            "type": "text",
            "mime_type": "application/json",
            "schema": Recipe.model_json_schema()
        },
    )

    recipe = Recipe.model_validate_json(interaction.output_text)
    print(recipe)

### JavaScript

    import { GoogleGenAI } from "@google/genai";
    import * as z from "zod";

    const ai = new GoogleGenAI({});

    const recipeJsonSchema = {
      type: "object",
      properties: {
        recipe_name: { type: "string", description: "Name of the recipe." },
        ingredients: {
          type: "array",
          items: { type: "string" },
          description: "List of ingredients."
        },
        prep_time_minutes: {
          type: "integer",
          description: "Prep time in minutes."
        }
      },
      required: ["recipe_name", "ingredients"]
    };

    const recipeSchema = z.fromJSONSchema(recipeJsonSchema);

    const interaction = await ai.interactions.create({
      model: "gemini-3.5-flash",
      input: "Give me a recipe for banana bread",
      response_format: {
        type: "text",
        mime_type: "application/json",
        schema: recipeJsonSchema
      },
    });

    const recipe = recipeSchema.parse(JSON.parse(interaction.output_text));
    console.log(recipe);

### REST

    curl -X POST "https://generativelanguage.googleapis.com/v1beta/interactions" \
      -H "x-goog-api-key: $GEMINI_API_KEY" \
      -H 'Content-Type: application/json' \
      -d '{
        "model": "gemini-3.5-flash",
        "input": "Give me a recipe for banana bread",
        "response_format": {
          "type": "text",
          "mime_type": "application/json",
          "schema": {
            "type": "object",
            "properties": {
              "recipe_name": { "type": "string", "description": "Name of the recipe." },
              "ingredients": {
                "type": "array",
                "items": { "type": "string" },
                "description": "List of ingredients."
              },
              "prep_time_minutes": {
                "type": "integer",
                "description": "Prep time in minutes."
              }
            },
            "required": ["recipe_name", "ingredients"]
          }
        }
      }'

**Response:**

    {
      "id": "v1_Chd...",
      "status": "completed",
      "steps": [
        {
          "type": "model_output",
          "content": [
            {
              "type": "text",
              "text": "{\n  \"recipe_name\": \"Classic Banana Bread\",\n  \"ingredients\": [\n    \"3 ripe bananas, mashed\",\n    \"1/3 cup melted butter\",\n    \"3/4 cup sugar\",\n    \"1 egg, beaten\",\n    \"1 teaspoon vanilla extract\",\n    \"1 teaspoon baking soda\",\n    \"Pinch of salt\",\n    \"1.5 cups all-purpose flour\"\n  ],\n  \"prep_time_minutes\": 15\n}"
            }
          ]
        }
      ],
      "object": "interaction",
      "model": "gemini-3.5-flash",
    }

The output text block contains a valid JSON string conforming exactly to the requested schema. To learn how to define more complex structures and recursive schemas, see the [structured output guide](https://ai.google.dev/gemini-api/docs/structured-output).

## 8. Use tools

Ground the model's response in real-time information with Google Search. The API automatically searches, processes results, and returns citations.

### Python

    from google import genai

    client = genai.Client()

    interaction = client.interactions.create(
        model="gemini-3.5-flash",
        input="Who won the euro 2024?",
        tools=[{"type": "google_search"}]
    )

    print(interaction.output_text)

    # Print citations
    for step in interaction.steps:
        if step.type == "model_output":
            for content_block in step.content:
                if content_block.type == "text" and content_block.annotations:
                    print("\nCitations:")
                    for annotation in content_block.annotations:
                        if annotation.type == "url_citation":
                            print(f"  [{annotation.title}]({annotation.url})")

### JavaScript

    import { GoogleGenAI } from "@google/genai";

    const ai = new GoogleGenAI({});

    const interaction = await ai.interactions.create({
      model: "gemini-3.5-flash",
      input: "Who won the euro 2024?",
      tools: [{ type: "google_search" }]
    });

    console.log(interaction.output_text);

    // Print citations
    for (const step of interaction.steps) {
      if (step.type === "model_output") {
        for (const contentBlock of step.content) {
          if (contentBlock.type === "text" && contentBlock.annotations) {
            console.log("\nCitations:");
            for (const annotation of contentBlock.annotations) {
              if (annotation.type === "url_citation") {
                console.log(`  [${annotation.title}](${annotation.url})`);
              }
            }
          }
        }
      }
    }

### REST

    curl -X POST "https://generativelanguage.googleapis.com/v1beta/interactions" \
      -H "x-goog-api-key: $GEMINI_API_KEY" \
      -H 'Content-Type: application/json' \
      -d '{
        "model": "gemini-3.5-flash",
        "input": "Who won the euro 2024?",
        "tools": [{"type": "google_search"}]
      }'

**Response:**

    {
      "id": "v1_Chd...",
      "status": "completed",
      "steps": [
        {
          "type": "thought",
          "signature": "EvEFCu4F..."
        },
        {
          "type": "google_search_call",
          "arguments": {
            "queries": ["UEFA Euro 2024 winner"]
          }
        },
        {
          "type": "google_search_result",
          "call_id": "search_001",
          "result": [
            {
              "search_suggestions": "<!-- HTML and CSS search widget -->"
            }
          ]
        },
        {
          "type": "model_output",
          "content": [
            {
              "type": "text",
              "text": "Spain won Euro 2024, defeating England 2-1 in the final.",
              "annotations": [
                {
                  "type": "url_citation",
                  "url": "https://www.uefa.com/euro2024",
                  "title": "uefa.com",
                  "start_index": 0,
                  "end_index": 56
                }
              ]
            }
          ]
        }
      ],
      "object": "interaction",
      "model": "gemini-3.5-flash",
    }

The search steps are detailed within the interaction history, and the final output includes inline citations pointing to web sources.

You can learn how to extract search citations in the [Google Search grounding guide](https://ai.google.dev/gemini-api/docs/google-search), or see how to combine multiple tools in the [tool combination guide](https://ai.google.dev/gemini-api/docs/tool-combination).
[Code execution
Run Python code in a secure sandboxed Borg environment.](https://ai.google.dev/gemini-api/docs/code-execution) [URL context
Pass public web URLs directly to ground responses in webpage content.](https://ai.google.dev/gemini-api/docs/url-context) [File search
Index and search across uploaded documents and media files.](https://ai.google.dev/gemini-api/docs/file-search) [Google Maps
Ground responses in real-world geospatial and location data.](https://ai.google.dev/gemini-api/docs/maps-grounding) [Computer use
Browser automation and screen interaction.](https://ai.google.dev/gemini-api/docs/computer-use)

## 9. Call your own functions

Function calling lets you connect the model to your code. You declare a function's name and parameters, the model decides when to call it and returns structured arguments, and you execute it locally and send the result back.

### Stateful (recommended)

### Python

    import json
    from google import genai

    client = genai.Client()

    weather_tool = {
        "type": "function",
        "name": "get_current_temperature",
        "description": "Gets the current temperature for a given location.",
        "parameters": {
            "type": "object",
            "properties": {
                "location": {
                    "type": "string",
                    "description": "The city name, e.g. San Francisco",
                },
            },
            "required": ["location"],
        },
    }

    available_functions = {
        "get_current_temperature": lambda location: {
            "location": location, "temperature": "22", "unit": "celsius"
        },
    }

    user_input = "What is the temperature in London?"
    previous_id = None

    while True:
        interaction = client.interactions.create(
            model="gemini-3.5-flash",
            input=user_input,
            tools=[weather_tool],
            previous_interaction_id=previous_id,
        )

        function_results = []
        for step in interaction.steps:
            if step.type == "function_call":
                result = available_functions[step.name](**step.arguments)
                print(f"Called {step.name}({step.arguments}) → {result}")
                function_results.append({
                    "type": "function_result",
                    "name": step.name,
                    "call_id": step.id,
                    "result": [{"type": "text", "text": json.dumps(result)}],
                })

        if not function_results:
            break

        user_input = function_results
        previous_id = interaction.id

    print(interaction.output_text)

### JavaScript

    import { GoogleGenAI } from "@google/genai";

    const ai = new GoogleGenAI({});

    const weatherTool = {
      type: "function",
      name: "get_current_temperature",
      description: "Gets the current temperature for a given location.",
      parameters: {
        type: "object",
        properties: {
          location: {
            type: "string",
            description: "The city name, e.g. San Francisco",
          },
        },
        required: ["location"],
      },
    };

    const availableFunctions = {
      get_current_temperature: ({ location }) => ({
        location, temperature: "22", unit: "celsius"
      }),
    };

    let input = "What is the temperature in London?";
    let previousId = null;
    let interaction;

    while (true) {
      interaction = await ai.interactions.create({
        model: "gemini-3.5-flash",
        input,
        tools: [weatherTool],
        previous_interaction_id: previousId,
      });

      const functionResults = [];
      for (const step of interaction.steps) {
        if (step.type === "function_call") {
          const result = availableFunctions[step.name](step.arguments);
          console.log(`Called ${step.name}(${JSON.stringify(step.arguments)}) →`, result);
          functionResults.push({
            type: "function_result",
            name: step.name,
            call_id: step.id,
            result: [{ type: "text", text: JSON.stringify(result) }],
          });
        }
      }

      if (functionResults.length === 0) break;

      input = functionResults;
      previousId = interaction.id;
    }

    console.log(interaction.output_text);

### REST

    # Turn 1: Send prompt with function declaration
    RESPONSE1=$(curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/interactions" \
      -H "x-goog-api-key: $GEMINI_API_KEY" \
      -H 'Content-Type: application/json' \
      -d '{
        "model": "gemini-3.5-flash",
        "input": "What is the temperature in London?",
        "tools": [{
          "type": "function",
          "name": "get_current_temperature",
          "description": "Gets the current temperature for a given location.",
          "parameters": {
            "type": "object",
            "properties": {
              "location": {"type": "string", "description": "The city name"}
            },
            "required": ["location"]
          }
        }]
      }')

    INTERACTION_ID=$(echo "$RESPONSE1" | jq -r '.id')
    FC_NAME=$(echo "$RESPONSE1" | jq -r '.steps[] | select(.type=="function_call") | .name')
    FC_ID=$(echo "$RESPONSE1" | jq -r '.steps[] | select(.type=="function_call") | .id')
    echo "Function: $FC_NAME, Call ID: $FC_ID"

    # Turn 2: Send function result back
    curl -X POST "https://generativelanguage.googleapis.com/v1beta/interactions" \
      -H "x-goog-api-key: $GEMINI_API_KEY" \
      -H 'Content-Type: application/json' \
      -d '{
        "model": "gemini-3.5-flash",
        "previous_interaction_id": "'$INTERACTION_ID'",
        "input": [{
          "type": "function_result",
          "name": "'$FC_NAME'",
          "call_id": "'$FC_ID'",
          "result": [{"type": "text", "text": "{\"location\": \"London\", \"temperature\": \"22\", \"unit\": \"celsius\"}"}]
        }],
        "tools": [{
          "type": "function",
          "name": "get_current_temperature",
          "description": "Gets the current temperature for a given location.",
          "parameters": {
            "type": "object",
            "properties": {
              "location": {"type": "string", "description": "The city name"}
            },
            "required": ["location"]
          }
        }]
      }'

### Stateless

You can also use function calling in stateless mode by managing the conversation history on the client side and setting `store=false`. In stateless mode, you must pass the full history of the conversation in the `input` field of each subsequent request. This history must include:

1. The initial `user_input` step.
2. All model-generated steps returned in Turn 1 (including `thought` and `function_call` steps) exactly as received.
3. The `function_result` step containing the output of your executed function.

### Python

    import json
    from google import genai

    client = genai.Client()

    weather_tool = {
        "type": "function",
        "name": "get_current_temperature",
        "description": "Gets the current temperature for a given location.",
        "parameters": {
            "type": "object",
            "properties": {
                "location": {
                    "type": "string",
                    "description": "The city name, e.g. San Francisco",
                },
            },
            "required": ["location"],
        },
    }

    available_functions = {
        "get_current_temperature": lambda location: {
            "location": location, "temperature": "22", "unit": "celsius"
        },
    }

    history = [
        {
            "type": "user_input",
            "content": [{"type": "text", "text": "What is the temperature in London?"}]
        }
    ]

    while True:
        interaction = client.interactions.create(
            model="gemini-3.5-flash",
            store=False,
            input=history,
            tools=[weather_tool],
        )

        function_results = []
        for step in interaction.steps:
            history.append(step.model_dump())
            if step.type == "function_call":
                result = available_functions[step.name](**step.arguments)
                print(f"Called {step.name}({step.arguments}) → {result}")
                fn_result = {
                    "type": "function_result",
                    "name": step.name,
                    "call_id": step.id,
                    "result": [{"type": "text", "text": json.dumps(result)}],
                }
                function_results.append(fn_result)
                history.append(fn_result)

        if not function_results:
            break

    print(interaction.output_text)

### JavaScript

    import { GoogleGenAI } from "@google/genai";

    const ai = new GoogleGenAI({});

    const weatherTool = {
      type: "function",
      name: "get_current_temperature",
      description: "Gets the current temperature for a given location.",
      parameters: {
        type: "object",
        properties: {
          location: {
            type: "string",
            description: "The city name, e.g. San Francisco",
          },
        },
        required: ["location"],
      },
    };

    const availableFunctions = {
      get_current_temperature: ({ location }) => ({
        location, temperature: "22", unit: "celsius"
      }),
    };

    const history = [
      {
        type: "user_input",
        content: [{ type: "text", text: "What is the temperature in London?" }]
      }
    ];

    let interaction;

    while (true) {
      interaction = await ai.interactions.create({
        model: "gemini-3.5-flash",
        store: false,
        input: history,
        tools: [weatherTool],
      });

      const functionResults = [];
      for (const step of interaction.steps) {
        history.push(step);
        if (step.type === "function_call") {
          const result = availableFunctions[step.name](step.arguments);
          console.log(`Called ${step.name}(${JSON.stringify(step.arguments)}) →`, result);
          const fnResult = {
            type: "function_result",
            name: step.name,
            call_id: step.id,
            result: [{ type: "text", text: JSON.stringify(result) }],
          };
          functionResults.push(fnResult);
          history.push(fnResult);
        }
      }

      if (functionResults.length === 0) break;
    }

    console.log(interaction.output_text);

### REST

    # Turn 1: Send request with tools and store: false
    RESPONSE1=$(curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/interactions" \
      -H "x-goog-api-key: $GEMINI_API_KEY" \
      -H 'Content-Type: application/json' \
      -d '{
        "model": "gemini-3.5-flash",
        "store": false,
        "input": [
          {
            "type": "user_input",
            "content": "What is the temperature in London?"
          }
        ],
        "tools": [{
          "type": "function",
          "name": "get_current_temperature",
          "description": "Gets the current temperature for a given location.",
          "parameters": {
            "type": "object",
            "properties": {
              "location": {"type": "string", "description": "The city name"}
            },
            "required": ["location"]
          }
        }]
      }')

    # Extract model steps (thought, function_call)
    MODEL_STEPS=$(echo "$RESPONSE1" | jq '.steps')
    FC_NAME=$(echo "$RESPONSE1" | jq -r '.steps[] | select(.type=="function_call") | .name')
    FC_ID=$(echo "$RESPONSE1" | jq -r '.steps[] | select(.type=="function_call") | .id')
    echo "Function: $FC_NAME, Call ID: $FC_ID"

    # Assume local execution returns:
    RESULT="{\"location\": \"London\", \"temperature\": \"22\", \"unit\": \"celsius\"}"

    # Reconstruct history for Turn 2
    HISTORY=$(jq -n \
      --argjson first_input '[{"type": "user_input", "content": "What is the temperature in London?"}]' \
      --argjson model_steps "$MODEL_STEPS" \
      --arg fc_name "$FC_NAME" \
      --arg fc_id "$FC_ID" \
      --arg result "$RESULT" \
      '$first_input + $model_steps + [{"type": "function_result", "name": $fc_name, "call_id": $fc_id, "result": [{"type": "text", "text": $result}]}]')

    # Turn 2: Send the full history
    curl -X POST "https://generativelanguage.googleapis.com/v1beta/interactions" \
      -H "x-goog-api-key: $GEMINI_API_KEY" \
      -H 'Content-Type: application/json' \
      -d "{
        \"model\": \"gemini-3.5-flash\",
        \"store\": false,
        \"input\": $HISTORY,
        \"tools\": [{
          \"type\": \"function\",
          \"name\": \"get_current_temperature\",
          \"description\": \"Gets the current temperature for a given location.\",
          \"parameters\": {
            \"type\": \"object\",
            \"properties\": {
              \"location\": {\"type\": \"string\", \"description\": \"The city name\"}
            },
            \"required\": [\"location\"]
          }
        }]
      }"

**Response:**

During Turn 1, the model returns a response with status `requires_action` and the `function_call` step:

    {
      "id": "v1_Chd...",
      "status": "requires_action",
      "steps": [
        {
          "type": "function_call",
          "id": "call_abc123",
          "name": "get_current_temperature",
          "arguments": {
            "location": "London"
          }
        }
      ],
      "object": "interaction",
      "model": "gemini-3.5-flash"
    }

After you run the function locally and submit the result (Turn 2), the final completed interaction returns:

    {
      "id": "v1_Chd...",
      "status": "completed",
      "steps": [
        {
          "type": "function_call",
          "id": "call_abc123",
          "name": "get_current_temperature",
          "arguments": {
            "location": "London"
          }
        },
        {
          "type": "model_output",
          "content": [
            {
              "type": "text",
              "text": "The temperature in London is currently 22°C."
            }
          ]
        }
      ],
      "object": "interaction",
      "model": "gemini-3.5-flash",
    }

For advanced features like parallel function calling or function choice modes, see the [function calling guide](https://ai.google.dev/gemini-api/docs/function-calling).

## 10. Run a managed agent

Managed agents run in a remote sandbox with access to tools like code execution and file management. Pass an `agent` instead of a `model` and set `environment="remote"`.

### Python

    from google import genai

    client = genai.Client()

    interaction = client.interactions.create(
        agent="antigravity-preview-05-2026",
        input="Write a Python script that generates the first 20 Fibonacci numbers and saves them to fibonacci.txt. Then read the file and print its contents.",
        environment="remote",
    )
    print(f"Environment: {interaction.environment_id}")
    print(interaction.output_text)

### JavaScript

    import { GoogleGenAI } from "@google/genai";

    const ai = new GoogleGenAI({});

    const interaction = await ai.interactions.create({
      agent: "antigravity-preview-05-2026",
      input: "Write a Python script that generates the first 20 Fibonacci numbers and saves them to fibonacci.txt. Then read the file and print its contents.",
      environment: "remote",
    });
    console.log(`Environment: ${interaction.environment_id}`);
    console.log(interaction.output_text);

### REST

    curl -X POST "https://generativelanguage.googleapis.com/v1beta/interactions" \
      -H "x-goog-api-key: $GEMINI_API_KEY" \
      -H 'Content-Type: application/json' \
      -d '{
        "agent": "antigravity-preview-05-2026",
        "input": "Write a Python script that generates the first 20 Fibonacci numbers and saves them to fibonacci.txt. Then read the file and print its contents.",
        "environment": "remote"
      }'

You can also define and save [custom agents](https://ai.google.dev/gemini-api/docs/custom-agents) with your own instructions, skills, and data sources.
[Quickstart
Make your first agent call, stream responses, and build a custom agent.](https://ai.google.dev/gemini-api/docs/managed-agents-quickstart) [Antigravity Agent
Capabilities, tools, multimodal input, and pricing for the default agent.](https://ai.google.dev/gemini-api/docs/antigravity-agent) [Agents in AI Studio
Visual playground for prototyping agents without writing code.](https://ai.google.dev/gemini-api/docs/aistudio-agents)

## 11. Run tasks in the background

Set `background=True` to run long tasks asynchronously. Poll for results with `interactions.get()`.

### Python

    import time
    from google import genai

    client = genai.Client()

    interaction = client.interactions.create(
        model="gemini-3.5-flash",
        input="Write a detailed analysis of the impact of artificial intelligence on modern healthcare.",
        background=True,
    )
    print(f"Started background task: {interaction.id}")
    print(f"Status: {interaction.status}")

    # Poll for completion
    while True:
        result = client.interactions.get(interaction.id)
        print(f"Status: {result.status}")
        if result.status == "completed":
            print(f"\nResult:\n{result.output_text}")
            break
        elif result.status == "failed":
            print(f"Failed: {result.error}")
            break
        time.sleep(5)

### JavaScript

    import { GoogleGenAI } from "@google/genai";

    const ai = new GoogleGenAI({});

    const interaction = await ai.interactions.create({
      model: "gemini-3.5-flash",
      input: "Write a detailed analysis of the impact of artificial intelligence on modern healthcare.",
      background: true,
    });
    console.log(`Started background task: ${interaction.id}`);
    console.log(`Status: ${interaction.status}`);

    // Poll for completion
    while (true) {
      const result = await ai.interactions.get(interaction.id);
      console.log(`Status: ${result.status}`);
      if (result.status === "completed") {
        console.log(`\nResult:\n${result.output_text}`);
        break;
      } else if (result.status === "failed") {
        console.log(`Failed: ${result.error}`);
        break;
      }
      await new Promise(r => setTimeout(r, 5000));
    }

### REST

    # Start a background task
    RESPONSE=$(curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/interactions" \
      -H "x-goog-api-key: $GEMINI_API_KEY" \
      -H 'Content-Type: application/json' \
      -d '{
        "model": "gemini-3.5-flash",
        "input": "Write a detailed analysis of the impact of artificial intelligence on modern healthcare.",
        "background": true
      }')

    INTERACTION_ID=$(echo "$RESPONSE" | jq -r '.id')
    echo "Started background task: $INTERACTION_ID"

    # Poll for completion
    while true; do
      RESULT=$(curl -s "https://generativelanguage.googleapis.com/v1beta/interactions/$INTERACTION_ID" \
        -H "x-goog-api-key: $GEMINI_API_KEY" \
        -H "Api-Revision: 2026-05-20")
      STATUS=$(echo "$RESULT" | jq -r '.status')
      echo "Status: $STATUS"
      if [ "$STATUS" = "completed" ]; then
        echo "$RESULT" | jq -r '.steps[] | select(.type=="model_output") | .content[] | select(.type=="text") | .text'
        break
      elif [ "$STATUS" = "failed" ]; then
        echo "Failed"
        break
      fi
      sleep 5
    done

**Response:**

The initial response returns immediately with status `in_progress`:

    {
      "id": "v1_abc123",
      "status": "in_progress",
      "object": "interaction",
      "model": "gemini-3.5-flash"
    }

Once the background task is fully executed, checking the interaction state returns:

    {
      "id": "v1_abc123",
      "status": "completed",
      "steps": [
        {
          "type": "model_output",
          "content": [
            {
              "type": "text",
              "text": "Artificial intelligence has transformed modern healthcare in several..."
            }
          ]
        }
      ],
      "object": "interaction",
      "model": "gemini-3.5-flash",
    }

Read about running models and agents asynchronously in the [background execution guide](https://ai.google.dev/gemini-api/docs/interactions-overview#background-execution).

## What's next

- [Text generation](https://ai.google.dev/gemini-api/docs/text-generation): System instructions, generation config, and advanced text patterns.
- [Image generation](https://ai.google.dev/gemini-api/docs/image-generation): Aspect ratios, image editing, and style references.
- [Image understanding](https://ai.google.dev/gemini-api/docs/image-understanding): Classification, object detection, and visual Q\&A.
- [Thinking](https://ai.google.dev/gemini-api/docs/thinking): Use chain-of-thought reasoning for complex tasks.
- [Function calling](https://ai.google.dev/gemini-api/docs/function-calling): Parallel, compositional, and constrained function modes.
- [Google Search](https://ai.google.dev/gemini-api/docs/google-search): Grounding, citations, and search suggestions.
- [Managed Agents](https://ai.google.dev/gemini-api/docs/managed-agents-quickstart): Pre-built agents with code execution and file management.
- [Deep Research](https://ai.google.dev/gemini-api/docs/deep-research): Autonomous multi-step research with planning and synthesis.
- [Structured output](https://ai.google.dev/gemini-api/docs/structured-output): JSON schemas, enums, and recursive type definitions.


# Interactions API

The Interactions API is our new interface and the most straightforward way
to build with Gemini models and agents. As of June 2026, it is Generally
Available and the recommended interface for all new projects.

While it is now considered legacy, the original
[`generateContent`](https://ai.google.dev/gemini-api/docs/generate-content/text-generation) API
remains fully supported.

## Why use the Interactions API?

- **New capabilities out of the box** : Optional server-side conversation state using `previous_interaction_id`, observable execution steps for debugging and UI rendering, and background execution for long-running tasks using `background=true`.
- **Lower cost with higher cache hit rates**: Server-side state management enables more efficient context caching across turns, reducing token costs for multi-turn conversations.
- **Built for frontier models and agents**: Purpose-built for thinking models, multi-step tool use, and complex reasoning flows --- simplifying the process of building, debugging, and orchestrating agentic applications.
- **Single API for models and agents**: One unified interface for calling Gemini models and agents directly such as Deep Research and custom managed agents --- no separate endpoints or patterns to learn.
- **Where new things launch**: Going forward, new models and capabilities beyond the core mainline family, along with new agentic capabilities and tools, will launch on the Interactions API.

By default, the Interactions API stores requests so you can leverage
the server-side state management features by using
`previous_interaction_id`. You can opt into stateless behavior by setting
`store=false`. See the [data retention](https://ai.google.dev/gemini-api/docs/interactions-overview#data-storage-retention) section for
details.

## Get started

- **Set up your coding agent** : Connect to the **Gemini Docs MCP** and install the `gemini-interactions-api` skill to give your assistant direct access to the latest developer docs and best practices. [Set up your coding agent →](https://ai.google.dev/gemini-api/docs/coding-agents)
- **Migrate from `generateContent`** : If you have an existing integration, follow the [Migration Guide](https://ai.google.dev/gemini-api/docs/migrate-to-interactions) to transition to the Interactions API.
- **Get started** : Get started in the [Interactions API Get started
  guide](https://ai.google.dev/gemini-api/docs/get-started).

### Feature Guides

Explore the specific capabilities of the Interactions API through these guides. You can use the toggle on these pages to switch between generateContent and Interactions API:

- [Text generation](https://ai.google.dev/gemini-api/docs/text-generation)
- [Image generation](https://ai.google.dev/gemini-api/docs/image-generation)
- [Image understanding](https://ai.google.dev/gemini-api/docs/image-understanding)
- [Audio understanding](https://ai.google.dev/gemini-api/docs/audio)
- [Video understanding](https://ai.google.dev/gemini-api/docs/video-understanding)
- [Document processing](https://ai.google.dev/gemini-api/docs/document-processing)
- [Function calling](https://ai.google.dev/gemini-api/docs/function-calling)
- [Structured output](https://ai.google.dev/gemini-api/docs/structured-output)
- [Deep Research Agent](https://ai.google.dev/gemini-api/docs/deep-research)
- [Flex inference](https://ai.google.dev/gemini-api/docs/flex-inference)
- [Priority inference](https://ai.google.dev/gemini-api/docs/priority-inference)

## How the Interactions API works

The Interactions API centers around a core resource: the [**`Interaction`**](https://ai.google.dev/api/interactions-api#Resource:Interaction). An `Interaction` represents a complete turn in a conversation or task. It acts as a session record, containing the entire history of an interaction as a chronological sequence of **execution steps** . These steps include model thoughts, server-side or client-side tool calls and results (like `function_call` and `function_result`), and the final `model_output`. The stored resource (retrieved via `interactions.get`) also includes `user_input` steps for full context, though the `interactions.create` response only returns model-generated steps.

When you make a call to
[`interactions.create`](https://ai.google.dev/api/interactions-api#CreateInteraction), you are
creating a new `Interaction` resource.

### Server-side state management

You can use the `id` of a completed interaction in a subsequent call using the
`previous_interaction_id` parameter to continue the conversation. The server
uses this ID to retrieve the conversation history, saving you from having to
resend the entire chat history.

The `previous_interaction_id` parameter preserves only the conversation history (inputs and outputs)
using `previous_interaction_id`. The other parameters are **interaction-scoped**
and apply only to the specific interaction you are currently generating:

- `tools`
- `system_instruction`
- `generation_config` (including `thinking_level`, `temperature`, etc.)

This means you must re-specify these parameters in each new interaction if you
want them to apply. This server-side state management is optional; you can also
operate in stateless mode by sending the full conversation history in each
request.

### Data storage and retention

By default, the API stores all Interaction objects (`store=true`) in order to
simplify use of server-side state management features (with
`previous_interaction_id`), background execution (using `background=true`) and
observability purposes.

- **Paid Tier** : The system retains interactions for **55 days**.
- **Free Tier** : The system retains interactions for **1 day**.

If you don't want this, you can
set `store=false` in your request. This control is separate from state
management; you can opt out of storage for any interaction. However, note that
`store=false` is incompatible with `background=true` and prevents using
`previous_interaction_id` for subsequent turns.

You can delete stored interactions at any time using the delete method found in
the [API Reference](https://ai.google.dev/api/interactions-api). You can only delete interactions if
you know the interaction ID.

After the retention period expires, your data will be
deleted automatically.

The system processes Interaction objects according to the [terms](https://ai.google.dev/gemini-api/terms).

## Best practices

- **Cache hit rate** : Using `previous_interaction_id` to continue conversations allows the system to more easily utilize implicit caching for the conversation history, which improves performance and reduces costs.
- **Mixing interactions** : You have the flexibility to mix and match Agent and Model interactions within a conversation. For example, you can use a specialized agent, like the Deep Research agent, for initial data collection, and then use a standard Gemini model for follow-up tasks such as summarizing or reformatting, linking these steps with the `previous_interaction_id`.

## Supported models \& agents

| Model Name | Type | Model ID |
|---|---|---|
| Gemini 3.1 Flash-Lite | Model | `gemini-3.1-flash-lite` |
| Gemini 3.1 Flash-Lite Preview | Model | `gemini-3.1-flash-lite-preview` |
| Gemini 3.1 Pro Preview | Model | `gemini-3.1-pro-preview` |
| Gemini 3 Flash Preview | Model | `gemini-3-flash-preview` |
| Gemini 2.5 Pro | Model | `gemini-2.5-pro` |
| Gemini 2.5 Flash | Model | `gemini-2.5-flash` |
| Gemini 2.5 Flash-lite | Model | `gemini-2.5-flash-lite` |
| Lyria 3 Clip Preview | Model | `lyria-3-clip-preview` |
| Lyria 3 Pro Preview | Model | `lyria-3-pro-preview` |
| Deep Research Preview | Agent | `deep-research-pro-preview-12-2025` |
| Deep Research Preview | Agent | `deep-research-preview-04-2026` |
| Deep Research Preview | Agent | `deep-research-max-preview-04-2026` |
| Antigravity Preview | Agent | `antigravity-preview-05-2026` |

## SDKs

You can use latest version of the Google GenAI SDKs in order to access
Interactions API.

- On Python, this is `google-genai` package from `1.55.0` version onwards.
- On JavaScript, this is `@google/genai` package from `1.33.0` version onwards.

You can learn more about how to install the SDKs on
[Libraries](https://ai.google.dev/gemini-api/docs/libraries) page.

## Limitations

- **Remote MCP**: Gemini 3 does not support remote MCP, this is coming soon.

The following features are supported by the
[`generateContent`](https://ai.google.dev/gemini-api/docs/generate-content/text-generation) API but are **not yet
available** in the Interactions API:

- **[Video metadata](https://ai.google.dev/gemini-api/docs/video-understanding)** : The `video_metadata` field, used to set clipping intervals and custom frame rates for video understanding.
- **[Batch API](https://ai.google.dev/gemini-api/docs/batch-api)**
- **[Automatic function calling (Python)](https://ai.google.dev/gemini-api/docs/function-calling?example=meeting#automatic_function_calling_python_only)**
- **[Explicit caching](https://ai.google.dev/gemini-api/docs/caching)** : Note that server-side implicit caching is available in the Interactions API via `previous_interaction_id`.

## Feedback

Your feedback is critical to the development of the Interactions API.
Share your thoughts, report bugs, or request features on our
[Google AI Developer Community Forum](https://discuss.ai.google.dev/c/gemini-api/4).

## What's next

- Try the [Interactions API quickstart notebook](https://colab.sandbox.google.com/github/google-gemini/cookbook/blob/main/quickstarts/Get_started_interactions_api.ipynb).
- Learn more about the [Gemini Deep Research Agent](https://ai.google.dev/gemini-api/docs/deep-research).
