#!/bin/bash
# Kimi K2.5 API Setup Script

set -e

CONFIG_DIR="$HOME/.config/kimi"
KEY_FILE="$CONFIG_DIR/api_key"

echo "🌙 Kimi K2.5 Setup"
echo "=================="
echo ""

# Create config directory
mkdir -p "$CONFIG_DIR"

# Check if key already exists
if [ -f "$KEY_FILE" ]; then
    echo "⚠️  API key already exists at $KEY_FILE"
    read -p "Overwrite? (y/N): " overwrite
    if [ "$overwrite" != "y" ] && [ "$overwrite" != "Y" ]; then
        echo "Keeping existing key."
        exit 0
    fi
fi

# Get API key
echo ""
echo "Get your API key from: https://platform.moonshot.ai"
echo ""
read -p "Enter your Kimi API key: " api_key

if [ -z "$api_key" ]; then
    echo "❌ No API key provided. Exiting."
    exit 1
fi

# Save key
echo "$api_key" > "$KEY_FILE"
chmod 600 "$KEY_FILE"
echo ""
echo "✅ API key saved to $KEY_FILE"

# Test connection
echo ""
echo "Testing connection..."
response=$(curl -s -w "%{http_code}" -o /tmp/kimi_test.json \
    https://api.moonshot.ai/v1/models \
    -H "Authorization: Bearer $api_key")

if [ "$response" = "200" ]; then
    echo "✅ Connection successful!"
    echo ""
    echo "Available models:"
    cat /tmp/kimi_test.json | grep -o '"id":"[^"]*"' | head -5 | sed 's/"id":"/ - /g' | sed 's/"//g'
else
    echo "❌ Connection failed (HTTP $response)"
    echo "Check your API key and try again."
    cat /tmp/kimi_test.json
    exit 1
fi

rm -f /tmp/kimi_test.json

echo ""
echo "🎉 Setup complete! You can now use Kimi K2.5."
echo ""
echo "Quick test:"
echo "  curl -X POST https://api.moonshot.ai/v1/chat/completions \\"
echo "    -H \"Authorization: Bearer \$(cat ~/.config/kimi/api_key)\" \\"
echo "    -H \"Content-Type: application/json\" \\"
echo "    -d '{\"model\":\"kimi-k2.5\",\"messages\":[{\"role\":\"user\",\"content\":\"Hello!\"}]}'"
