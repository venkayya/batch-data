#!/usr/bin/env bash

export GOOGLE_APPLICATION_CREDENTIALS="/Users/venkayyanaidu/Desktop/serviceaccounts/venky-staging-82302db57d4c.json"
gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable dataproc.googleapis.com
gcloud services enable composer.googleapis.com
