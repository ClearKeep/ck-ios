# ck-ios
iOS client with end to end encryption messaging

## Prerequisites
* Xcode:  Version 13.2.1
* Swift-protobuf:  Version 1.18.0
* Grpc-swift: Version 1.7.1
* Rust

## Build & Run
### Clone source from github
### Generate and import protos
1. Get protos from https://github.com/ClearKeep/ck-backend/tree/master/protos
2. Install swift-protobuf and Grpc-Swift
   ```brew install brew install swift-protobuf grpc-swift```
3. Generate pb.swift and grpc.swift 
   ```
   mkdir Protobuf
   protoc --grpc-swift_out=Protobuf/ --swift_out=proto/ *.proto
   ```
4. Copy folder to Packages/ChatServices

### Install rust for Libsignal
1. brew install rust
2. rustc --version
3. rustup-init
