This project contains the Chef setup for a Jenkins-based CI/CD server for Chef cookbooks from [https://github.com/TYPO3-cookbooks/](https://github.com/TYPO3-cookbooks/).

## Contents

* Jenkins Setup
  - Install Jenkins LTS
  - Install Plugins
* Job Configuration
  - Seed job to generate the following (based on JobDSL)
  - Main _chef-repo_ job to validate and upload data bags, environments and roles
  - Multiple cookbook pipelines for cookbook testing and upload
* Feature Highlights
  - Fully automated job setup using JobDSL and Pipeline
  - Integration with Gerrit (for private main _chef-repo_) and Github (for cookbooks)
  - Parallelized execution of test-kitchen tests on different nodes
