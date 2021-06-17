FROM amazoncorretto:8u292-alpine

ARG ANDROID_COMPILE_SDK='29'
ARG ANDROID_BUILD_TOOLS='28.0.3'
ARG ANDROID_SDK_TOOLS='6200805'

ENV ANDROID_HOME=/opt/android-sdk-linux \
    PATH="/opt/android-sdk-linux/tools:/opt/android-sdk-linux/platform-tools:/opt/android-sdk-linux/tools/bin:/opt/android-sdk-linux/emulator:$PATH"

RUN apk update && apk add bash curl git unzip && rm -Rf /var/cache/apk/*

# Add license to SDK
COPY licenses/android-sdk-license /opt/android-sdk-linux/licenses/android-sdk-license

# Install Android SDK
RUN curl -sSL https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS}_latest.zip > /tmp/android-sdk-linux.zip \
    && unzip /tmp/android-sdk-linux.zip -d /opt/android-sdk-linux/ \
    && rm /tmp/android-sdk-linux.zip \
    \
    && yes | sdkmanager --no_https --licenses --sdk_root=${ANDROID_HOME} \
    \
    && sdkmanager --sdk_root=${ANDROID_HOME} --verbose tools platform-tools \
      "platforms;android-${ANDROID_COMPILE_SDK}" \
      "build-tools;${ANDROID_BUILD_TOOLS}" \
    \
    && rm -r ${ANDROID_HOME}/emulator \
    && unset ANDROID_NDK_HOME
