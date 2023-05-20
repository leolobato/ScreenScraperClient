import Get
import Foundation

public enum FileIdentifier {
    case crc(String)
    case md5(String)
    case sha1(String)
    public func param() -> (String, String) {
        switch self {
        case  .crc(let value): return ( "crc", value)
        case  .md5(let value): return ( "md5", value)
        case .sha1(let value): return ("sha1", value)
        }
    }
}

public class ScreenScraper {

    public struct Configuration {
        public let devId: String
        public let devPassword: String
        public let client: String

        public let username: String?
        public let password: String?

        public let debugMode: Bool

        public init(devId: String, devPassword: String, client: String, username: String? = nil, password: String? = nil, debugMode: Bool = false) {
            self.devId = devId
            self.devPassword = devPassword
            self.client = client
            self.username = username
            self.password = password
            self.debugMode = debugMode
        }
    }

    let client: APIClient
    let config: Configuration
    let clientDelegate: ScreenScraperAPIClientDelegate

    public init(_ config: Configuration) {
        self.config = config
        let clientDelegate = ScreenScraperAPIClientDelegate()
        clientDelegate.debugMode = config.debugMode
        let clientConfig = APIClient.Configuration(
            baseURL: URL(string:"https://www.screenscraper.fr/api2"),
            delegate: clientDelegate
        )
        self.client = APIClient(configuration: clientConfig)
        self.clientDelegate = clientDelegate
    }

    private func clientConfigParams() -> [(String, String)] {
        var params = [
            ("devid", config.devId),
            ("devpassword", config.devPassword),
            ("softname", config.client)
        ]
        if let username = config.username { params.append(("ssid", username)) }
        if let password = config.password { params.append(("sspassword", password)) }
        return params
    }

    public func getGame(filename: String, filesize: UInt64?, identifiers: [FileIdentifier], romType: RomType, platform: Platform) async throws -> GameInfo {
        var params = self.clientConfigParams()
        params.append(("output", "json"))

        params.append(contentsOf: identifiers.map({$0.param()}))
        params.append(("systemeid", String(platform.rawValue)))
        params.append(("romtype", String(romType.rawValue)))
        if let filesize = filesize {
            params.append(("romtaille", String(filesize)))
        }
        params.append(("romnom", filename))

        let request = Request<APIResponse>(path: "jeuInfos.php", method: .get, query: params)
        let apiResponse = try await client.send(request).value
        let game: GameInfo = apiResponse.response.game
        return game
    }
}

class ScreenScraperAPIClientDelegate: NSObject, APIClientDelegate {

    var debugMode: Bool = false

    enum ScraperError: Error {
        case fileNotFound
        case statusCode(Int)
    }

    func client(_ client: APIClient, willSendRequest request: inout URLRequest) async throws {
        if debugMode {
            print(request.curlRepresentation())
        }
    }

    func client(_ client: APIClient, shouldRetry task: URLSessionTask, error: Error, attempts: Int) async throws -> Bool {
        false
    }

    func client(_ client: APIClient, validateResponse response: HTTPURLResponse, data: Data, task: URLSessionTask) throws {
        if (200..<300).contains(response.statusCode) {
            return
        }
        if let string = String(data: data, encoding: .utf8), string.contains("Erreur : Rom/Iso/Dossier non trouvée !") {
            throw ScraperError.fileNotFound
        }
        throw ScraperError.statusCode(response.statusCode)
    }
}


public struct APIResponse: Decodable {
    public struct Response: Decodable {
        public let game: GameInfo
        public enum CodingKeys: String, CodingKey {
            case game = "jeu"
        }
    }
    public let response: Response
}

public struct Genre: Codable {
    public let id: String
    public let names: [LanguageEnabledText]
    private enum CodingKeys: String, CodingKey {
        case id
        case names = "noms"
    }
}

public struct RegionEnabledText: RegionEnabled, Codable {
    public let text: String
    public let region: String
}

public struct TextReference: Codable {
    public let id: String
    public let text: String
}

public struct LanguageEnabledText: Codable {
    public let text: String
    public let language: String

    private enum CodingKeys: String, CodingKey {
        case language = "langue"
        case text
    }
}

public extension Array where Element: Equatable {

    mutating func sort(topPriority: [Element]) {
        for item in topPriority.reversed() {
            guard let index = self.firstIndex(of: item) else { continue }
            self.remove(at: index)
            self.insert(item, at: 0)
        }
    }

}

public extension Array where Element: RegionEnabled {
    func preferred(_ preferredRegions: [Region], exclusively: Bool = false) -> Element? {
        let sortedRegions: [Region]
        if exclusively {
            sortedRegions = preferredRegions
        } else {
            var regions = Region.allCases
            regions.sort(topPriority: preferredRegions)
            sortedRegions = regions
        }
        let regions = sortedRegions.map({ $0.rawValue })
        let sorted = self.filter({ regions.contains($0.region) }).sorted { item1, item2 in
            let index1 = regions.firstIndex(of: item1.region)
            let index2 = regions.firstIndex(of: item2.region)
            if let index1 = index1, let index2 = index2 {
                return index1 < index2
            } else if index1 != nil {
                return true
            } else {
                return false
            }
        }
        return sorted.first
    }
}

public extension Array where Element: OptionalRegionEnabled {
    func preferred(_ preferredRegions: [Region], exclusively: Bool = false) -> Element? {
        let sortedRegions: [Region]
        if exclusively {
            sortedRegions = preferredRegions
        } else {
            var regions = Region.allCases
            regions.sort(topPriority: preferredRegions)
            sortedRegions = regions
        }
        let regions = sortedRegions.map({ $0.rawValue })
        let sorted = self.filter({ regions.contains($0.region ?? "") }).sorted { item1, item2 in
            let index1 = regions.firstIndex(of: item1.region ?? "")
            let index2 = regions.firstIndex(of: item2.region ?? "")
            if let index1 = index1, let index2 = index2 {
                return index1 < index2
            } else if index1 != nil {
                return true
            } else {
                return false
            }
        }
        return sorted.first
    }
}

public extension Array where Element == LanguageEnabledText {
    func preferred(_ languages: [Language], exclusively: Bool = false) -> LanguageEnabledText? {
        let sortedLanguages: [Language]
        if exclusively {
            sortedLanguages = languages
        } else {
            var allLanguages = Language.allCases
            allLanguages.sort(topPriority: languages)
            sortedLanguages = allLanguages
        }
        let preferredLanguages = sortedLanguages.map({ $0.rawValue })
        let sorted = self.filter({ preferredLanguages.contains($0.language) }).sorted { item1, item2 in
            let index1 = preferredLanguages.firstIndex(of: item1.language)
            let index2 = preferredLanguages.firstIndex(of: item2.language)
            if let index1 = index1, let index2 = index2 {
                return index1 < index2
            } else if index1 != nil {
                return true
            } else {
                return false
            }
        }
        return sorted.first
    }
}

public protocol RegionEnabled {
    var region: String { get }
}

public protocol OptionalRegionEnabled {
    var region: String? { get }
}
