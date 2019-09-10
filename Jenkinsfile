node {

  try {

    stage('Clone Repo') {
      checkout scm
    }

    // REMOVE TESTS until needed
    // if (env.BRANCH_NAME != "master-beat-v7") {
    //   stage('Test') {
    //     sh 'make tests'
    //   }
    // }

    if (env.BRANCH_NAME == "master-beat-v7") {
      stage('Build Redash Image') {
        redashImage = docker.build("registry.bigdata-crossregion.thebeat.co/beat/redash:v7.0.0-beat","--no-cache .")
      }

      stage('Push Redash Image') {
        redashImage.push()
      }

    }

    deploymentStatus = 'SUCCESS'
    slackColor = '#3EB991'

  } catch(e) {

    deploymentStatus = 'FAILURE'
    slackColor = '#E01563'
    throw e

  } finally {

      if (env.BRANCH_NAME == "master-beat-v7") {
        slackSend (channel: '#bdsys-ci', color: "${slackColor}", message: "${deploymentStatus}: Repository redash - merge to master-beat-v7 is successful. Image registry.bigdata-crossregion.thebeat.co/beat/redash:v7.0.0-beat build")
      }
      // else if (env.BRANCH_NAME != "master-beat-v7") {
      //   slackSend (channel: '#bdsys-ci', color: "${slackColor}", message: "${deploymentStatus}: Repository redash - tests for branch ${env.BRANCH_NAME}")
      // }
      // sh 'docker-compose down || /bin/true '
      deleteDir()
  }

}
