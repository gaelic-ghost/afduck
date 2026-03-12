# ROADMAP

## v2.0.0

Target a more plug-and-play macOS app version of `afduck` with a stable app identity and bundled automation hooks.

Planned direction:

- Move beyond the current SwiftPM-only CLI packaging toward a more proper app-backed distribution model.
- Expose App Intents so users can integrate `afduck` behavior into their own Shortcuts flows.
- Support user-configurable SoundSource automation rather than hard-coding a single duck/unduck shortcut pair.
- Preserve the current audio behavior: cue sounds, target playback, and cleanup/restore flow.
- Reduce or eliminate the current dependency on running from `swift run` debug builds for reliable automation behavior.
