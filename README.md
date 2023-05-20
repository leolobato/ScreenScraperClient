# ScreenScraperClient

A Swift client for the [ScreenScraper API](https://screenscraper.fr/webapi2.php).

[ScreenScraper.fr](https://screenscraper.fr) is arguably the most popular and comprehensive database of metadata, images and videos for retro games. 

Using it as a source for scraping source means you'll have all the information and cover art for your ROM collection on your favorite emulation frontend.

This is a client written in Swift, in case you'd like to write your own scraper that connects to ScreenScraper.fr.

You'll need your own API key to access the ScreenScraper WebAPI. You can apply for an API key on [the WebAPI Forums](https://www.screenscraper.fr/forumsujets.php?frub=12&numpage=0).

## Features

- Supports iOS and macOS
- Preferred list of regions and languages for metadata and media
- Scrape providing filename and/or hash

## Not supported yet

- ISO-based games: there's support for `.cue`/`.bin` files but it's not tested for systems that use `.iso` or `.chd` files.
- Not all platforms are supported yet.
- Media type are not strong-typed yet. They need to be referred by their name (`box-2D`, `box-3D`, `sstitle`, `ss`, etc)

## Usage

You'll need to apply for your own API key to access the ScreenScraper WebAPI. Please read [their FAQ](https://screenscraper.fr/faq.php) and [apply for an API key at their Forums](https://www.screenscraper.fr/forumsujets.php?frub=12&numpage=0).

```
    // Create your API client instance using your API key.
    let config = ScreenScraper.Configuration(
        devId: "xxx",       // From your own API key `devid`
        devPassword: "yyy", // From your own API key `devpassword`
        client: "zzz"       // Your app name
    )
    let client = ScreenScraper(config)

    // Fetch a ROM file metadata
    guard let metadata = try? await client.getGame(
        filename: "Sonic The Hedgehog 2 (World).zip",
        filesize: 749652,
        identifiers: [.crc("50ABC90A")],
        romType: .rom,
        platform: .megaDrive
    ) else {
        // Game not found
        return
    }

    // You can provide a list of your preferred regions for the game title,
    // box art and release dates.
    let regionPriority: [Region] = [.wor, .us, .jp, .eu]

    // You can also provide a list of your preferred languages for the metadata.
    let languagePriority: [Language] = [.en, .de]

    if let title = metadata.names.preferred(regionPriority) {
        print("Title: [\(title.text)] Region: [\(title.region)]")
    }
    
    if let description = metadata.description.preferred(languagePriority) {
        print("Description: [\(description.text)] Language: [\(description.language)]")
    }

    if let cover = metadata.media("box-2D").preferred(regionPriority) {
        print("Cover image URL: [\(cover.url)]")
    }

```

## Instalation

### Swift Package Manager

The [Swift Package Manager](https://www.swift.org/package-manager) is a tool for managing the distribution of Swift code.

Add the following line to your `Package.swift` file:

```
dependencies: [
   .package(url: "https://github.com/leolobato/ScreenScraperClient.git", .upToNextMajor(from: "1.0.0"))
] 
```

Or in Xcode, choose: `File` > `Add Packages...` and paste `https://github.com/leolobato/ScreenScraperClient` on "Search or Enter Package URL".