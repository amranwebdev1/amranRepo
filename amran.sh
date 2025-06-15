#!/data/data/com.termux/files/usr/bin/bash

# ফাংশন: Termux আপডেট এবং প্রয়োজনীয় প্যাকেজ ইনস্টল
install_amran() {
    echo "Updating and upgrading Termux packages..."
    pkg update && pkg upgrade -y

    echo "Installing required dependencies..."
    pkg install python ffmpeg -y

    echo "Installing yt-dlp..."
    pip install -U --no-deps yt-dlp

    echo "Setup completed! You can now use 'amran -v <url>' for video or 'amran -a <url>' for audio downloads."
}

# ফাংশন: ভিডিও ডাউনলোড
download_video() {
    local url=$1
    if [ -z "$url" ]; then
        echo "Error: Please provide a video URL."
        exit 1
    fi

    # ডাউনলোড ফোল্ডার তৈরি
    mkdir -p /storage/emulated/0/Download/amran

    echo "Downloading video in Full HD (MP4) to /storage/emulated/0/Download/amran..."
    yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=720]" --merge-output-format mp4 -o "/storage/emulated/0/Download/amran/%(title)s.%(ext)s" "$url"
    termux-toast "Video download completed!"
}

# ফাংশন: অডিও ডাউনলোড
download_audio() {
    local url=$1
    if [ -z "$url" ]; then
        echo "Error: Please provide a video URL."
        exit 1
    fi

    # ডাউনলোড ফোল্ডার তৈরি
    mkdir -p /storage/emulated/0/Download/amran

    echo "Downloading audio in MP3 to /storage/emulated/0/Download/amran..."
    yt-dlp -x --audio-format mp3 --audio-quality 0 -o "/storage/emulated/0/Download/amran/%(title)s.%(ext)s" "$url"
    termux-toast "Audio download completed!"
}

# স্টোরেজ পারমিশন নিশ্চিত করা
if [ ! -d "/storage/emulated/0" ]; then
    termux-setup-storage
    sleep 2
fi

# কমান্ড লাইন আর্গুমেন্ট চেক করা
case "$1" in
    install)
        install_amran
        ;;
    -v)
        download_video "$2"
        ;;
    -a)
        download_audio "$2"
        ;;
    *)
        echo "Usage:"
        echo "  amran install           : Install dependencies and setup"
        echo "  amran -v <url>         : Download video in Full HD (MP4)"
        echo "  amran -a <url>         : Download audio in MP3"
        exit 1
        ;;
esac








































