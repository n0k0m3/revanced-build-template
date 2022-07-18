# Customizing ReVanced Builds

**Please read the following information before beginning.**

By default the script will build ReVanced with ALL available patches. Edit `patches.txt` to customize your build of ReVanced.

## !IMPORTANT!
1. Each patch name MUST start from a NEWLINE AND there should be only ONE patch PER LINE
2. DO NOT add any other type of symbol or character, it will break the script! You have been warned!
3. Anything starting with a hash (`#`) will be ignored. Also, do not add hash or any other character after a patch's name
4. Both YT Music ReVanced & YT ReVanced are supported
5. Patches are EXCLUSION, by default all patches will be included in the build.
6. DO NOT add `microg-patch` to the list of excluding patches.

## Example
Example content of `patches.txt`:

- Exclude pure black theme and keep `create` button:
```
amoled
disable-create-button
```

- Exclude patches for both Music & YouTube (order doesn't matter)
```
amoled
exclusive-background-playback
disable-create-button
premium-heading
tasteBuilder-remover
```

## List of Available Patches

Refer to Official ReVanced [list of available patches](https://github.com/revanced/revanced-patches#list-of-available-patches).