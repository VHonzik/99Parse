#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error when substituting.
set -o pipefail # the return value of a pipeline is the status of the last command to exit with a non-zero status

# Build variables
CLEAN=false
MODE=Release
AAB=false

# Meta data
# TODO get these from a file
APP_NAME=99Parse
CODE_VERSION=1
MAJOR_VERSION=0
MINOR_VERSION=1
COMMIT_SHA=$(git rev-parse --short HEAD)

# Help page
help() {
  echo "Usage: build.sh [OPTION...]"
  echo "Build Android package for the 99 Parse to the output/ directory."
  echo
  echo "Examples:"
  echo "  ./build.sh --mode=Debug  # Build 99 Parse Debug APK."
  echo "  ./build.sh --aab         # Build 99 Parse Release AAB."
  echo
  echo "Options:"
  echo "  --mode=MODE        build in Release or Debug mode (defaults to Release)"
  echo "  --aab              build Android Application Bundle (AAB) package instead of Android Application Package (APK)"
  echo "  --clean            clean the output directory and exit"
  echo "  --help             print this help page and exit"
  echo
}

for i in "$@"; do
  case $i in
    -h|--help)
      help
      exit 0
      ;;
    --mode=*)
      MODE="${i#*=}"
      shift # past argument=value
      ;;
    --clean)
      CLEAN=true
      shift # past argument with no value
      ;;
    --aab)
      AAB=true
      shift # past argument with no value
      ;;
    -*|--*)
      echo "Unknown option $i"
      help
      exit 1
      ;;
    *)
      ;;
  esac
done

if [ "$CLEAN" = true ] ; then
  echo ======================= Cleaning the build files =======================
  rm -rf output/*
  exit 0
fi

MODE_LOWERCASE=${MODE,,}
mkdir -p output/$MODE

echo ======================== Updating version file =========================
cat <<EOF > src/version.lua
local version = {}
version.fullString="$MAJOR_VERSION.$MINOR_VERSION.$COMMIT_SHA"
return version
EOF

echo ================== Copying game files to Love Android ==================
cp src/* /love-android/app/src/embed/assets
cp assets/icon-72x72.png    /love-android/app/src/main/res/drawable-hdpi/love.png
cp assets/icon-48x48.png    /love-android/app/src/main/res/drawable-mdpi/love.png
cp assets/icon-96x96.png    /love-android/app/src/main/res/drawable-xhdpi/love.png
cp assets/icon-144x144.png  /love-android/app/src/main/res/drawable-xxhdpi/love.png
cp assets/icon-192x192.png  /love-android/app/src/main/res/drawable-xxxhdpi/love.png
echo Done

echo ====================== Building Android package ========================
pushd /love-android

# Generate gradle.properties
cat <<EOF > gradle.properties
app.name=$APP_NAME

app.application_id=org.love2d.android
app.orientation=landscape
app.version_code=$CODE_VERSION
app.version_name=$MAJOR_VERSION.$MINOR_VERSION.$COMMIT_SHA

android.enableJetifier=false
android.useAndroidX=true
android.defaults.buildfeatures.buildconfig=true
android.nonTransitiveRClass=true
android.nonFinalResIds=true
EOF

OUTPUT_NAME="app-embed-noRecord-$MODE_LOWERCASE"
if [ "$AAB" = "true" ] ; then
  BUILD_COMMAND="bundleEmbedNoRecord$MODE"
  OUTPUT_PATH="app/build/outputs/bundle/embedNoRecord$MODE"
  OUTPUT_EXTENSION=".aab"
else
  BUILD_COMMAND="assembleEmbedNoRecord$MODE"
  OUTPUT_PATH="app/build/outputs/apk/embedNoRecord/$MODE_LOWERCASE"
  OUTPUT_EXTENSION=".apk"
  if [ "$MODE" = "Release" ] ; then
    OUTPUT_NAME="app-embed-noRecord-$MODE_LOWERCASE-unsigned"
  fi
fi

./gradlew $BUILD_COMMAND
cp $OUTPUT_PATH/$OUTPUT_NAME$OUTPUT_EXTENSION $SCRIPT_DIR/output/$MODE/99parse$OUTPUT_EXTENSION
popd

echo
echo "Build succesfull! You can find the build output here: output/$MODE/99parse$OUTPUT_EXTENSION"