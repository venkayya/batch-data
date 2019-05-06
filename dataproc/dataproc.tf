provider "google" {
  project     = "venky-staging"
  region      = "us-west1"
}

resource "google_dataproc_cluster" "mycluster" {
    name   = "dproc-cluster-unique-name"
    region = "us-west1"
}

# Submit an example spark job to a dataproc cluster
resource "google_dataproc_job" "spark" {
    region       = "${google_dataproc_cluster.mycluster.region}"
    force_delete = true
    placement {
        cluster_name = "${google_dataproc_cluster.mycluster.name}"
    }

    spark_config {
        main_class    = "org.apache.spark.examples.SparkPi"
        jar_file_uris = ["file:///usr/lib/spark/examples/jars/spark-examples.jar"]
        args          = ["1000"]

        properties    = {
            "spark.logConf" = "true"
        }

        logging_config {
            driver_log_levels = {
                "root" = "INFO"
            }
        }
    }
}

# Submit an example pyspark job to a dataproc cluster
resource "google_dataproc_job" "pyspark" {
    region       = "${google_dataproc_cluster.mycluster.region}"
    force_delete = true
    placement {
        cluster_name = "${google_dataproc_cluster.mycluster.name}"
    }

    pyspark_config {
        main_python_file_uri = "gs://dataproc-examples-2f10d78d114f6aaec76462e3c310f31f/src/pyspark/hello-world/hello-world.py"
        properties = {
            "spark.logConf" = "true"
        }
    }
}

# Check out current state of the jobs
output "spark_status" {
    value = "${google_dataproc_job.spark.status.0.state}"
}

output "pyspark_status" {
    value = "${google_dataproc_job.pyspark.status.0.state}"
}
