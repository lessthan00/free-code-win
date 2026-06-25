## 首次调用 API
DeepSeek API 使用与 OpenAI/Anthropic 兼容的 API 格式，通过修改配置，您可以使用 OpenAI/Anthropic SDK 来访问 DeepSeek API，或使用与 OpenAI/Anthropic API 兼容的软件。

PARAM	VALUE
base_url (OpenAI)	https://api.deepseek.com
base_url (Anthropic)	https://api.deepseek.com/anthropic
api_key	apply for an API key
model*	deepseek-v4-flash
deepseek-v4-pro
deepseek-chat (将于 2026/07/24 弃用)
deepseek-reasoner (将于 2026/07/24 弃用)
* deepseek-chat 与 deepseek-reasoner 两个模型名将于北京时间 2026/07/24 23:59 弃用。出于兼容考虑，二者分别对应 deepseek-v4-flash 的非思考与思考模式。

接入 Agent 工具
DeepSeek API 已接入多种主流 AI Agent 与编程助手工具。如果你使用 Claude Code、GitHub Copilot、OpenCode 等工具，可以直接将 DeepSeek 作为后端模型，无需编写代码即可开始使用。

详见 Agent 工具接入指南。

调用对话 API
在创建 API key 之后，你可以使用以下样例脚本，通过 OpenAI API 格式来访问 DeepSeek 模型。样例为非流式输出，您可以将 stream 设置为 true 来使用流式输出。

curl
curl https://api.deepseek.com/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${DEEPSEEK_API_KEY}" \
  -d '{
        "model": "deepseek-v4-pro",
        "messages": [
          {"role": "system", "content": "You are a helpful assistant."},
          {"role": "user", "content": "Hello!"}
        ],
        "thinking": {"type": "enabled"},
        "reasoning_effort": "high",
        "stream": false
      }'




## Anthropic API
为了满足大家对 Anthropic API 生态的使用需求，我们的 API 新增了对 Anthropic API 格式的支持，其 base_url 为 https://api.deepseek.com/anthropic。

通过简单的配置，即可将 DeepSeek 的能力，接入到 Anthropic API 生态中。

将 DeepSeek 模型接入 Claude Code
请参考接入 Agent 工具

通过 Anthropic API 调用 DeepSeek 模型
安装 Anthropic SDK
pip install anthropic

配置环境变量
export ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic
export ANTHROPIC_API_KEY=${YOUR_API_KEY}

调用 API
import anthropic

client = anthropic.Anthropic()

message = client.messages.create(
    model="deepseek-v4-pro",
    max_tokens=1000,
    system="You are a helpful assistant.",
    messages=[
        {
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": "Hi, how are you?"
                }
            ]
        }
    ]
)
print(message.content)

注意：当您给 DeepSeek 的 Anthropic API 传入不支持的模型名时，API 后端会自动将其映射到 deepseek-v4-flash 模型。

Anthropic 模型映射
您在使用 Anthropic API 时，我们会对您传入的 claude 模型名进行映射：

claude-opus 开头的模型，会映射到 deepseek-v4-pro
claude-haiku、claude-sonnet 开头的模型，会映射到 deepseek-v4-flash
通过这样的映射，您在使用新版 Claude Desktop APP 的 developer 模式时，可以绕过 APP 对模型名的限制，只需改动 base_url 和 api_key，即可在其中接入 DeepSeek 模型。

Anthropic API 兼容性细节
HTTP Header
Field	Support Status
anthropic-beta	Ignored
anthropic-version	Ignored
x-api-key	Fully Supported
Simple Fields
Field	Support Status
model	Use DeepSeek Model Instead
max_tokens	Fully Supported
container	Ignored
mcp_servers	Ignored
metadata	user_id is supported, others are ignored
Please refer to Rate Limit & Isolation for more information about user_id parameter.
service_tier	Ignored
stop_sequences	Fully Supported
stream	Fully Supported
system	Fully Supported
temperature	Fully Supported (range [0.0 ~ 2.0])
thinking	Supported (budget_tokens is ignored)
output_config	Only effort is supported
top_k	Ignored
top_p	Fully Supported
Tool Fields
tools
Field	Support Status
name	Fully Supported
input_schema	Fully Supported
description	Fully Supported
cache_control	Ignored
tool_choice
Value	Support Status
none	Fully Supported
auto	Supported (disable_parallel_tool_use is ignored)
any	Supported (disable_parallel_tool_use is ignored)
tool	Supported (disable_parallel_tool_use is ignored)
Message Fields
Field	Variant	Sub-Field	Support Status
content	string		Fully Supported
array, type="text"	text	Fully Supported
cache_control	Ignored
citations	Ignored
array, type="image"		Not Supported
array, type = "document"		Not Supported
array, type = "search_result"		Not Supported
array, type = "thinking"		Supported
array, type="redacted_thinking"		Not Supported
array, type = "tool_use"	id	Fully Supported
input	Fully Supported
name	Fully Supported
cache_control	Ignored
array, type = "tool_result"	tool_use_id	Fully Supported
content	Fully Supported
cache_control	Ignored
is_error	Ignored
array, type = "server_tool_use"		Supported
array, type = "web_search_tool_result"		Supported
array, type = "code_execution_tool_result"		Not Supported
array, type = "mcp_tool_use"		Not Supported
array, type = "mcp_tool_result"		Not Supported
array, type = "container_upload"		Not Supported



## 思考模式
思考模式
DeepSeek 模型支持思考模式：在输出最终回答之前，模型会先输出一段思维链内容，以提升最终答案的准确性。

思考模式开关与思考强度控制
控制参数（OpenAI 格式）	控制参数（Anthropic 格式）
思考模式开关(1)	{"thinking": {"type": "enabled/disabled"}}
思考强度控制(2)(3)	{"reasoning_effort": "high/max"}	{"output_config": {"effort": "high/max"}}
(1) 默认思考开关为 enabled
(2) 思考模式下，对普通请求，默认 effort 为 high；对一些复杂 Agent 类请求（如 Claude Code、OpenCode），effort 自动设置为 max
(3) 思考模式下，出于兼容考虑 low、medium 会映射为 high, xhigh 会映射为 max

您在使用 OpenAI SDK 设置 thinking 参数时，需要将 thinking 参数传入 extra_body 中：

response = client.chat.completions.create(
  model="deepseek-v4-pro",
  # ...
  reasoning_effort="high",
  extra_body={"thinking": {"type": "enabled"}}
)

输入输出参数
思考模式不支持 temperature、top_p、presence_penalty、frequency_penalty 参数。请注意，为了兼容已有软件，设置参数不会报错，但也不会生效。

在思考模式下，思维链内容通过 reasoning_content 参数返回，与 content 同级。在后续的轮次的拼接中，可以选择性地返回 reasoning_content 给 API：

在两个 user 消息之间，如果模型未进行工具调用，则中间 assistant 的 reasoning_content 无需参与上下文拼接，在后续轮次中将其传入 API 会被忽略。详见多轮对话拼接。
在两个 user 消息之间，如果模型进行了工具调用，则中间 assistant 的 reasoning_content 需参与上下文拼接，在后续所有 user 交互轮次中必须回传给 API。详见工具调用。
多轮对话拼接
在每一轮对话过程中，模型会输出思维链内容（reasoning_content）和最终回答（content）。如果没有工具调用，则在下一轮对话中，之前轮输出的思维链内容不会被拼接到上下文中，如下图所示：


样例代码
下面的代码以 Python 语言为例，展示了如何访问思维链和最终回答，以及如何在多轮对话中进行上下文拼接。

非流式
流式
from openai import OpenAI
client = OpenAI(api_key="<DeepSeek API Key>", base_url="https://api.deepseek.com")

### Turn 1
messages = [{"role": "user", "content": "9.11 and 9.8, which is greater?"}]
response = client.chat.completions.create(
    model="deepseek-v4-pro",
    messages=messages,
    reasoning_effort="high"
    extra_body={"thinking": {"type": "enabled"}},
)

reasoning_content = response.choices[0].message.reasoning_content
content = response.choices[0].message.content

### Turn 2
### The reasoning_content will be ignored by the API
messages.append(response.choices[0].message)
messages.append({'role': 'user', 'content': "How many Rs are there in the word 'strawberry'?"})
response = client.chat.completions.create(
    model="deepseek-v4-pro",
    messages=messages,
    reasoning_effort="high"
    extra_body={"thinking": {"type": "enabled"}},
)
### ...

工具调用
DeepSeek 模型的思考模式支持工具调用功能。模型在输出最终答案之前，可以进行多轮的思考与工具调用，以提升答案的质量。其调用模式如下图所示：


请注意，区别于思考模式下的未进行工具调用的轮次，进行了工具调用的轮次，在后续所有请求中，必须完整回传 reasoning_content 给 API。

若您的代码中未正确回传 reasoning_content，API 会返回 400 报错。正确回传方法请您参考下面的样例代码。

样例代码
下面是一个简单的在思考模式下进行工具调用的样例代码：

import os
import json
from openai import OpenAI
from datetime import datetime

### The definition of the tools
tools = [
    {
        "type": "function",
        "function": {
            "name": "get_date",
            "description": "Get the current date",
            "parameters": { "type": "object", "properties": {} },
        }
    },
    {
        "type": "function",
        "function": {
            "name": "get_weather",
            "description": "Get weather of a location, the user should supply the location and date.",
            "parameters": {
                "type": "object",
                "properties": {
                    "location": { "type": "string", "description": "The city name" },
                    "date": { "type": "string", "description": "The date in format YYYY-mm-dd" },
                },
                "required": ["location", "date"]
            },
        }
    },
]

### The mocked version of the tool calls
def get_date_mock():
    return datetime.now().strftime("%Y-%m-%d")

def get_weather_mock(location, date):
    return "Cloudy 7~13°C"

TOOL_CALL_MAP = {
    "get_date": get_date_mock,
    "get_weather": get_weather_mock
}

def run_turn(turn, messages):
    sub_turn = 1
    while True:
        response = client.chat.completions.create(
            model='deepseek-v4-pro',
            messages=messages,
            tools=tools,
            reasoning_effort="high",
            extra_body={ "thinking": { "type": "enabled" } },
        )
        messages.append(response.choices[0].message)
        reasoning_content = response.choices[0].message.reasoning_content
        content = response.choices[0].message.content
        tool_calls = response.choices[0].message.tool_calls
        print(f"Turn {turn}.{sub_turn}\n{reasoning_content=}\n{content=}\n{tool_calls=}")
        # If there is no tool calls, then the model should get a final answer and we need to stop the loop
        if tool_calls is None:
            break
        for tool in tool_calls:
            tool_function = TOOL_CALL_MAP[tool.function.name]
            tool_result = tool_function(**json.loads(tool.function.arguments))
            print(f"tool result for {tool.function.name}: {tool_result}\n")
            messages.append({
                "role": "tool",
                "tool_call_id": tool.id,
                "content": tool_result,
            })
        sub_turn += 1
    print()

client = OpenAI(
    api_key=os.environ.get('DEEPSEEK_API_KEY'),
    base_url=os.environ.get('DEEPSEEK_BASE_URL'),
)

### The user starts a question
turn = 1
messages = [{
    "role": "user",
    "content": "How's the weather in Hangzhou Tomorrow"
}]
run_turn(turn, messages)

### The user starts a new question
turn = 2
messages.append({
    "role": "user",
    "content": "How's the weather in Guangzhou Tomorrow"
})
run_turn(turn, messages)


在 Turn 1 的每个子请求中，都携带了该 Turn 下产生的 reasoning_content 给 API，从而让模型继续之前的思考。response.choices[0].message 携带了 assistant 消息的所有必要字段，包括 content、reasoning_content、tool_calls。简单起见，可以直接用如下代码将消息 append 到 messages 结尾：

messages.append(response.choices[0].message)

这行代码等价于：

messages.append({
    'role': 'assistant',
    'content': response.choices[0].message.content,
    'reasoning_content': response.choices[0].message.reasoning_content,
    'tool_calls': response.choices[0].message.tool_calls,
})

且在 Turn 2 的请求中，我们仍然携带着 Turn1 所产生的 reasoning_content 给 API。

该代码的样例输出如下：

Turn 1.1
reasoning_content="The user is asking about the weather in Hangzhou tomorrow. I need to get tomorrow's date first, then call the weather function."
content="Let me check tomorrow's weather in Hangzhou for you. First, let me get tomorrow's date."
tool_calls=[ChatCompletionMessageFunctionToolCall(id='call_00_kw66qNnNto11bSfJVIdlV5Oo', function=Function(arguments='{}', name='get_date'), type='function', index=0)]
tool result for get_date: 2026-04-19

Turn 1.2
reasoning_content="Today is 2026-04-19, so tomorrow is 2026-04-20. Now I'll call the weather function for Hangzhou."
content=''
tool_calls=[ChatCompletionMessageFunctionToolCall(id='call_00_H2SCW6136vWJGq9SQlBuhVt4', function=Function(arguments='{"location": "Hangzhou", "date": "2026-04-20"}', name='get_weather'), type='function', index=0)]
tool result for get_weather: Cloudy 7~13°C

Turn 1.3
reasoning_content='The weather result is in. Let me share this with the user.'
content="Here's the weather forecast for **Hangzhou tomorrow (April 20, 2026)**:\n\n- 🌤 **Condition:** Cloudy  \n- 🌡 **Temperature:** 7°C ~ 13°C (45°F ~ 55°F)\n\nIt'll be on the cooler side, so you might want to bring a light jacket if you're heading out! Let me know if you need anything else."
tool_calls=None

Turn 2.1
reasoning_content='The user is asking about the weather in Guangzhou tomorrow. Today is 2026-04-19, so tomorrow is 2026-04-20. I can directly call the weather function.'
content=''
tool_calls=[ChatCompletionMessageFunctionToolCall(id='call_00_8URkLt5NjmNkVKhDmMcNq9Mo', function=Function(arguments='{"location": "Guangzhou", "date": "2026-04-20"}', name='get_weather'), type='function', index=0)]
tool result for get_weather: Cloudy 7~13°C

Turn 2.2
reasoning_content='The weather result for Guangzhou is the same as Hangzhou. Let me share this with the user.'
content="Here's the weather forecast for **Guangzhou tomorrow (April 20, 2026)**:\n\n- 🌤 **Condition:** Cloudy  \n- 🌡 **Temperature:** 7°C ~ 13°C (45°F ~ 55°F)\n\nIt'll be cool and cloudy, so a light jacket would be a good idea if you're going out. Let me know if there's anything else you'd like to know!"
tool_calls=None


## 多轮对话
本指南将介绍如何使用 DeepSeek /chat/completions API 进行多轮对话。

DeepSeek /chat/completions API 是一个“无状态” API，即服务端不记录用户请求的上下文，用户在每次请求时，需将之前所有对话历史拼接好后，传递给对话 API。

下面的代码以 Python 语言，展示了如何进行上下文拼接，以实现多轮对话。

from openai import OpenAI
client = OpenAI(api_key="<DeepSeek API Key>", base_url="https://api.deepseek.com")

### Round 1
messages = [{"role": "user", "content": "What's the highest mountain in the world?"}]
response = client.chat.completions.create(
    model="deepseek-v4-pro",
    messages=messages
)

messages.append(response.choices[0].message)
print(f"Messages Round 1: {messages}")

### Round 2
messages.append({"role": "user", "content": "What is the second?"})
response = client.chat.completions.create(
    model="deepseek-v4-pro",
    messages=messages
)

messages.append(response.choices[0].message)
print(f"Messages Round 2: {messages}")

在第一轮请求时，传递给 API 的 messages 为：

[
    {"role": "user", "content": "What's the highest mountain in the world?"}
]

在第二轮请求时：

要将第一轮中模型的输出添加到 messages 末尾
将新的提问添加到 messages 末尾
最终传递给 API 的 messages 为：

[
    {"role": "user", "content": "What's the highest mountain in the world?"},
    {"role": "assistant", "content": "The highest mountain in the world is Mount Everest."},
    {"role": "user", "content": "What is the second?"}
]

## 接入claudcode
Claude Code 是一个运行在终端内的 AI 编程助手。

从现有安装中迁移到 DeepSeek
如果你已经安装了 Claude Code，只需修改以下环境变量，其中 API Key 在 DeepSeek Platform 获取。

Linux / Mac 用户，直接在终端中执行：

export ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic
export ANTHROPIC_AUTH_TOKEN=<你的 DeepSeek API Key>
export ANTHROPIC_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_OPUS_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_SONNET_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_HAIKU_MODEL=deepseek-v4-flash
export CLAUDE_CODE_SUBAGENT_MODEL=deepseek-v4-flash
export CLAUDE_CODE_EFFORT_LEVEL=max

Windows 用户，在 Powershell 中执行：

$env:ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic"
$env:ANTHROPIC_AUTH_TOKEN="<你的 DeepSeek API Key>"
$env:ANTHROPIC_MODEL="deepseek-v4-pro[1m]"
$env:ANTHROPIC_DEFAULT_OPUS_MODEL="deepseek-v4-pro[1m]"
$env:ANTHROPIC_DEFAULT_SONNET_MODEL="deepseek-v4-pro[1m]"
$env:ANTHROPIC_DEFAULT_HAIKU_MODEL="deepseek-v4-flash"
$env:CLAUDE_CODE_SUBAGENT_MODEL="deepseek-v4-flash"
$env:CLAUDE_CODE_EFFORT_LEVEL="max"

配置完成后，执行（其中 /path/to/my-project 替换为你的项目路径）：

cd /path/to/my-project
claude

从零安装 Claude Code
1. 安装 Claude Code
安装 Node.js 18+。
Windows 用户需安装 Git for Windows。
在命令行界面，执行以下命令安装 Claude Code：
npm install -g @anthropic-ai/claude-code

安装结束后，执行以下命令，若显示版本号则安装成功：
claude --version

2. 配置环境变量
Linux / Mac 用户执行以下命令配置 DeepSeek Anthropic API 环境变量，其中 API Key 在 DeepSeek Platform 获取：

export ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic
export ANTHROPIC_AUTH_TOKEN=<你的 DeepSeek API Key>
export ANTHROPIC_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_OPUS_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_SONNET_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_HAIKU_MODEL=deepseek-v4-flash
export CLAUDE_CODE_SUBAGENT_MODEL=deepseek-v4-flash
export CLAUDE_CODE_EFFORT_LEVEL=max

Windows 用户执行：

$env:ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic"
$env:ANTHROPIC_AUTH_TOKEN="<你的 DeepSeek API Key>"
$env:ANTHROPIC_MODEL="deepseek-v4-pro[1m]"
$env:ANTHROPIC_DEFAULT_OPUS_MODEL="deepseek-v4-pro[1m]"
$env:ANTHROPIC_DEFAULT_SONNET_MODEL="deepseek-v4-pro[1m]"
$env:ANTHROPIC_DEFAULT_HAIKU_MODEL="deepseek-v4-flash"
$env:CLAUDE_CODE_SUBAGENT_MODEL="deepseek-v4-flash"
$env:CLAUDE_CODE_EFFORT_LEVEL="max"

3. 进入项目目录，执行 claude 命令，即可开始使用了。
cd /path/to/my-project
claude


使用 Claude Code 的 Web Search 功能
DeepSeek API 原生支持 Claude Code 中的 Web Search 功能。在使用 Claude Code 的过程中，如果模型判断您的问题需要通过搜索功能才能满足，模型会调用 Web Search 工具，并通过 DeepSeek 提供的 API 进行搜索。因为调用 Web Search 工具会产生额外的大模型 API 请求来对获取到的搜索内容进行总结，因此会产生额外的模型 Token 费用。

下图展示了在 Claude Code 中触发 Web Search 功能的示例，用户的提问（Help me to search for best Rust tutorials）触发了 Web Search 工具的调用：


使用 Claude Code 或者 Claude Desktop APP 时的模型映射
您在使用 Claude Code 或者 Claude Desktop APP 时，我们会对您传入的 claude 模型名进行映射：

claude-opus 开头的模型，会映射到 deepseek-v4-pro
claude-haiku、claude-sonnet 开头的模型，会映射到 deepseek-v4-flash
通过这样的映射，您在使用新版 Claude Desktop APP 的 developer 模式时，可以绕过 APP 对模型名的限制，只需改动 base_url 和 api_key，即可在其中接入 DeepSeek 模型。
