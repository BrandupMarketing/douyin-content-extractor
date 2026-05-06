#!/bin/bash
# One-click installer for Douyin Content Extractor
set -e

echo "=== Douyin Content Extractor Installer ==="
mkdir -p ~/.hermes/skills

# 1. Install gstack-browse
if [ ! -d ~/.hermes/skills/gstack-browse ]; then
    echo "[1/3] Installing gstack-browse..."
    git clone --depth 1 https://github.com/BrandupMarketing/gstack-browse.git ~/.hermes/skills/gstack-browse
fi

# 2. Install Douyin API
if [ ! -d ~/.hermes/skills/references/Douyin_TikTok_Download_API ]; then
    echo "[2/3] Installing Douyin API..."
    git clone --depth 1 https://github.com/Evil0ctal/Douyin_TikTok_Download_API.git ~/.hermes/skills/references/Douyin_TikTok_Download_API
fi

# 3. Install douyin-extractor skill
mkdir -p ~/.hermes/skills/douyin-extractor/content
cat > ~/.hermes/skills/douyin-extractor/SKILL.md << 'SKILL'
---
name: douyin-extractor
description: 抖音内容提取 - 解析抖音链接/视频ID，获取视频信息、无水印下载链接
tags: [douyin, 抖音]
version: 1.0
---
# 抖音内容提取

## 触发条件
用户发送抖音链接 (v.douyin.com/xxx) 或视频ID

## 工作流程

### 1. 确保 API 运行
curl -s http://127.0.0.1:80/health >/dev/null 2>&1 || {
    cd ~/.hermes/skills/references/Douyin_TikTok_Download_API
    nohup python3 start.py > /tmp/douyin.log 2>&1 &
    sleep 8
}

### 2. 提取视频
curl -s "http://127.0.0.1/api/douyin/web/fetch_one_video?aweme_id=视频ID"
SKILL

echo "=== Done! ==="
echo "Just send me a Douyin link!"
