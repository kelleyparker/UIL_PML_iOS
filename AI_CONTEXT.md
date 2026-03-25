# AI Context – UIL PML iOS

## Project Overview
This repo contains the native SwiftUI iPhone app for browsing the UIL Prescribed Music List.

The goal is to:
- Provide a fast mobile browsing experience for the UIL PML
- Reuse the web repo’s generated JSON datasets rather than duplicating the data pipeline
- Keep iOS-specific product, architecture, and App Store decisions isolated from the web repo

## Key Constraints
- DO NOT host or distribute copyrighted sheet music
- Only display metadata and outbound links
- This app is independent and is not officially endorsed by, affiliated with, or sponsored by UIL
- Affiliate links may be shown for select titles, but the app should remain clearly useful as a free browsing tool

## Data Source
- The iOS app currently reads remote JSON from the deployed web project
- Source base URL is configured in `UILPMLiOS/Services/UILRemoteDataService.swift`
- Shared contract comes from the web repo’s generated dataset JSON and stats JSON

## Architecture (High-Level)
- SwiftUI app in `UILPMLiOS/`
- Project generation is handled by `xcodegen` using `project.yml`
- Models mirror the web JSON contract
- `DatasetBrowserViewModel` handles loading, search, and class filtering
- `DatasetListView` is the landing screen and should keep the UIL disclaimer visible

## Maintenance Workflow
- Update `README.md` and `AI_CONTEXT.md` when architecture, remote-data assumptions, disclaimer language, monetization behavior, or App Store readiness changes
- Prefer keeping web-repo and iOS-repo code changes separate, even when they share the same underlying data
- If the deployed web data path changes, update the iOS app before pushing related changes

## Using This File Across AI Tools Or New Contexts
- Treat `AI_CONTEXT.md` as the canonical handoff note for this iOS repo
- At the start of a new AI session, ask the assistant to read `README.md` and `AI_CONTEXT.md`
- If repo behavior changes and this file becomes stale, update it rather than relying on old conversation context
