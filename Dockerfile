FROM openjdk:8

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Android SDK Environment Variables
ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    ANDROID_HOME="/root/Android/Sdk" \
    ANDROID_VERSION=28 \
    ANDROID_BUILD_TOOLS_VERSION=27.0.3

# Download Android SDK
RUN mkdir -p ${ANDROID_HOME} .android \
    && cd ${ANDROID_HOME} \
    && curl -o sdk.zip $SDK_URL \
    && unzip sdk.zip \
    && rm sdk.zip \
    && yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses

# Install Android Build Tool and Libraries
RUN ${ANDROID_HOME}/tools/bin/sdkmanager --update
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"

ENV PATH ${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:$PATH

RUN wget -q https://services.gradle.org/distributions/gradle-5.4.1-all.zip \
    && unzip gradle-5.4.1-all.zip -d /root

ENV GRADLE_HOME /root/gradle-5.4.1
ENV GRADLE_USER_HOME /root/gradle-5.4.1
ENV PATH $PATH:/root/gradle-5.4.1/bin

# Install Node.js
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y curl git nano
RUN apt-get install -y build-essential
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs


RUN npm i -g react-native-cli
RUN react-native init example