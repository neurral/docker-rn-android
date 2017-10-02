FROM java:8

MAINTAINER Lee Alexis

# PARAMETERS
##############################################################################
# Noninteractive
ENV DEBIAN_FRONTEND noninteractive

# ALT 1 : Version refers to commandline tools (sdkmanager)
ENV ANDROID_CMD_TOOLS_VERSION 3859397
ENV ANDROID_CMD_TOOLS_URL https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_CMD_TOOLS_VERSION}.zip

# ALT 2 : SDK Tools (android update)
# ENV ANDROID_SDK_VERSION 25.2.3
# ENV ANDROID_SDK_URL https://dl.google.com/android/repository/tools_r${ANDROID_SDK_VERSION}-linux.zip

ENV ANDROID_API_VERSION 25
ENV ANDROID_BUILD_TOOLS_VERSION 25.0.3

ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_SDK /usr/local/android-sdk-linux

# Alt 1 ENV ANDROID_COMPONENTS
ENV ANDROID_COMPONENTS="platforms;android-26${ANDROID_API_VERSION} build-tools;${ANDROID_BUILD_TOOLS_VERSION} "
ENV GOOGLE_COMPONENTS="extras;android;m2repository extras;google;m2repository extras;google;google_play_services"

#Alt 2  platform-tools,build-tools-23.0.3,build-tools-24.0.0,build-tools-24.0.2,android-23,android-24
# ENV ANDROID_COMPONENTS platform-tools;android-${ANDROID_API_VERSION},build-tools-${ANDROID_BUILD_TOOLS_VERSION}
# ENV GOOGLE_COMPONENTS extra-android-m2repository,extra-google-m2repository


ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH

# DOWNLOAD REQUESTS
##############################################################################
# Install dependencies
#apt-get install -yq --no-install-recommends libc6:i386 libstdc++6:i386 zlib1g:i386 libncurses5:i386  wget unzip \
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -yq libc6:i386 libstdc++6:i386 zlib1g:i386 libncurses5:i386 unzip wget --no-install-recommends && \
    apt-get clean
 
# Alt 1 : SDK Tools from https://developer.android.com/studio/index.html
RUN wget -q -O sdk-tools.zip "${ANDROID_CMD_TOOLS_URL}"  --no-check-certificate && \
    mkdir -p $ANDROID_HOME && \
    unzip -q sdk-tools.zip && \
    mv tools $ANDROID_HOME && \
    rm -f sdk-tools.zip

# Alt 2 : Use Android SDK
# RUN curl -L "${ANDROID_SDK_URL}" | tar --no-same-owner -xz -C /usr/local
# ENV ANDROID_HOME /usr/local/android-sdk-linux
# ENV ANDROID_SDK /usr/local/android-sdk-linux
# ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH

# INSTALLATIONS
#############################################################################
# Confirms that we agreed on the Terms and Conditions of the SDK itself
# (if we didn’t the build would fail, asking us to agree on those terms).
RUN mkdir "${ANDROID_HOME}/licenses" || true
RUN echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > "${ANDROID_HOME}/licenses/android-sdk-license"
RUN echo "84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license"

# Install Android SDK components
# RU

RUN echo "Update Android SDK" && \
    echo y | $ANDROID_HOME/tools/bin/sdkmanager --update && \
    echo "Install android-ANDROID_API_VERSION" && \
    echo y | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-${ANDROID_API_VERSION}" && \
    echo "Install build-tools-${ANDROID_BUILD_TOOLS_VERSION}" && \
    echo y | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" && \
    echo "Install android-m2repository" && \
    echo y | $ANDROID_HOME/tools/bin/sdkmanager "extras;android;m2repository" && \
    echo "Install google-m2repository" && \
    echo y | $ANDROID_HOME/tools/bin/sdkmanager "extras;google;m2repository" && \
    echo "Install google_play_services" && \
    echo y | $ANDROID_HOME/tools/bin/sdkmanager "extras;google;google_play_services" && \
    echo "Terms and Conditions" && \
    echo y | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# POST-INSTALLATION
##############################################################################
# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp* /tmp/*


# Support Gradle
ENV TERM dumb
ENV JAVA_OPTS "-Xms512m -Xmx1024m"
ENV GRADLE_OPTS "-XX:+UseG1GC -XX:MaxGCPauseMillis=1000"
