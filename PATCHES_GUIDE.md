# Customizing ReVanced Extended Builds

**Please read the following information before beginning.**

By default the script will build ReVanced Extended with ALL default* patches. Edit `patches.txt` to customize your build of ReVanced Extended.

*Default: All patches except those which have to be ***included*** explicitly, i.e, using the `-i` flag while manually using the ReVanced CLI

## !IMPORTANT!
1. Each patch name MUST start from a NEWLINE AND there should be only ONE patch PER LINE
2. DO NOT add any other type of symbol or character, it will break the script! You have been warned!
3. Anything starting with a hash (`#`) will be ignored. Also, do not add hash or any other character after a patch's name
4. Both YT Music ReVanced Extended & YT ReVanced Extended are supported
5. DO NOT add `microg-patch`, `music-microg-patch`, `amoled`, and `theme` to the list of excluding patches.
6. `patches.txt` contains some predefined lines starting with `#`. DO NOT remove them.

## Example
Example content of `patches.txt`:

- Exclude ReVanced Extended settings and sponsorblock:
```
settings
sponsorblock
```

- Exclude patches for both Music & YouTube (order doesn't matter)
```
settings
exclusive-background-playback
sponsorblock
premium-heading
```

- Include patches for both Music & YouTube (order doesn't matter)
```
swipe-controls
translations
translations-music
```

## List of Available Patches

Refer to ReVanced Extended [list of available patches](https://github.com/inotia00/revanced-patches/tree/revanced-extended).
