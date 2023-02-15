# ck-ios
iOS client with end to end encryption messaging

## Prerequisites
* Xcode:  Version 13.2.1
* Swift-protobuf:  Version 1.18.0
* Grpc-swift: Version 1.7.1
* Rust
* Ruby: 3.2.0
* Cocoapods: 1.11.2

### Install swift-protobuf and Grpc-Swift
   ```brew install swift-protobuf grpc-swift```

## Build & Run
### Clone source from github

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

### Generate and import protos
1. Get protos from https://github.com/ClearKeep/ck-backend/tree/master/protos
2. Generate pb.swift and grpc.swift 
   ```
   mkdir Protobuf
   protoc --grpc-swift_out=Protobuf/ --swift_out=Protobuf/ *.proto --swift_opt=Visibility=Public
   ```
3. Copy folder to Packages/Networking/Networking/Classes/Protobuf

### Install rust for Apple silicon:
1. brew install rustup
2. rustc --version
3. rustup-init
