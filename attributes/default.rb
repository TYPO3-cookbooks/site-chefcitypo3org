#################
# URLs
#################

#<> Public URL of the Jenkins master
default['site-chefcitypo3org']['url'] = "https://chef-ci.typo3.org"

#<> URL of the main chef repo
default['site-chefcitypo3org']['main_repo'] = "ssh://chef-jenkins@review.typo3.org:29418/Teams/Server/Chef.git"

#<> URL of the CHef Server
default['jenkins_chefci']['knife_config']['chef_server_url'] = 'https://chef.typo3.org'

#<> Install Jenkins LTS
default['jenkins']['master']['repository'] = "http://pkg.jenkins-ci.org/debian-stable"

#<> Use this Github organization to read cookbooks from
default['jenkins_chefci']['github_organization'] = 'TYPO3-cookbooks'

#################
# Jenkins Config
#################
default['jenkins']['master']['jvm_options'] = '-Djenkins.install.runSetupWizard=false -XX:MaxPermSize=256m'

#################
# Java
#################

#<> Okay, Oracle, we hate you
default['java']['oracle']['accept_oracle_download_terms'] = true

#################
# Jenkins Plugins
#################

#<> List of plugins to install
# Plugins:
# Retrieve this list via Jenkins Script console:
#
# Jenkins.instance.pluginManager.plugins.sort().each{ plugin -> println ("${plugin.getShortName()}:${plugin.getVersion()}") }
#
default['jenkins_chefci']['jenkins_plugins'] = %w(
  ace-editor:1.1
  allure-jenkins-plugin:2.18
  analysis-collector:1.51
  analysis-core:1.87
  ansicolor:0.5.0
  ant:1.5
  antisamy-markup-formatter:1.5
  authentication-tokens:1.3
  autocomplete-parameter:1.0
  blueocean:1.1.1
  blueocean-autofavorite:1.0.0
  blueocean-commons:1.1.1
  blueocean-config:1.1.1
  blueocean-dashboard:1.1.1
  blueocean-display-url:2.0
  blueocean-events:1.1.1
  blueocean-git-pipeline:1.1.1
  blueocean-github-pipeline:1.1.1
  blueocean-i18n:1.1.1
  blueocean-jwt:1.1.1
  blueocean-personalization:1.1.1
  blueocean-pipeline-api-impl:1.1.1
  blueocean-pipeline-editor:0.2.0
  blueocean-pipeline-scm-api:1.1.1
  blueocean-rest:1.1.1
  blueocean-rest-impl:1.1.1
  blueocean-web:1.1.1
  bouncycastle-api:2.16.1
  branch-api:2.0.10
  buildtriggerbadge:2.8.1
  clone-workspace-scm:0.6
  cloudbees-folder:6.0.4
  credentials:2.1.14
  credentials-binding:1.12
  display-url-api:2.0
  docker-commons:1.7
  docker-workflow:1.12
  durable-task:1.14
  embeddable-build-status:1.9
  external-monitor-job:1.7
  favorite:2.3.0
  gerrit-trigger:2.23.3
  git:3.3.0
  git-client:2.4.6
  git-server:1.7
  github:1.27.0
  github-api:1.85.1
  github-branch-source:2.0.6
  github-oauth:0.27
  github-organization-folder:1.6
  greenballs:1.15
  handlebars:1.1.1
  icon-shim:2.0.3
  jackson2-api:2.7.3
  javadoc:1.4
  job-dsl:1.63
  jquery-detached:1.2.1
  junit:1.20
  ldap:1.15
  mailer:1.20
  matrix-auth:1.6
  matrix-project:1.11
  maven-plugin:2.16
  metrics:3.1.2.10
  momentjs:1.1.1
  pam-auth:1.3
  pipeline-build-step:2.5
  pipeline-github-lib:1.0
  pipeline-graph-analysis:1.4
  pipeline-input-step:2.7
  pipeline-milestone-step:1.3.1
  pipeline-model-api:1.1.6
  pipeline-model-declarative-agent:1.1.1
  pipeline-model-definition:1.1.6
  pipeline-model-extensions:1.1.6
  pipeline-rest-api:2.8
  pipeline-stage-step:2.2
  pipeline-stage-tags-metadata:1.1.6
  pipeline-stage-view:2.8
  piwikanalytics:1.2.0
  plain-credentials:1.4
  PrioritySorter:3.5.0
  pubsub-light:1.8
  scm-api:2.1.1
  script-security:1.29
  slack:2.2
  sse-gateway:1.15
  ssh-credentials:1.13
  structs:1.8
  token-macro:2.1
  variant:1.1
  view26:1.0.4
  warnings:4.62
  windows-slaves:1.3.1
  workflow-aggregator:2.5
  workflow-api:2.17
  workflow-basic-steps:2.5
  workflow-cps:2.36
  workflow-cps-global-lib:2.8
  workflow-durable-task-step:2.12
  workflow-job:2.11
  workflow-multibranch:2.15
  workflow-scm-step:2.5
  workflow-step-api:2.11
  workflow-support:2.14
)
