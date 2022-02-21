# iOS-Base

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
