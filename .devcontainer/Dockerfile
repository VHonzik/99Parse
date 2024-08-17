FROM ubuntu:jammy

RUN apt-get update

# Install pre-requisite packages for building Love and Love-Android from source
RUN apt-get install -y curl git build-essential autotools-dev automake libtool pkg-config \
libfreetype6-dev libluajit-5.1-dev libsdl2-dev libopenal-dev libogg-dev \
libvorbis-dev libmodplug-dev libmpg123-dev libtheora-dev libharfbuzz-dev \
unzip cmake

# Build Lua 5.4.7 from source
# Note: Love comes with it's own Lua interpreter LuaJIT and also some Lua 5.3 features so this not required
# RUN curl -R -O https://www.lua.org/ftp/lua-5.4.7.tar.gz && \
# tar zxf lua-5.4.7.tar.gz && \
# cd lua-5.4.7 && \
# make all test && \
# make all install

# Build Love 11.5 from source
ARG LOVE_VERSION=11.5
RUN git clone --depth 1 -b ${LOVE_VERSION} https://github.com/love2d/love && \
cd love && \
./platform/unix/automagic && \
./configure && \
make && \
make install

# Install Java JDK 22 needed for Android SDK command line tools
RUN curl -R -O https://download.java.net/java/GA/jdk22.0.2/c9ecb94cd31b495da20a27d4581645e8/9/GPL/openjdk-22.0.2_linux-x64_bin.tar.gz && \
tar xzf openjdk-22.0.2_linux-x64_bin.tar.gz

# Temporarily set JAVA_HOME to JDK 22
ARG JAVA_HOME=/jdk-22.0.2

# Install Android command line tools and using them install Android SDK and NDK
ARG ANDROID_NDK_VERSION="ndk;26.1.10909125"
ARG ANDROID_SDK_VERSION="platforms;android-34"
RUN curl -R -O https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
mkdir -p android_sdk/cmdline-tools/latest && \
unzip commandlinetools-linux-11076708_latest.zip && \
mv cmdline-tools/* android_sdk/cmdline-tools/latest/ && \
rmdir cmdline-tools/ && \
yes | ./android_sdk/cmdline-tools/latest/bin/sdkmanager ${ANDROID_NDK_VERSION} ${ANDROID_SDK_VERSION}

# ANROID_HOME is now ready for Love Android build process
ENV ANDROID_HOME=/android_sdk

# Install Java JDK 17 required for Love Android
RUN curl -R -O https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz && \
tar xzf openjdk-17_linux-x64_bin.tar.gz

# Permanently set JAVA_HOME for Love Android
ENV JAVA_HOME=/jdk-17

# Install Love Android and build APK to speed up the build process
ARG LOVE_ANDROID_VERSION=11.5a
RUN git clone --recurse-submodules --depth 1 -b ${LOVE_ANDROID_VERSION} https://github.com/love2d/love-android && \
cd love-android && \
./gradlew assembleNormalRecord
