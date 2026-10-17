# ClipMelodyKit

Parse TikTok, Instagram Reel and YouTube Shorts links into a platform, a video ID and a clean canonical URL (tracking parameters stripped). Foundation only, no dependencies.

```swift
import ClipMelodyKit

if let clip = ClipLink("https://www.instagram.com/reels/C9xYz_Ab-12/?igsh=abc") {
    print(clip.platform)      // instagram
    print(clip.canonicalURL)  // https://www.instagram.com/reel/C9xYz_Ab-12/
}
```

Supported links:

- `tiktok.com/@user/video/<id>`, `tiktok.com/t/<code>`, `vm.tiktok.com/<code>`
- `instagram.com/reel/<id>`, `/reels/`, `/p/`, `/tv/`
- `youtube.com/shorts/<id>`

This is the link-handling piece behind [ClipMelody](https://clipmelody.com/), which finds the song playing in a short video, even when the clip only says "original sound". Also available for [Rust](https://crates.io/crates/clipmelody) and [Go](https://github.com/jacky-xbb/clipmelody-cli).

## Installation

```swift
.package(url: "https://github.com/jacky-xbb/ClipMelodyKit.git", from: "0.1.0")
```

## License

MIT
