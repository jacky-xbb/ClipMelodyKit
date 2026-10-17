import Foundation

/// The site a short-video link points to.
public enum Platform: String, Sendable {
    case tiktok, instagram, youtube
}

/// A parsed TikTok, Instagram Reel or YouTube Shorts link.
///
/// This is the link-handling piece behind ClipMelody (https://clipmelody.com/),
/// which finds the song playing in a short video, even when it only says "original sound".
public struct ClipLink: Equatable, Sendable {
    public let platform: Platform
    /// The platform's video ID, or the short code for `vm.tiktok.com` / `tiktok.com/t/` links.
    public let id: String
    /// Whether `id` is a TikTok short code rather than a video ID.
    public let isShortCode: Bool
    /// The TikTok handle from a full video link, without the "@".
    public let author: String?

    /// Parses a link with or without a scheme, `www.`/`m.` prefixes, query string or trailing slash.
    /// Returns `nil` for anything that is not a TikTok, Instagram Reel or YouTube Shorts link.
    public init?(_ raw: String) {
        var s = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.isEmpty { return nil }
        if !s.contains("://") { s = "https://" + s }
        guard let comps = URLComponents(string: s), var host = comps.host?.lowercased() else { return nil }
        for prefix in ["www.", "m."] where host.hasPrefix(prefix) { host.removeFirst(prefix.count) }
        let parts = comps.path.split(separator: "/").map(String.init)

        switch (host, parts.count) {
        case ("tiktok.com", 3) where parts[0].hasPrefix("@") && ["video", "photo"].contains(parts[1])
            && Self.valid(String(parts[0].dropFirst()), 2...24, extra: "._")
            && (6...25).contains(parts[2].count) && parts[2].allSatisfy(\.isASCIIDigit):
            self.init(.tiktok, parts[2], short: false, author: String(parts[0].dropFirst()))
        case ("tiktok.com", 2) where parts[0] == "t" && Self.valid(parts[1], 5...20):
            self.init(.tiktok, parts[1], short: true)
        case ("vm.tiktok.com", 1), ("vt.tiktok.com", 1):
            guard Self.valid(parts[0], 5...20) else { return nil }
            self.init(.tiktok, parts[0], short: true)
        case ("instagram.com", 2) where ["reel", "reels", "p", "tv"].contains(parts[0]) && Self.valid(parts[1], 5...40, extra: "_-"):
            self.init(.instagram, parts[1])
        case ("youtube.com", 2) where parts[0] == "shorts" && Self.valid(parts[1], 11...11, extra: "_-"):
            self.init(.youtube, parts[1])
        default:
            return nil
        }
    }

    private init(_ platform: Platform, _ id: String, short: Bool = false, author: String? = nil) {
        self.platform = platform
        self.id = id
        self.isShortCode = short
        self.author = author
    }

    /// A clean canonical link for the clip, without tracking parameters.
    public var canonicalURL: URL {
        let s: String
        switch platform {
        case .tiktok where isShortCode: s = "https://vm.tiktok.com/\(id)/"
        case .tiktok: s = "https://www.tiktok.com/@\(author ?? "")/video/\(id)"
        case .instagram: s = "https://www.instagram.com/reel/\(id)/"
        case .youtube: s = "https://www.youtube.com/shorts/\(id)"
        }
        return URL(string: s)!
    }

    private static func valid(_ s: String, _ length: ClosedRange<Int>, extra: String = "") -> Bool {
        length.contains(s.count) && s.allSatisfy { ($0.isASCII && ($0.isLetter || $0.isNumber)) || extra.contains($0) }
    }
}

private extension Character {
    var isASCIIDigit: Bool { isASCII && isNumber }
}
