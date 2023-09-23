data "google_compute_image" "runner_image" {
  # Aspect's GCP aspect-workflows-images project provides public Aspect Workflows GCP images for
  # getting started during the trial period. We recommend that all Workflows users build their own
  # GCP images and keep up-to date with patches. See
  # https://docs.aspect.build/v/workflows/install/packer for more info and/or
  # https://github.com/aspect-build/workflows-images for example packer scripts and BUILD targets
  # for building GCP images for Workflows.
  project = "aspect-workflows-images"
  name    = "aspect-workflows-debian-11-gcc-1-3-0"
}

module "aspect_workflows" {
  # Aspect Workflows terraform module
  source = "https://s3.us-east-2.amazonaws.com/static.aspect.build/aspect/5.8.0-rc8/workflows-gcp/terraform-gcp-aspect-workflows.zip"

  # Network properties
  network    = google_compute_network.workflows_network.id
  subnetwork = google_compute_subnetwork.workflows_subnet.id

  # Number of nodes in the kubernetes cluster where the remote cache &
  # observability services run.
  cluster_standard_node_count = 3

  # Remote cache configuration
  remote = {
    cache_size_gb          = 384
    cache_shards           = 1
    replicate_cache        = false
    load_balancer_replicas = 1
  }

  # CI properties
  hosts = ["gha"]

  # Warming set definitions
  warming_sets = {
    default  = {}
  }

  # Resource types for use by runner groups
  resource_types = {
    default = {
      # Aspect Workflows requires machine types that have local SSD drives. See
      # https://cloud.google.com/compute/docs/machine-resource#machine_type_comparison for full list
      # of machine types availble on GCP.
      machine_type    = "n1-standard-4"
      image_id        = data.google_compute_image.runner_image.id
      use_preemptible = true
    }
  }

  # GitHub Actions runner group definitions
  gha_runner_groups = {
    # The default runner group is use for the main build & test workflows.
    default = {
      agent_idle_timeout_min    = 1
      gh_repo                   = "aspect-build/rules_jasmine"
      # Determine the workflow ID with:
      # gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /repos/aspect-build/rules_jasmine/actions/workflows
      # https://docs.github.com/en/rest/actions/workflows?apiVersion=2022-11-28#list-repository-workflows
      gha_workflow_ids          = ["67579950"]  # Aspect Workflows
      max_runners               = 5
      min_runners               = 0
      queue                     = "aspect-default"
      resource_type             = "default"
      scaling_polling_frequency = 1 # check for queued jobs every 60s
      warming                   = true
    }
    # The warming runner group is used for the periodic warming job that creates
    # warming archives for use by other runner groups.
    warming = {
      agent_idle_timeout_min = 1
      gh_repo                = "aspect-build/rules_jasmine"
      # Determine the workflow ID with:
      # gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /repos/aspect-build/rules_jasmine/actions/workflows
      # https://docs.github.com/en/rest/actions/workflows?apiVersion=2022-11-28#list-repository-workflows
      gha_workflow_ids       = ["67748654"]  # Aspect Workflows Warming
      max_runners            = 1
      min_runners            = 0
      queue                  = "aspect-warming"
      resource_type          = "default"
    }
  }

  # This varies by each customer. This one is dedicated to rules_jasmine.
  pagerduty_integration_key = "206053115b56430ad01704f7e01f3ff9"
}
