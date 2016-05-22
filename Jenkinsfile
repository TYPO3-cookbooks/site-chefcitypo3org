// dummy... stupid sandbox testing ~peterN
// @todo: refactor functions to workflow repository
// code courtesy of sgebert ;)

def place_kitchen_yaml() {
  if (fileExists('.kitchen.docker.yml')) {
    echo 'Using the cookbooks .kitchen.docker.yml'
  } else {
    echo 'Placing default .kitchen.docker.yml file in workspace'
    writeFile file: '.kitchen.docker.yml', text: '''driver:
  name: docker
  use_sudo: false
  provision_command:
    - apt-get install -y wget
    - apt-get install -y net-tools cron'''
  }
}

// global variable holding the list of test-kitchen instances
def tk_instances = []

// allocate a node for the smaller steps
node {
  // slackSend message: "Build Started - ${env.JOB_NAME}: ${env.BUILD_NUMBER}", failOnError: false

  stage 'clone cookbook'
  checkout scm
  // we e.g. have a .kitchen.docker.yml left from the last run. Remove that.
  sh 'git status'

  step([$class: 'GitHubSetCommitStatusBuilder'])

  // see also http://atomic-penguin.github.io/blog/2014/04/29/stupid-jenkins-and-chef-tricks-part-1-rubocop/
  stage 'lint'
  sh 'foodcritic . -f all'
  sh 'rubocop --fail-level E'
  step([$class: 'WarningsPublisher', canComputeNew: false, canResolveRelativePaths: false, consoleParsers: [[parserName: 'Foodcritic'], [parserName: 'Rubocop']], defaultEncoding: '', excludePattern: '', healthy: '', includePattern: '', unHealthy: ''])
  step([$class: 'AnalysisPublisher'])

  stage 'berks'
  try {
    sh 'berks install'
    currentBuild.result = 'SUCCESS'
  } catch (err) {
    currentBuild.result = 'FAILURE'
  }

  stage 'testkitchen prepare'
  env.KITCHEN_LOCAL_YAML=".kitchen.docker.yml"
  place_kitchen_yaml()
  // copy the workspace for our slaves
  stash includes: '**', name: 'cookbook'

  // read out the list of test instances from `kitchen list`
  sh 'KITCHEN_LOCAL_YAML=.kitchen.docker.yml kitchen list > KITCHEN_INSTANCES'
  def lines = readFile('KITCHEN_INSTANCES').split('\n') // in the Chef template, we have to escape the backslash so that one remains!
  // skip the headline, read out all instances
  for (int i = 1; i < lines.size(); i++) {
    tk_instances << lines[i].tokenize(' ')[0]
  }

  // kitchen_list_output = "kitchen list".execute().text
  // this nice line is broken in Pipeline 2.0 https://issues.jenkins-ci.org/browse/JENKINS-26481
  // readFile('KITCHEN_INSTANCES').eachLine { line, count -> if (count > 0) tk_instances << line.tokenize(' ')[0] }

  echo "Found instances: " + tk_instances

}

// create the node objects that run our tests
test_nodes = [:]
for (int i = 0; i < tk_instances.size(); i++) {
  def instance_name = tk_instances.get(i)

  test_nodes["tk-${instance_name}"] = {
    node {
      // restore workspace
      unstash 'cookbook'

      // TODO: wrap this in try/catch, to make sure that we execute destroy
      withEnv(["KITCHEN_LOCAL_YAML=.kitchen.docker.yml"]) {
        wrap([$class: 'AnsiColorBuildWrapper', colorMapName: "XTerm"]) {
          try {
            sh 'kitchen test --destroy always ' + instance_name
            currentBuild.result = 'SUCCESS'
          } catch (err) {
            currentBuild.result = 'FAILURE'
          }
        }
      }
    }
  }
}
// run all the previously prepared nodes/stages in parallel
stage name: 'testkitchen'
parallel test_nodes

node {
  step([$class: 'GitHubCommitNotifier', resultOnFailure: 'FAILURE'])

  if (currentBuild.result == 'FAILURE') {
    error "Build failed"
    sh "echo slack disabled"
    //slackSend message: "Build Failed - ${env.JOB_NAME}: ${env.BUILD_NUMBER}", failOnError: false, color: 'bad'
  } else {
    sh "echo slack disabled"
    // slackSend message: "Build Successful - ${env.JOB_NAME}: ${env.BUILD_NUMBER}", failOnError: false, color: 'good'
  }

}

node {
  stage 'upload'
  sh 'echo berks upload [disabled!]'
}

