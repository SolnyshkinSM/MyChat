#!/usr/bin/env bash

#pod install

xcodebuild \
    clean \
    test \
    -workspace "MyChat.xcworkspace" \
    -scheme "MyChat" \
    -destination "platform=iOS Simulator,name=iPhone 11,OS=14.4"

echo "YEEP!" 