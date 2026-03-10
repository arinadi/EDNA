# Mei Hatsume — Coding Agent
> **"If a problem exists, build something to solve it!"**

Mei Hatsume is an energetic, high-performance coding agent designed for **reliability over speed**. This agent is highly opinionated and disciplined, specifically built for environments without Language Server Protocol (LSP) support (e.g., CLI-only or restricted MCP environments).

---

## 🚀 Key Advantages

### 1. Sharp Planning vs. Slower Loops
In a No-LSP environment, guessing is dangerous. Mei compensates for the lack of real-time feedback with **obsessive planning** and **explicit verification**. Every change is validated through dedicated commands, ensuring the code works the first time.

### 2. Zero Context Amnesia
Most agents lose track of the big picture as tokens fill up with logs. Mei solves this with:
*   **Atomic Context**: Auto-managed snippets that split off when they get too heavy.
*   **Code-as-Memory**: The code itself, enriched with inline comments, serves as the cross-session memory—no redundant log files to clutter the context window.

### 3. The "STOP" Protocol
Mei is trained to detect ambiguity. Instead of guessing your intent, she will **STOP** and present you with a list of interpretations. This prevents "buggy inventions" and saves you time and tokens.

---

## 🛠️ Performance Features

*   **Task Tiers**: Optimized workflows from **Nano** (quick 1-liners) to **Full** (massive architectural changes).
*   **Atomic Context Management**: Auto-triggers a context split whenever `conventions.md` exceeds 150 tokens.
*   **Multi-Gate Acceptance**: A sequential verification process (Lint → Build → Test → Security → User) that ensures every "baby" is battle-ready.
*   **No-LSP Compensation**: Built-in logic for manual type-checking, import resolution, and impact analysis via `grep` and `search_files`.

---

## 🔌 MCP Setup Guide

To give Mei the specialized tools she needs, add the following to your MCP settings file (e.g., `claude_desktop_config.json` or your specialized agent config). 

> [!IMPORTANT]
> Change `C:/path/to/project` to your actual absolute directory path!

```json
{
  "mcpServers": {
    "filesystem": { 
      "command": "npx", 
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "C:/path/to/project"] 
    },
    "git": { 
      "command": "uvx", 
      "args": ["mcp-server-git", "--repository", "C:/path/to/project"] 
    },
    "shell": { 
      "command": "uvx", 
      "args": ["mcp-shell-server"],
      "env": { 
        "ALLOW_COMMANDS": "npm,npx,pnpm,yarn,node,python,pip,uv,uvx,git,make,grep,find,cat,ls,echo,touch,mkdir,cp,mv,diff" 
      } 
    },
    "fetch": { 
      "command": "uvx", 
      "args": ["mcp-server-fetch"] 
    },
    "serper": { 
      "command": "npx", 
      "args": ["-y", "serper-search-scrape-mcp-server"], 
      "env": { "SERPER_API_KEY": "YOUR_KEY" } 
    },
    "sequentialthinking": { 
      "command": "npx", 
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"] 
    }
  }
}
```

---

## 🔧 How to Use
1. Copy the contents of [agent.md](file:///mnt/DATA/EDNA/mei_hatsume_plan/agent.md) to your IDE's custom instruction file (`.gitlab/duo/chat-rules.md`, `.rules`, or `.roo/rules`).
2. Ensure your `agent/` directory is initialized.
3. Start building babies!
