# Coze Workflow Sanitizer Script
# Run this script to sanitize the JSON files for public sharing

$workflowsPath = Join-Path $PSScriptRoot "workflows"
$outputPath = Join-Path $PSScriptRoot "workflows"

Get-ChildItem -Path $workflowsPath -Filter "*.json" | Where-Object { $_.Name -notlike "sanitized_*" } | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $processedIds = @{}

    # Pattern 1: Match IDs in JSON value positions like "workflowId": "123"
    $pattern1 = '"(workflowId|spaceId|spaceID|pluginID|apiID|bot_id|user_id)"\s*:\s*"(\d+)"'
    $matches1 = [regex]::Matches($content, $pattern1)
    
    foreach ($match in $matches1) {
        $keyName = $match.Groups[1].Value
        $idValue = $match.Groups[2].Value
        $key = "${keyName}_${idValue}"
        
        if (-not $processedIds.ContainsKey($key)) {
            $newId = "YOUR_${idValue.Length}_DIGIT_ID"
            $processedIds[$key] = $newId
            $content = $content -replace [regex]::Escape($match.Value), "`"$keyName`": `"$newId`""
        }
    }

    # Pattern 2: Match IDs in "content" field with only digits (like "7389203969416937487")
    $pattern2 = '"content"\s*:\s*"(\d{13,19})"'
    $matches2 = [regex]::Matches($content, $pattern2)
    
    $contentMatchCounter = @{}
    foreach ($match in $matches2) {
        $idValue = $match.Groups[1].Value
        $key = "content_$idValue"
        
        if (-not $processedIds.ContainsKey($key)) {
            $newId = "YOUR_CONTENT_ID"
            if (-not $contentMatchCounter.ContainsKey($newId)) {
                $contentMatchCounter[$newId] = 0
            }
            $counter = $contentMatchCounter[$newId]
            $contentMatchCounter[$newId] = $counter + 1
            $newIdWithSuffix = "${newId}_$counter"
            $processedIds[$key] = $newIdWithSuffix
            $content = $content -replace [regex]::Escape($match.Value), "`"content`": `"$newIdWithSuffix`""
        }
    }

    # Pattern 3: Match IDs in "apiParam" style fields
    $pattern3 = '"(apiID|pluginID)"\s*:\s*\[\s*\{\s*"input"\s*:\s*\{\s*"type"\s*:\s*"string"\s*,\s*"value"\s*:\s*\{\s*"content"\s*:\s*"(\d+)"'
    $matches3 = [regex]::Matches($content, $pattern3)
    
    foreach ($match in $matches3) {
        $idValue = $match.Groups[2].Value
        $key = "apiparam_$idValue"
        
        if (-not $processedIds.ContainsKey($key)) {
            $newId = "YOUR_${idValue.Length}_DIGIT_ID"
            $processedIds[$key] = $newId
            $content = $content -replace [regex]::Escape($match.Value), "`"$($match.Groups[1].Value)`": [{ `"input`": { `"type`": `"string`", `"value`": { `"content`": `"$newId`""
        }
    }

    # Remove other sensitive patterns (signatures, etc.)
    $content = $content -replace '(x-signature=)[^&"]+', '$1YOUR_SIGNATURE'
    $content = $content -replace '(lk3s=)[^&"]+', '$1YOUR_LK3S'
    $content = $content -replace '(x-expires=)\d+', '$1YOUR_EXPIRES'

    # Save sanitized version
    $sanitizedPath = Join-Path $outputPath ("sanitized_" + $_.Name)
    Set-Content -Path $sanitizedPath -Value $content -NoNewline

    Write-Host "Sanitized: $($_.Name) ($($processedIds.Count) IDs replaced)" -ForegroundColor Green
}

# Create environment variable template
$envTemplate = @"
# Environment Variables Template
# Copy this file to .env and fill in your actual values

# Coze API Configuration
COZE_API_KEY=your_coze_api_key_here
COZE_WORKFLOW_ID=your_workflow_id_here
COZE_SPACE_ID=your_space_id_here

# External API Keys (if any)
EXTERNAL_API_KEY=your_external_api_key_here
"@

$templatePath = Join-Path $PSScriptRoot ".env.example"
Set-Content -Path $templatePath -Value $envTemplate

Write-Host "`nSanitization complete! Sanitized files saved with 'sanitized_' prefix." -ForegroundColor Cyan
Write-Host "Environment variables template saved to .env.example" -ForegroundColor Cyan
