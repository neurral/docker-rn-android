# based on https://registry.hub.docker.com/u/samtstern/android-sdk/dockerfile/ with openjdk-8
FROM openjdk:8

MAINTAINER FUJI Goro <g.psy.va+github@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
# Get the latest version from https://developer.android.com/studio/index.html
ENV ANDROID_SDK_VERSION="25.2.3"

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -yq libc6:i386 libstdc++6:i386 zlib1g:i386 libncurses5:i386 --no-install-recommends && \
    apt-get clean

# Download and untar SDK 25.2.3"
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/tools_r${ANDROID_SDK_VERSION}-linux.zip
RUN curl -L "${ANDROID_SDK_URL}" | tar --no-same-owner -xz -C /usr/local
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_SDK /usr/local/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH

# Install Android SDK components

# License Id: android-sdk-license-ed0d0a5b
#ENV ANDROID_COMPONENTS platform-tools,build-tools-23.0.3,build-tools-24.0.0,build-tools-24.0.2,android-23,android-24
ENV ANDROID_COMPONENTS platform-tools,build-tools-25.0.3,android-25
# License Id: android-sdk-license-5be876d5
ENV GOOGLE_COMPONENTS extra-android-m2repository,extra-google-m2repository

RUN echo y | android update sdk --no-ui --all --filter "${ANDROID_COMPONENTS}" ; \
    echo y | android update sdk --no-ui --all --filter "${GOOGLE_COMPONENTS}"

# Support Gradle
ENV TERM dumb
ENV JAVA_OPTS "-Xms512m -Xmx1024m"
ENV GRADLE_OPTS "-XX:+UseG1GC -XX:MaxGCPauseMillis=1000"

# Confirms that we agreed on the Terms and Conditions of the SDK itself
# (if we didn’t the build would fail, asking us to agree on those terms).
RUN mkdir "${ANDROID_HOME}/licenses" || true
RUN echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > "${ANDROID_HOME}/licenses/android-sdk-license"
RUN echo "84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license"