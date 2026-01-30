---
name: kimi-k25
description: Use Kimi K2.5 API for code generation, vision-to-code, and agentic tasks. Triggers on Kimi, Moonshot AI, K2.5, cheap coding API, vision-to-code, video-to-code. Use when user wants to configure Kimi API, compare pricing with Claude/GPT, or leverage Kimi's multimodal coding capabilities.
---

# Kimi K2.5 Skill

Kimi K2.5 is Moonshot AI's open-source multimodal model with 1T parameters (32B active). Excels at coding, vision-to-code, and agentic tasks at a fraction of Claude/GPT costs.

## Quick Reference

### API Endpoints
- **Base URL:** `https://api.moonshot.ai/v1`
- **Models:** `kimi-k2.5` (instant), `kimi-k2.5-thinking` (reasoning)
- **Docs:** https://platform.moonshot.ai

### Pricing (per 1M tokens)
| Type | Cost |
|------|------|
| Input | $0.60 |
| Output | $2.50 |
| Cached | $0.15 |

**Comparison:** ~25x cheaper than Claude Opus, ~6x cheaper than Sonnet.

## Setup

### 1. Get API Key
1. Create account at https://platform.moonshot.ai
2. Navigate to API Keys section
3. Generate new key

### 2. Store Key (Clawdbot)
```bash
mkdir -p ~/.config/kimi
echo "YOUR_API_KEY" > ~/.config/kimi/api_key
chmod 600 ~/.config/kimi/api_key
```

### 3. Test Connection
```bash
curl -s https://api.moonshot.ai/v1/models \
  -H "Authorization: Bearer $(cat ~/.config/kimi/api_key)" | head -20
```

## Usage Patterns

### OpenAI-Compatible SDK (Python)
```python
from openai import OpenAI

client = OpenAI(
    api_key="YOUR_KIMI_KEY",
    base_url="https://api.moonshot.ai/v1"
)

# Instant mode (fast)
response = client.chat.completions.create(
    model="kimi-k2.5",
    messages=[{"role": "user", "content": "Write a React component"}],
    temperature=0.6
)

# Thinking mode (reasoning)
response = client.chat.completions.create(
    model="kimi-k2.5-thinking",
    messages=[{"role": "user", "content": "Solve this step by step"}],
    temperature=1.0
)
```

### Vision-to-Code (Unique Feature)
```python
import base64

# Encode image
with open("screenshot.png", "rb") as f:
    img_b64 = base64.b64encode(f.read()).decode()

response = client.chat.completions.create(
    model="kimi-k2.5",
    messages=[{
        "role": "user",
        "content": [
            {"type": "text", "text": "Recreate this UI in React + Tailwind"},
            {"type": "image_url", "image_url": {"url": f"data:image/png;base64,{img_b64}"}}
        ]
    }]
)
```

### cURL Example
```bash
curl -X POST https://api.moonshot.ai/v1/chat/completions \
  -H "Authorization: Bearer $(cat ~/.config/kimi/api_key)" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "kimi-k2.5",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

## IDE Integration

### Cursor
1. Settings → Models → Add Model
2. Provider: OpenAI Compatible
3. Base URL: `https://api.moonshot.ai/v1`
4. Model ID: `kimi-k2.5`
5. API Key: Your Kimi key

### VSCode (Continue Extension)
Add to `~/.continue/config.json`:
```json
{
  "models": [{
    "title": "Kimi K2.5",
    "provider": "openai",
    "model": "kimi-k2.5",
    "apiBase": "https://api.moonshot.ai/v1",
    "apiKey": "YOUR_KEY"
  }]
}
```

## Recommended Settings

| Mode | Temperature | Top_p | Use Case |
|------|-------------|-------|----------|
| Instant | 0.6 | 0.95 | Fast coding, simple tasks |
| Thinking | 1.0 | 0.95 | Complex reasoning, debugging |

## Strengths & Best Uses

✅ **Use Kimi for:**
- Bulk code generation (cheap)
- Vision-to-code / UI recreation
- Vibe coding sessions
- Parallel agent tasks (Agent Swarm)
- Video-to-code prototyping

⚠️ **Consider Claude/GPT for:**
- Nuanced writing/editing
- Complex multi-turn conversations
- Tasks requiring latest knowledge
- When you need tool use reliability

## Cost Calculator

Estimate monthly cost:
```
Daily requests × Avg tokens per request × 30 days × Price per token
```

Example (moderate coding use):
- 50 requests/day × 4K tokens avg × 30 = 6M tokens/month
- Cost: ~$5-10/month

Example (heavy vibe coding):
- 200 requests/day × 5K tokens × 30 = 30M tokens/month  
- Cost: ~$40-60/month
