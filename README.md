# DenisovAV/homebrew-tap

Homebrew formulae for [litetune](https://github.com/DenisovAV/litetune).

```bash
brew install DenisovAV/tap/litetune
```

`litetune` fine-tunes, converts and verifies small models for on-device
inference, and measures what the conversion cost. It is also on PyPI:
`pip install litetune`.

Pinned to `python@3.12`: the stage environments litetune provisions pin
`numpy==2.0.2`, which publishes wheels up to cp312, so a newer interpreter would
put `convert` and `verify` out of reach on a fresh install.
