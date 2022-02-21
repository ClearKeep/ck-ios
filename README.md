# ck-ios
iOS client with end to end encryption messaging

## Prerequisites
* Xcode 13.0.1
* Swift-protobuf version 1.12.0
* grpc-swift commit: e2e138df61dcbfc2dc1cf284fdab6f983539ab48

## Build & Run
* Git clone source code

## Architecture
CleanSwift: https://clean-swift.com/

![CleanSwift](https://user-images.githubusercontent.com/23242146/135713020-eeb40f03-fd05-4fd0-b77f-0d2639f6ef9b.png)

### Branching
|type|usage|
|--|--|
|develop|uses for development team and pre-release version|
|feature/module/ISSUE_ID|uses for feature development|
|bugfix/module/ISSUE_ID|uses for general bug fixing in next version releases|

### Commit Message
Follow this guideline

```
Feature/module/ISSUE_ID - ScreenName - Add models
Bugfix/module/ISSUE_ID - ScreenName - Fix bug xxx
```

### Pull Request
Follow this guideline
> :warning: You have to link ISSUE to your PR
```
Feature/module/ISSUE_ID - ScreenName - Short issue title
Bugfix/module/ISSUE_ID - ScreenName - Short issue title
```

### NOTE
- Prefer UpperCamelCase
- Using proxyman to mock API: https://proxyman.io/
- Self-review code and build project before create PR
- Follow coding convention by SwiftLint: https://github.com/realm/SwiftLint 
