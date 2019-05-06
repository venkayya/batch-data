gcloud config set core/project venky-staging

gcloud composer environments delete my-env \
    --service-account composer-env-account@venky-staging.iam.gserviceaccount.com

gcloud iam service-accounts remove-iam-policy-binding \
    composer-env-account@venky-staging.iam.gserviceaccount.com \
    --member serviceAccount:composer-env-account@venky-staging.iam.gserviceaccount.com \
    --role roles/composer.admin

gcloud iam service-accounts delete composer-env-account

gcloud compute networks subnets delete composer-test-subnetwork \
    --network composer

gcloud compute networks delete composer
