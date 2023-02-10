# ck-ios
iOS client with end to end encryption messaging

## Prerequisites
* Xcode:  Version 13.2.1
* Swift-protobuf:  Version 1.18.0
* Grpc-swift: Version 1.7.1
* Rust
* Ruby: 3.2.0

## Build & Run
### Clone source from github
<!-- ### Generate and import protos
1. Get protos from https://github.com/ClearKeep/ck-backend/tree/master/protos
2. Install swift-protobuf and Grpc-Swift
   ```brew install brew install swift-protobuf grpc-swift```
3. Generate pb.swift and grpc.swift 
   ```
   mkdir Protobuf
   protoc --grpc-swift_out=Protobuf/ --swift_out=proto/ *.proto
   ```
4. Copy folder to Packages/ChatServices -->

### Install rust
1. brew install rustup
2. rustup-init

### Rust lib required to install pod
```
rustup +nightly-2022-06-22 target add aarch64-apple-ios
rustup +nightly-2022-06-22 target add x86_64-apple-ios
rustup +nightly-2022-06-22 target add aarch64-apple-ios-sim
rustup +nightly-2022-06-22 component add rust-src
rustup +nightly-2021-09-16 target add aarch64-apple-ios
rustup +nightly-2021-09-16 target add x86_64-apple-ios
rustup +nightly-2021-09-16 target add aarch64-apple-ios-sim
rustup +nightly-2021-09-16 component add rust-src
```

#### Then run pod install

