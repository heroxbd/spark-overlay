#!/usr/bin/env bash

run_test() {
    USE="binary" emerge -1 dev-java/kotlin-stdlib{,-js} dev-java/kotlin-reflect
    USE="javascript" emerge dev-lang/kotlin-bin
    emerge -1 dev-java/kotlin-stdlib{,-js} dev-java/kotlin-reflect
    emerge dev-java/kotlin-stdlib-jdk8
    FEATURES="test" emerge -1 \
        dev-java/kotlin-stdlib{,-jdk7,-jdk8} \
        dev-java/kotlin-test{,-junit,-annotations-common}
}