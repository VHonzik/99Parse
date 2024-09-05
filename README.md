# 99 Parse

99 Parse is an competitive action game being developed for Android.

Do you have what it takes to achieve the much-coveted <span style="color: #e268a8">ninety-ninth percentile</span> parse? Learn the rotation by heart, put in the practice and in a quick burst of action, you too can come up on the top.

## Building

If you just want to run the game, simply point [Löve](https://www.love2d.org/) binary at the `src/` folder and you should be good to go. However, if you would like obtain full-featured development environment and build Android package of the game, please proceed.

### Prerequisites

This repo contains devcontainer with a Docker image to use with VS Code. You will need following to make it all click:
- [Docker](https://www.docker.com/)
- [VS Code](https://code.visualstudio.com/)
- [VS Code Extension: Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

Once you have those, make sure Docker engine is running and open this repo in VS Code. You should be automatically prompted to `Reopen in Container`. If you are not, you can also do so from VS Code Command Palette (Ctrl+Shift+P) -> `Dev Containers: Reopen in Container`.

In the container itself, following VS Code extensions are installed for your convenience:

- [Lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) Language server with Love addon
- [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)

Word of warning, the container is rather large, over 10GB. It is Ubuntu based, it fetches the right version of Android SDK&NDK and builds Love from source, so it needs a lot of tools.

### Building Android packages

Run `./build.sh --mode=Debug` in the container which will output debug APK to `output/Debug`. See `./build.sh -h` for detailed help. VS Code Task `Build Debug APK` is also provided for convenience.

### Running and Debugging inside the container

Run `./run.sh` to launch the project inside the container. For debugging, [Debugger.lua](https://github.com/slembcke/debugger.lua) library is included. You can add breakpoint anywhere in the code base with this one-liner:
```lua
dbg()
```

Instructions for how to use the debugger can be found [here](https://github.com/slembcke/debugger.lua?tab=readme-ov-file#-debugger-commands).
 