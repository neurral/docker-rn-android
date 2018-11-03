FROM openjdk:8

# PARAMETERS
##############################################################################

# Noninteractive
ENV DEBIAN_FRONTEND noninteractive

# ALT 1 : Version refers to commandline tools (sdkmanager)
ENV ANDROID_CMD_TOOLS_VERSION 3859397
ENV ANDROID_CMD_TOOLS_URL https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_CMD_TOOLS_VERSION}.zip

ENV ANDROID_API_VERSION 26
ENV ANDROID_BUILD_TOOLS_VERSION 27.0.3

ENV ANDROID_HOME /usr/local/android-sdk-linux

ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH

ENV NODE_VERSION 8.10
ENV NVM_VERSION 0.33.11 # see https://github.com/creationix/nvm

# DOWNLOAD REQUESTS
##############################################################################

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -yq libc6:i386 libstdc++6:i386 zlib1g:i386 libncurses5:i386 unzip wget --no-install-recommends && \
    apt-get clean
 
# SDK Tools from https://developer.android.com/studio/index.html
RUN wget -q -O sdk-tools.zip "${ANDROID_CMD_TOOLS_URL}"  --no-check-certificate && \
    mkdir -p $ANDROID_HOME && \
    unzip -q sdk-tools.zip && \
    mv tools $ANDROID_HOME && \
    rm -f sdk-tools.zip

# INSTALLATIONS
#############################################################################

# Confirms that we agreed on the Terms and Conditions of the SDK itself
# (if we didn’t the build would fail, asking us to agree on those terms).
# Updated Hash for android-sdk-license
RUN mkdir -p "${ANDROID_HOME}/licenses" || true && \
    echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "${ANDROID_HOME}/licenses/android-sdk-license" && \
    echo -e "\nd56f5187479451eabf01fb78af6dfcb131a6481e" > "${ANDROID_HOME}/licenses/android-sdk-license" && \
    echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "${ANDROID_HOME}/licenses/android-sdk-preview-license"

#TODO set license hash for the following    
#android-googletv-license
#mips-android-sysimage-license
#google-gdk-license


RUN echo "Terms and Conditions" && \
    echo y | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# Install Android SDK components following our version
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
    echo y | $ANDROID_HOME/tools/bin/sdkmanager "extras;google;google_play_services"
    
    
# Install NVM to install NODE, then react-native-cli
RUN echo "Download Node version manager" && \
    (curl -o- https://raw.githubusercontent.com/creationix/nvm/v${NVM_VERSION}/install.sh | bash) && \
    command -v nvm && \
    echo "Install Node" && \
    nvm install $NODE_VERSION && nvm use $NODE_VERSION && \
    node -v && npm -v && \
    echo "Install React-Native CLI" && \
    npm i -g react-native-cli


# POST-INSTALLATION
##############################################################################

# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp* /tmp/*

# Support Gradle
ENV TERM dumb
ENV JAVA_OPTS "-Xms512m -Xmx1024m"
ENV GRADLE_OPTS "-XX:+UseG1GC -XX:MaxGCPauseMillis=1000"

RUN echo "Installed."

# TODOs
# in your pipelines or CI, do normal npm install, react-native build trigger, then, cd to /android and run gradle for the builds
# See your gradle scripts for the script name (somthing like app:assembleDebug or similar)
