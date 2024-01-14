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

# Specify the time you want to set
time_to_set="2022:02:16 12:50:00"

# 检查当前目录下是否有文件
if ls -1qA * 2>/dev/null | grep -q .

then
    # Loop over all files in the current directory
    for file in *
    do
        # Get the file extension
        extension="${file##*.}"
        
        # Convert the extension to lowercase
        extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')
        
        # Check the file type and perform the related update
        case "$extension" in
            jpg|jpeg|png)
                # Check if the DateTimeOriginal tag is set
                if ! exiftool -DateTimeOriginal "$file" | grep -q "Date/Time Original"
                then
                    # If the DateTimeOriginal tag is not set, update it with the specified time
                    exiftool -overwrite_original -DateTimeOriginal="$time_to_set" "$file"
                fi
                exiftool -overwrite_original "-FileModifyDate<DateTimeOriginal" -d "%Y:%m:%d %H:%M:%S" "$file"
                ;;
            mov|mp4)
                exiftool -overwrite_original "-FileModifyDate<MediaCreateDate" -d "%Y:%m:%d %H:%M:%S" "$file"
                ;;
        esac
    done

    #exiftool -MediaCreateDate="2022:04:05 11:00:00" *.MOV 
    #exiftool -DateTimeOriginal="2022:04:05 11:00:00" *.PNG
    #exiftool -DateTimeOriginal="2022:04:05 11:00:00" *.jpeg
    #exiftool "-FileModifyDate<DateTimeOriginal" -d "%Y:%m:%d %H:%M:%S" *.jpeg
    #exiftool "-FileModifyDate<DateTimeOriginal" -d "%Y:%m:%d %H:%M:%S" *.JPG
    #exiftool "-FileModifyDate<DateTimeOriginal" -d "%Y:%m:%d %H:%M:%S" *.PNG
    #exiftool "-FileModifyDate<MediaCreateDate" -d "%Y:%m:%d %H:%M:%S" *.MOV
    #exiftool "-FileModifyDate<MediaCreateDate" -d "%Y:%m:%d %H:%M:%S" *.mov

    #exiftool "-FileModifyDate<MediaCreateDate" -d "%Y:%m:%d %H:%M:%S" *.mp4
    echo "Timestamps updated for all files in the current directory."
else
    echo "No files found in the current directory."
fi

echo "End process"