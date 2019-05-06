gcloud config set core/project venky-staging

gcloud compute networks create composer \
      --bgp-routing-mode regional \
      --description "test network for composer" \
      --subnet-mode custom

gcloud compute networks subnets create composer-test-subnetwork \
    --network composer \
    --range 10.2.0.0/16 \
    --description "test subnet for composer" \
    --region us-central1

gcloud iam service-accounts create composer-env-account \
    --display-name "Compose test Service Account" \
    --project venky-staging

gcloud iam service-accounts add-iam-policy-binding \
    composer-env-account@venky-staging.iam.gserviceaccount.com \
    --member serviceAccount:composer-env-account@venky-staging.iam.gserviceaccount.com \
    --role roles/composer.admin

gcloud projects add-iam-policy-binding venky-staging \
  --member serviceAccount:composer-env-account@venky-staging.iam.gserviceaccount.com \
  --role roles/composer.admin

gcloud composer environments create my-env \
    --network composer-test-network \
    --subnetwork composer-test-subnetwork \
    --location us-central1 \
    --zone us-central1-a \
    --machine-type n1-standard-2 \
    --labels env=test \
    --service-account composer-env-account@venky-staging.iam.gserviceaccount.com
