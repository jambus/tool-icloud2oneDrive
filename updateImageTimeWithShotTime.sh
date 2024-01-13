#!/bin/bash

# 获取脚本所在的目录
script_directory="$(cd "$(dirname "$0")" && pwd)"

# 切换到脚本所在的目录
cd "$script_directory" || exit 1

trap finish EXIT

echo "Start process"

# 检查当前目录下是否有文件
if ls -1qA * 2>/dev/null | grep -q .

then
  # 如果有文件，使用jhead更新时间戳
  jhead -ft *
  echo "Timestamps updated for all files in the current directory."
else
  echo "No files found in the current directory."
fi

echo "End process"
