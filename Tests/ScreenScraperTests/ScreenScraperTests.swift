import XCTest
@testable import ScreenScraperClient

final class ScreenScraperTests: XCTestCase {

    func testSortTopPriorityRegion() throws {
        var allRegions = Region.allCases
        XCTAssertEqual(allRegions, [.wor,.eu,.us,.uk,.de,.jp,.br,.fr,.cn,.kr,.au,.tw,.asi,.se,.it,.ca,.sp,.ru,.nl,.dk,.fi,.ame,.pl,.cus,.pt,.cz,.hu,.cl,.sk,.oce,.nz,.mor,.il,.pe,.tr,.kw,.no,.bg,.gr,.ss,.ae,.za,.mex,.afr])

        allRegions.sort(topPriority: [.jp, .pt])
        XCTAssertEqual(allRegions, [.jp,.pt,.wor,.eu,.us,.uk,.de,.br,.fr,.cn,.kr,.au,.tw,.asi,.se,.it,.ca,.sp,.ru,.nl,.dk,.fi,.ame,.pl,.cus,.cz,.hu,.cl,.sk,.oce,.nz,.mor,.il,.pe,.tr,.kw,.no,.bg,.gr,.ss,.ae,.za,.mex,.afr])
    }

    func testSortTopPriorityLanguage() throws {
        var allLanguages:[Region?] = Language.allCases
        XCTAssertEqual(allLanguages, [.en,.fr,.de,.es,.it,.ja,.sv,.pt,.nl,.no,.fi,.ko,.pl,.zh,.ru,.tr,.cz,.sk,.hu,.da,])

        allLanguages.sort(topPriority: [.de, .fi])
        XCTAssertEqual(allLanguages, [.de,.fi,.en,.fr,.es,.it,.ja,.sv,.pt,.nl,.no,.ko,.pl,.zh,.ru,.tr,.cz,.sk,.hu,.da,])
    }

}
