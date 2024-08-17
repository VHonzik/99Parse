# 99 Parse

99 Parse is an competitive action game currently being developed for Android.

Do you have what it takes to achieve the much-coveted <span style="color: #e268a8">ninety-ninth percentile</span> parse? Learn the rotation by heart, put in the practice and in a quick burst of action, you too can come up on the top.

## Compilation

### Prerequisites

This repo contains devcontainer with a Docker image to use with VS Code. You will need following for smooth experience:
- [Docker](https://www.docker.com/)
- [VS Code](https://code.visualstudio.com/)
- [VS Code Extension: Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

Once you have those, make sure Docker engine is running and open this repo in VS Code. You should be automatically prompted to `Reopen in Container`. If you are not, you can also do so from VS Code Command Palette (Ctrl+Shift+P) -> `Dev Containers: Reopen in Container`.

In the container itself, following VS Code extensions are installed for your convenience:

- [Lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) Language server with Love addon
- [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)

Word of warning, the container is rather large,  over 10GB. It builds Love from source so it needs a lot of building tools and also Android SDK/NDK.

### Building Android packages

Simply run `./build.sh --mode=Debug` in the container which will output debug APK to `output/Debug`. See `./build.sh -h` for detailed help.
 