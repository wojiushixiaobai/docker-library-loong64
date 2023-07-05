#!/bin/bash

function sort-versions() {
    if [ "$(uname)" == 'Darwin' ]; then
        gsort --version-sort
    else
        sort --version-sort
    fi
}

all_jenkins_versions="$(curl --disable --fail --silent --show-error --location \
        https://repo.jenkins-ci.org/releases/org/jenkins-ci/main/jenkins-war/maven-metadata.xml \
    | grep '<version>.*</version>')"

latest_lts_version="$(echo "${all_jenkins_versions}" | grep -E -o '[0-9]\.[0-9]+\.[0-9]' | sort-versions | tail -n1)"
JENKINS_VERSION=${latest_lts_version}
JENKINS_SHA="$(curl --disable --fail --silent --show-error --location "https://repo.jenkins-ci.org/releases/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war.sha256")"

docker buildx build \
    --build-arg JENKINS_VERSION=${JENKINS_VERSION} \
    --build-arg JENKINS_SHA=${JENKINS_SHA} \
    --build-arg COMMIT_SHA=${COMMIT_SHA} \
    --build-arg RELEASE_LINE=war-stable \
    --tag jenkins:lts-jdk17 \
    --tag jenkins:${JENKINS_VERSION}-lts-jdk17 \
    --push \
    .

latest_weekly_version="$(echo "${all_jenkins_versions}" | grep -E -o '[0-9]\.[0-9]+' | sort-versions | tail -n 1)"
JENKINS_VERSION=${latest_weekly_version}
JENKINS_SHA="$(curl --disable --fail --silent --show-error --location "https://repo.jenkins-ci.org/releases/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war.sha256")"

docker buildx build \
    --build-arg JENKINS_VERSION=${JENKINS_VERSION} \
    --build-arg JENKINS_SHA=${JENKINS_SHA} \
    --build-arg RELEASE_LINE=war \
    --tag jenkins:jdk17 \
    --tag jenkins:${JENKINS_VERSION}-jdk17 \
    --push \
    .