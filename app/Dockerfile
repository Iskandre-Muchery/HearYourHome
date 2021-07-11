FROM cirrusci/flutter

COPY ./android ./android
COPY ./ios ./ios
COPY ./lib ./lib
COPY ./test ./test
COPY ./.metadata ./.metadata
COPY ./assets ./assets
COPY ./pubspec.lock ./pubspec.lock
COPY ./pubspec.yaml ./pubspec.yaml

RUN flutter pub get
RUN flutter build apk