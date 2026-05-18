#!/bin/bash
# Coze Workflows - 一键推送到 GitHub

repoName="coze-workflows"
remoteUrl="https://github.com/logan-gbid/coze-workflows.git"

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
gh repo create $repoName --public --source=. --clone=false 2>/dev/null

# 添加远程仓库并推送
git remote add origin $remoteUrl 2>/dev/null
git branch -M main
git push -u origin main --force

echo ""
echo "✅ 完成！仓库地址: https://github.com/logan-gbid/$repoName"