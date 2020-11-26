# MyJWPChatApp
This app is a POC for a "Live Concert" app, featuring an HLS Live Stream played by the JWPlayer side-by-side with an in-app chat window.

### Usage
In order to use the app, you will need to provide a JWP license key, which comes with an Enterprise Account. See www.jwplayer.com for details.

1. Create a new `SecureKeys.swift` file.
2. Copy in the snippet below, with your license key:

```swift
struct Secure {
    struct Keys {
        static let JWPv3Key = "YOUR_KEY_HERE"
    }
}
```
