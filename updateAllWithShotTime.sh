#!/bin/bash

# Install exiftool if not already installed
if ! command -v exiftool &> /dev/null
then
    echo "exiftool could not be found"
    echo "Installing exiftool..."
    brew install exiftool
fi

# 获取脚本所在的目录
script_directory="$(cd "$(dirname "$0")" && pwd)"

# 切换到脚本所在的目录
cd "$script_directory" || exit 1

trap finish EXIT

echo "Start process"

# 检查当前目录下是否有文件
if ls -1qA * 2>/dev/null | grep -q .

then
    # Loop over all JPG, MOV & MP4 files in the current directory
    jhead -ft *.jpeg
    jhead -ft *.JPG
    exiftool "-FileModifyDate<MediaCreateDate" -d "%Y:%m:%d %H:%M:%S" *.MOV
    exiftool "-FileModifyDate<MediaCreateDate" -d "%Y:%m:%d %H:%M:%S" *.mp4

    echo "Timestamps updated for all files in the current directory."
else
    echo "No files found in the current directory."
fi

echo "End process"