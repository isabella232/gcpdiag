/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "random_string" "project_id_suffix" {
  length  = 8
  number  = true
  lower   = true
  upper   = false
  special = false
}

resource "google_project" "project" {
  name            = "gcpdiag test - fw-policy"
  project_id      = "gcpdiag-fw-policy-${random_string.project_id_suffix.id}"
  billing_account = var.billing_account_id
  folder_id       = "folders/${var.sub_folder_id}"
  labels = {
    gcpdiag : "test"
  }
}

resource "google_project_service" "compute" {
  project = google_project.project.project_id
  service = "compute.googleapis.com"
}

data "google_folder" "parent" {
  folder              = "folders/${var.parent_folder_id}"
  lookup_organization = true
}

data "google_folder" "sub" {
  folder = "folders/${var.sub_folder_id}"
}

data "google_compute_network" "default" {
  project = google_project.project.project_id
  name    = "default"
}

output "project_id" {
  value = google_project.project.project_id
}

output "project_id_suffix" {
  value = random_string.project_id_suffix.id
}

output "project_nr" {
  value = google_project.project.number
}

output "org_id" {
  value = regex("organizations/(\\d+)", data.google_folder.parent.organization)[0]
}

output "folder_id_1" {
  value = regex("folders/(\\d+)", data.google_folder.parent.id)[0]
}

output "folder_id_2" {
  value = regex("folders/(\\d+)", data.google_folder.sub.id)[0]
}
