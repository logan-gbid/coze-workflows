# Coze Workflows

A collection of Coze workflows for video processing and content rewriting tasks.

## Structure

```
coze-workflows/
├── workflows/           # Workflow JSON files (original + sanitized versions)
│   ├── RewriteFlow.json              # Original with real IDs
│   ├── sanitized_RewriteFlow.json     # Sanitized version for sharing
│   ├── VideoPipeline.json            # Original with real IDs
│   └── sanitized_VideoPipeline.json # Sanitized version for sharing
├── images/             # Workflow screenshots
├── .gitignore
├── .env.example        # Environment variables template
├── README.md           # This file
├── README_CN.md        # Chinese documentation
└── sanitize.ps1        # Sensitive data sanitizer
```

## Quick Start

### 1. Clone & Setup

```bash
git clone <your-repo-url>
cd coze-workflows
```

### 2. Configure Environment

Copy the example environment file and fill in your credentials:

```bash
cp .env.example .env
```

Edit `.env` with your actual Coze API credentials.

### 3. Import Workflows

1. Go to [Coze](https://www.coze.cn) (or [coze.com](https://www.coze.com))
2. Navigate to your workspace
3. Import the workflow JSON files from the `workflows/` folder

## Workflows

### RewriteFlow
A text rewriting workflow that processes clipboard content and transforms it according to defined rules.

### VideoPipeline
A video processing pipeline that handles video URLs, extracts content, and generates ASR (Automatic Speech Recognition) transcriptions.

## Video Generation Results

The VideoPipeline workflow generates videos from images. Below are examples of generated videos:

| Screenshot | Description |
|------------|-------------|
| ![Video Generation Result 1](./ScreenShot_2026-05-18_113455_181.png) | Video generation output - 113455 |
| ![Video Generation Result 2](./ScreenShot_2026-05-18_113911_308.png) | Video generation output - 113911 |

## Security Note

The `workflows/` folder contains two versions of each workflow:

 **Original files** (`RewriteFlow.json`, `VideoPipeline.json`): Keep your actual IDs and workspace references - these are for personal use or importing back into your own Coze workspace.

 **Sanitized files** (`sanitized_*.json`): IDs replaced with placeholders like `YOUR_16_DIGIT_ID` - safe for public sharing.

Before sharing or publishing these workflows, run the sanitizer script to update the sanitized versions:

```powershell
.\sanitize.ps1
```

## Requirements

- Coze account with API access
- (Optional) External API services as referenced in workflows

## License

MIT License
