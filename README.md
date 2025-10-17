# Google Sign-In Unity Plugin

_Copyright (c) 2017 Google Inc. All rights reserved._

## Overview

Google Sign-In API plugin for Unity game engine. Works with Android and iOS.

This plugin exposes the Google Sign-In API within Unity. Specifically intended for Unity projects that require OAuth ID tokens or server auth codes.

**Features:**
- ✅ Cross-platform: Android and iOS
- ✅ Android 6.0+ support using legacy GoogleApiClient API
- ✅ ID Token and Server Auth Code support
- ✅ Silent sign-in
- ✅ Firebase Authentication compatible

## Installation

### Via Unity Package Manager

Add to your `Packages/manifest.json`:

```json
{
  "dependencies": {
    "com.google.signin": "https://github.com/GooDimuch/google-signin-unity.git#upm-package"
  }
}
```

Or via Unity Editor:
1. **Window → Package Manager**
2. **+ → Add package from git URL...**
3. Enter: `https://github.com/GooDimuch/google-signin-unity.git#upm-package`

## Configuration

### 1. Google Cloud Console Setup

1. Create project in [Google Cloud Console](https://console.cloud.google.com/)
2. Configure OAuth consent screen
3. Create OAuth 2.0 credentials:
   - **Android OAuth client** (SHA-1 fingerprint required)
   - **Web OAuth client** (for ID tokens/server auth codes)
   - **iOS OAuth client** (optional if using Firebase)

### 2. Unity Configuration

```csharp
GoogleSignIn.Configuration = new GoogleSignInConfiguration {
    RequestIdToken = true,
    WebClientId = "YOUR_WEB_CLIENT_ID.apps.googleusercontent.com",
    RequestEmail = true,
    RequestProfile = true
};
```

### 3. Android Setup

1. Set package name: **Project Settings → Player → Android → Other Settings → Package Name**
2. Configure keystore: **Project Settings → Player → Android → Publishing Settings**
3. Add SHA-1 fingerprint to Google Cloud Console
4. Resolve dependencies: **Assets → External Dependency Manager → Android Resolver → Force Resolve**

### 4. iOS Setup

1. Add `GoogleService-Info.plist` to XCode project after build
2. Run: **Assets → External Dependency Manager → iOS Resolver → Install Cocoapods**

## Usage

### Sign In

```csharp
GoogleSignIn.DefaultInstance.SignIn().ContinueWith(task => {
    if (task.IsCanceled) {
        Debug.Log("Sign-in canceled");
    } else if (task.IsFaulted) {
        Debug.LogError("Sign-in failed: " + task.Exception);
    } else {
        GoogleSignInUser user = task.Result;
        Debug.Log("Signed in: " + user.DisplayName);
        Debug.Log("Email: " + user.Email);
        Debug.Log("ID Token: " + user.IdToken);
    }
});
```

### Silent Sign-In

```csharp
GoogleSignIn.DefaultInstance.SignInSilently().ContinueWith(task => {
    if (task.IsCompleted && !task.IsFaulted && !task.IsCanceled) {
        Debug.Log("Silent sign-in successful");
    } else {
        Debug.Log("Silent sign-in failed, need UI");
    }
});
```

### Sign Out

```csharp
GoogleSignIn.DefaultInstance.SignOut();
```

### Disconnect

```csharp
GoogleSignIn.DefaultInstance.Disconnect();
```

## Firebase Authentication

```csharp
GoogleSignIn.Configuration = new GoogleSignInConfiguration {
    RequestIdToken = true,
    WebClientId = "YOUR_WEB_CLIENT_ID.apps.googleusercontent.com"
};

GoogleSignIn.DefaultInstance.SignIn().ContinueWith(task => {
    if (task.IsCompleted && !task.IsFaulted) {
        GoogleSignInUser user = task.Result;
        
        Firebase.Auth.Credential credential = 
            Firebase.Auth.GoogleAuthProvider.GetCredential(user.IdToken, null);
        
        Firebase.Auth.FirebaseAuth.DefaultInstance
            .SignInWithCredentialAsync(credential)
            .ContinueWith(authTask => {
                if (authTask.IsCompleted) {
                    Debug.Log("Firebase sign-in successful");
                }
            });
    }
});
```

## Dependencies

### Android
- `com.google.android.gms:play-services-auth:16+`

### iOS
- `GoogleSignIn` (via CocoaPods, version 4.0.2+)

## Sample

Import sample from Package Manager:
1. **Window → Package Manager**
2. Select **Google Sign-In** package
3. Expand **Samples**
4. Click **Import**

## Troubleshooting

### Android: "Developer Error" or "Error 10"

- Verify SHA-1 fingerprint in Google Cloud Console
- Verify package name matches
- Use correct keystore for signing

### Unity: Package not found

Use correct git URL:
```
https://github.com/GooDimuch/google-signin-unity.git#upm-package
```

## Links

- **Original Repository:** https://github.com/googlesamples/google-signin-unity
- **Google Sign-In Documentation:** https://developers.google.com/identity/sign-in/android
- **Unity Package Manager:** https://docs.unity3d.com/Manual/upm-ui-giturl.html

## License

Apache License 2.0 - See [LICENSE](LICENSE)

---

_Maintained by:_ [GooDimuch](https://github.com/GooDimuch)  
_Based on:_ [googlesamples/google-signin-unity](https://github.com/googlesamples/google-signin-unity)
