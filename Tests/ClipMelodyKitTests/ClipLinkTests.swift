import XCTest
@testable import ClipMelodyKit

final class ClipLinkTests: XCTestCase {
    func testTikTokVideo() throws {
        let c = try XCTUnwrap(ClipLink("https://www.tiktok.com/@some.user/video/7301234567890123456?is_from_webapp=1"))
        XCTAssertEqual(c.platform, .tiktok)
        XCTAssertEqual(c.author, "some.user")
        XCTAssertEqual(c.canonicalURL.absoluteString, "https://www.tiktok.com/@some.user/video/7301234567890123456")
    }

    func testTikTokShortLinks() {
        XCTAssertEqual(ClipLink("vm.tiktok.com/ZMabc123/")?.canonicalURL.absoluteString, "https://vm.tiktok.com/ZMabc123/")
        XCTAssertEqual(ClipLink("https://www.tiktok.com/t/ZTRabc12/")?.isShortCode, true)
    }

    func testInstagramReel() {
        XCTAssertEqual(ClipLink("https://www.instagram.com/reels/C9xYz_Ab-12/?igsh=abc")?.canonicalURL.absoluteString,
                       "https://www.instagram.com/reel/C9xYz_Ab-12/")
    }

    func testYouTubeShort() {
        let c = ClipLink("m.youtube.com/shorts/dQw4w9WgXcQ?feature=share")
        XCTAssertEqual(c?.platform, .youtube)
        XCTAssertEqual(c?.canonicalURL.absoluteString, "https://www.youtube.com/shorts/dQw4w9WgXcQ")
    }

    func testRejectsOtherLinks() {
        for s in ["", "https://example.com/video/1", "https://www.youtube.com/watch?v=dQw4w9WgXcQ", "https://www.tiktok.com/@x/video/1"] {
            XCTAssertNil(ClipLink(s), s)
        }
    }
}
