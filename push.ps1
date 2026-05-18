# Coze Workflows - 一键推送到 GitHub

$repoName = "coze-workflows"
$description = "A collection of Coze workflows for video processing and content rewriting tasks."

# 配置 Git 用户信息（请修改为你的信息）
git config --global user.email "logan@example.com"
git config --global user.name "Logan"

# 添加 safe directory
git config --global --add safe.directory C:/Users/Logan/Desktop/codex/coze-workflows

# 初始化并提交
git init -b main
git add .
git commit -m "Initial commit - add Coze workflows with video generation screenshots"

# 创建 GitHub 仓库（如果不存在）
$remoteUrl = "https://github.com/logan-gbid/$repoName.git"
gh repo create $repoName --public --source=. --clone=false 2>$null

# 添加远程仓库并推送
git remote add origin $remoteUrl 2>$null
git branch -M main
git push -u origin main --force

Write-Host ""
Write-Host "✅ 完成！仓库地址: https://github.com/logan-gbid/$repoName"