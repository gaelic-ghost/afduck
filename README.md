# afduck

`afduck` is a simple macOS command-line tool that ducks media app audio through Shortcuts, plays two cue sounds, plays a target audio file, then plays two more cue sounds before unducking on cleanup.

## Status

`afduck` currently works reliably from debug builds launched with `swift run`. The installed standalone binary path is still blocked by macOS automation behavior around the underlying Shortcuts/SoundSource step, so the current recommended workflow is repo-local debug execution.

## Requirements

- macOS
- Xcode / Swift toolchain with `swift` available
- A `duck-media-app-audio` shortcut installed in Shortcuts
- An `unduck-media-app-audio` shortcut installed in Shortcuts

## Build

```sh
swift build
```

## Run

```sh
swift run afduck <path>
```

Example:

```sh
swift run afduck ~/Music/example.wav
```

For repeated local use after an initial build:

```sh
swift run --skip-build afduck ~/Music/example.wav
```

## Behavior

1. Run the `duck-media-app-audio` shortcut.
2. Play the system `Pop` sound twice.
3. Play the target audio file.
4. Play the system `Pop` sound twice again.
5. Run the `unduck-media-app-audio` shortcut during cleanup before exit.

## Troubleshooting

- If the input path does not exist, `afduck` exits with a validation error.
- If either shortcut is missing or fails, `afduck` reports the shortcut failure and exits.
- If playback fails to start, `afduck` reports the playback error and exits.
- If the installed standalone binary fails with a generic Shortcuts error, use `swift run afduck <path>` for now. A more plug-and-play app-based approach is planned for `v2.0.0`.

## Roadmap

`v2.0.0` is intended to move `afduck` toward a more proper macOS app experience with App Intents and bundled shortcut integration so people can compose their own SoundSource automations without depending on the current debug-build-only workflow.
