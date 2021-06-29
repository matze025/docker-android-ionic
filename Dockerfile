FROM     ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_HOME=/opt/android-sdk \
    NODE_VERSION=9.4.0 \
    NPM_VERSION=5.6.0 \
    IONIC_VERSION=4.10.2 \
    CORDOVA_VERSION=8.1.2 \
    GRADLE_VERSION=3.3


# Install basics
RUN apt-get update &&  \
    apt-get install -y git wget curl unzip ruby ruby-dev gcc make && \
    curl --retry 3 -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" && \
    tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 && \
    rm "node-v$NODE_VERSION-linux-x64.tar.gz" && \
    npm install -g npm@"$NPM_VERSION" && \
    npm install -g cordova@"$CORDOVA_VERSION" ionic@"$IONIC_VERSION" && \
    npm cache clear --force && \
    gem install sass
RUN ionic config set -g backend legacy


#ANDROID 
#JAVA
RUN apt-get update && apt-get install -y openjdk-8-jdk openjdk-8-doc openjdk-8-jre-headless openjdk-8-source 

#ANDROID STUFF
RUN echo ANDROID_HOME="${ANDROID_HOME}" >> /etc/environment && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --force-yes expect ant wget zipalign libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 qemu-kvm kmod && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Android SDK
RUN mkdir -p /opt/android-sdk && \
	cd /opt/android-sdk && \
    wget -O android-sdk-tools.zip --quiet https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
    unzip android-sdk-tools.zip && \
    rm -f android-sdk-tools.zip && \
    chown -R root. /opt

# Accept Licence and install sdk's
RUN yes | /opt/android-sdk/tools/bin/sdkmanager --licenses
RUN /opt/android-sdk/tools/bin/sdkmanager "tools" "platform-tools"
RUN yes | /opt/android-sdk/tools/bin/sdkmanager \
    "platforms;android-29" \
    "platforms;android-27" \
    "platforms;android-26" \
    "platforms;android-25" \
    "platforms;android-24" \
    "platforms;android-23" \
    "platforms;android-22" \
    "build-tools;29.0.3" \
    "build-tools;27.0.1" \
    "build-tools;27.0.0" \
    "build-tools;26.0.2" \
    "build-tools;26.0.1" \
    "build-tools;25.0.3" \
    "build-tools;24.0.3" \
    "build-tools;23.0.3" \
    "build-tools;22.0.1" \
    "extras;android;m2repository" \
    "extras;google;m2repository" \
    "extras;google;google_play_services" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.1" \
    "add-ons;addon-google_apis-google-23" \
    "add-ons;addon-google_apis-google-22" 
    
    
# install gradle
RUN cd /opt && \
    rm -rf gradle && \
    mkdir /opt/gradle && \
    cd /opt/gradle && \
    curl --retry 3 -SLO "https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" && \
    unzip -d /opt/gradle gradle-${GRADLE_VERSION}-bin.zip && \
    rm -f gradle-${GRADLE_VERSION}-bin.zip


# Setup environment

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:/opt/gradle/gradle-${GRADLE_VERSION}/bin
ENV GRADLE_HOME=/opt/gradle/gradle-${GRADLE_VERSION}/libexec/


RUN mkdir -p /workdir

WORKDIR /workdir

EXPOSE 8100 35729
