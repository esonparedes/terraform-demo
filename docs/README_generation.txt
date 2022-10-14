To generate a new readme.md, install terraform-docs, and put in the the PATH env var.
https://github.com/terraform-docs/terraform-docs/releases

Afterwards, run this from root directory:

terraform-docs --header-from docs/header.txt --footer-from docs/footer.txt md . > README.md