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
# Jenkins.instance.pluginManager.plugins.sort().each{ plugin -> println ("  ${plugin.getShortName()}:${plugin.getVersion()}") }
#
default['jenkins_chefci']['jenkins_plugins'] = %w(
  ace-editor:1.1
  analysis-collector:1.52
  analysis-core:1.92
  ansicolor:0.5.2
  ant:1.7
  antisamy-markup-formatter:1.5
  authentication-tokens:1.3
  aws-credentials:1.21
  aws-java-sdk:1.11.119
  blueocean:1.2.0
  blueocean-autofavorite:1.0.0
  blueocean-bitbucket-pipeline:1.2.0
  blueocean-commons:1.2.0
  blueocean-config:1.2.0
  blueocean-dashboard:1.2.0
  blueocean-display-url:2.1.0
  blueocean-events:1.2.0
  blueocean-git-pipeline:1.2.0
  blueocean-github-pipeline:1.2.0
  blueocean-i18n:1.2.0
  blueocean-jwt:1.2.0
  blueocean-personalization:1.2.0
  blueocean-pipeline-api-impl:1.2.0
  blueocean-pipeline-editor:1.2.0
  blueocean-pipeline-scm-api:1.2.0
  blueocean-rest:1.2.0
  blueocean-rest-impl:1.2.0
  blueocean-web:1.2.0
  bouncycastle-api:2.16.2
  branch-api:2.0.11
  buildtriggerbadge:2.8.1
  clone-workspace-scm:0.6
  cloudbees-bitbucket-branch-source:2.2.3
  cloudbees-folder:6.1.2
  credentials:2.1.14
  credentials-binding:1.13
  display-url-api:2.0
  docker-commons:1.8
  docker-workflow:1.12
  durable-task:1.14
  ec2:1.36
  embeddable-build-status:1.9
  external-monitor-job:1.7
  favorite:2.3.0
  gerrit-trigger:2.25.0
  git:3.5.1
  git-client:2.5.0
  git-server:1.7
  github:1.28.0
  github-api:1.86
  github-branch-source:2.2.3
  github-oauth:0.27
  github-organization-folder:1.6
  greenballs:1.15
  handlebars:1.1.1
  htmlpublisher:1.14
  icon-shim:2.0.3
  jackson2-api:2.7.3
  javadoc:1.4
  jira:2.4.2
  job-dsl:1.64
  jquery-detached:1.2.1
  junit:1.21
  ldap:1.16
  mailer:1.20
  matrix-auth:1.7
  matrix-project:1.11
  maven-plugin:2.17
  mercurial:2.1
  metrics:3.1.2.10
  momentjs:1.1.1
  node-iterator-api:1.5.0
  pam-auth:1.3
  pipeline-build-step:2.5.1
  pipeline-github-lib:1.0
  pipeline-graph-analysis:1.5
  pipeline-input-step:2.8
  pipeline-milestone-step:1.3.1
  pipeline-model-api:1.1.9
  pipeline-model-declarative-agent:1.1.1
  pipeline-model-definition:1.1.9
  pipeline-model-extensions:1.1.9
  pipeline-rest-api:2.8
  pipeline-stage-step:2.2
  pipeline-stage-tags-metadata:1.1.9
  pipeline-stage-view:2.8
  piwikanalytics:1.2.0
  plain-credentials:1.4
  PrioritySorter:3.5.1
  pubsub-light:1.12
  scm-api:2.2.1
  script-security:1.33
  slack:2.2
  sse-gateway:1.15
  ssh-credentials:1.13
  structs:1.10
  token-macro:2.2
  variant:1.1
  warnings:4.63
  windows-slaves:1.3.1
  workflow-aggregator:2.5
  workflow-api:2.20
  workflow-basic-steps:2.6
  workflow-cps:2.39
  workflow-cps-global-lib:2.8
  workflow-durable-task-step:2.14
  workflow-job:2.12.2
  workflow-multibranch:2.16
  workflow-scm-step:2.6
  workflow-step-api:2.12
  workflow-support:2.14
)
