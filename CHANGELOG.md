# Changelog

All notable changes to this package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.4] - 2025-10-16

### Added
- Unity Package Manager (UPM) support with proper package structure
- `package.json` in root for UPM compatibility
- Comprehensive `README.md` with usage examples and setup instructions
- `CHANGELOG.md` for version tracking
- Sample scene in `Samples~/SignInSample/`

### Changed
- **Restructured to UPM layout:**
  - Moved runtime C# scripts to `Runtime/`
  - Moved editor scripts and dependencies to `Editor/`
  - Moved native iOS plugins to `Plugins/`
  - Moved samples to `Samples~/SignInSample/`
  - Moved third-party licenses to `Third Party Notices~/`
- Removed build infrastructure files (gradle, native-googlesignin, staging)
- Cleaned up unnecessary files for UPM distribution

### Notes
- This is a clean UPM package based on the original Google Sign-In plugin
- Uses legacy GoogleApiClient API for Android compatibility (6.0+)
- iOS Unity 6 compatibility fix will be added in next version

## [1.0.3] - 2017 (Original)

### Initial Release by Google
- Android support using GoogleApiClient API
- iOS support using Google Sign-In SDK
- ID Token and Server Auth Code support
- Silent sign-in capability
- Firebase Authentication compatibility

---

## Branch Information

- **`upm-package`** - Clean UPM structure (recommended)
- **`master`** - Original structure from googlesamples

---

_Maintained by:_ [GooDimuch](https://github.com/GooDimuch)  
_Based on:_ [googlesamples/google-signin-unity](https://github.com/googlesamples/google-signin-unity)

