# UIL PML iOS

Native SwiftUI iPhone app for browsing the UIL Prescribed Music List.

This app is intentionally kept in a separate repo from the web project. The web repo remains the source of truth for the generated UIL JSON datasets, and this app reads those datasets over HTTPS.

## Current architecture

- iOS app: SwiftUI client in this repo
- Data source: deployed JSON files from the web project
- Shared contract: dataset manifest entries, stats payloads, and per-title JSON fields

## Run locally

1. Open `UILPMLiOS.xcodeproj` in Xcode.
2. Choose an iPhone simulator.
3. Build and run the `UILPMLiOS` scheme.

## Remote data source

The app currently reads dataset files from:

`https://kelleyparker.github.io/UIL_PrescribedMusicList/data/`

If the web repo’s GitHub Pages path changes, update `baseDataURL` in `UILPMLiOS/Services/UILRemoteDataService.swift`.

## Scope

The current MVP includes:

- Browse datasets grouped as Solos, Ensembles, and Large Groups
- Search titles, composers, publishers, and UIL codes
- Class-level filtering when UIL class levels are present
- Quick stats header for the selected dataset
- Public-domain and affiliate sheet-music links when provided in the JSON

## Notes

- This app displays metadata and outbound links only.
- It does not host copyrighted sheet music.
