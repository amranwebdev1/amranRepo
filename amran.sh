#!/data/data/com.termux/files/usr/bin/bash

# ফাংশন: Termux আপডেট এবং প্রয়োজনীয় প্যাকেজ ইনস্টল
install_amran() {
    echo "Updating and upgrading Termux packages..."
    pkg update && pkg upgrade -y
    pkg install python ffmpeg -y
    pip install -U --no-deps yt-dlp
    echo "Setup completed!"
}

# ফাংশন: ভিডিও ডাউনলোড
download_video() {
    local prefix=$1
    local url=$2
    if [ -z "$url" ]; then
        echo "Error: Please provide a video URL."
        exit 1
    fi

    # কুকিজ ফাইল নির্বাচন
    local cookies=""
    if [[ "$url" == *"tiktok.com"* ]] && [ -f ~/tiktok_cookies.txt ]; then
        cookies="--cookies ~/tiktok_cookies.txt"
        echo "Using TikTok cookies..."
    elif [[ "$url" == *"facebook.com"* ]] && [ -f ~/facebook_cookies.txt ]; then
        cookies="--cookies ~/facebook_cookies.txt"
        echo "Using Facebook cookies..."
    fi

    mkdir -p /storage/emulated/0/Download/amran
    local filename="%(title)s.%(ext)s"
    if [ -n "$prefix" ]; then
        filename="${prefix}_%(title)s.%(ext)s"
        echo "Using custom prefix: $prefix"
    fi

    echo "Downloading video in 720p (MP4)..."
    timeout 600 yt-dlp $cookies -f "bestvideo[height<=720]+bestaudio/best[height<=720]" --merge-output-format mp4 --no-playlist -o "/storage/emulated/0/Download/amran/$filename" --verbose "$url" 2>/tmp/amran_error.log
    if [ $? -eq 0 ]; then
        termux-toast "Video download completed!"
    else
        termux-toast "Video download failed!"
        echo "Error: Download failed. Check /tmp/amran_error.log for details."
        cat /tmp/amran_error.log
        exit 1
    fi
}

# ফাংশন: অডিও ডাউনলোড
download_audio() {
    local prefix=$1
    local url=$2
    if [ -z "$url" ]; then
        echo "Error: Please provide a video URL."
        exit 1
    fi

    # কুকিজ ফাইল নির্বাচন
    local cookies=""
    if [[ "$url" == *"tiktok.com"* ]] && [ -f ~/tiktok_cookies.txt ]; then
        cookies="--cookies ~/tiktok_cookies.txt"
        echo "Using TikTok cookies..."
    elif [[ "$url" == *"facebook.com"* ]] && [ -f ~/facebook_cookies.txt ]; then
        cookies="--cookies ~/facebook_cookies.txt"
        echo "Using Facebook cookies..."
    fi

    mkdir -p /storage/emulated/0/Download/amran
    local filename="%(title)s.%(ext)s"
    if [ -n "$prefix" ]; then
        filename="${prefix}_%(title)s.%(ext)s"
        echo "Using custom prefix: $prefix"
    fi

    echo "Downloading audio in MP3..."
    timeout 600 yt-dlp $cookies -x --audio-format mp3 --audio-quality 0 --no-playlist -o "/storage/emulated/0/Download/amran/$filename" --verbose "$url" 2>/tmp/amran_error.log
    if [ $? -eq 0 ]; then
        termux-toast "Audio download completed!"
    else
        termux-toast "Audio download failed!"
        echo "Error: Download failed. Check /tmp/amran_error.log for details."
        cat /tmp/amran_error.log
        exit 1
    fi
}

# স্টোরেজ পারমিশন
if [ ! -d "/storage/emulated/0" ]; then
    termux-setup-storage
    sleep 2
fi

# কমান্ড লাইন আর্গুমেন্ট পার্সিং
while [ $# -gt 0 ]; do
    case "$1" in
        install)
            install_amran
            exit 0
            ;;
        v|-v)
            if [ "$2" = "p" ] || [ "$2" = "-p" ] && [ -n "$3" ]; then
                download_video "$3" "$4"
            else
                download_video "" "$2"
            fi
            exit 0
            ;;
        a|-a)
            if [ "$2" = "p" ] || [ "$2" = "-p" ] && [ -n "$3" ]; then
                download_audio "$3" "$4"
            else
                download_audio "" "$2"
            fi
            exit 0
            ;;
        *)
            echo "Usage:"
            echo "  amran install          : Install dependencies and setup"
            echo "  amran v <url>         : Download video in 720p (MP4)"
            echo "  amran a <url>         : Download audio in MP3"
            echo "  amran v p <prefix> <url> : Download video with custom prefix"
            echo "  amran a p <prefix> <url> : Download audio with custom prefix"
            exit 1
            ;;
    esac
done

echo "Usage:"
echo "  amran install          : Install dependencies and setup"
echo "  amran v <url>         : Download video in 720p (MP4)"
echo "  amran a <url>         : Download audio in MP3"
echo "  amran v p <prefix> <url> : Download video with custom prefix"
echo "  amran a p <prefix> <url> : Download audio with custom prefix"
exit 1











































