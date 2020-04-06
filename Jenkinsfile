def sendNotification(String branch, String status) {
  statusColor = '#E01563';
  jobName = "${env.JOB_NAME}".split('/')[0]
  if (status == 'SUCCESS') {
    statusColor = '#3EB991';
  }
  slackSend (
    color: statusColor,
    channel: "#bdsys-ci",
    message: "*${status}:* [${jobName}] Job `${env.JOB_NAME}` build `${env.BUILD_NUMBER}` finished.\nMore info at: ${env.BUILD_URL}"
  )
}

pipeline {
  agent {
    kubernetes {
      yaml '''
apiVersion: v1
kind: Pod
metadata:
  name: jenkins-slave
spec:
  containers:
    - name: docker
      image: docker:18.06.3
      tty: true
      env:
        - name: DOCKER_HOST
          value: tcp://localhost:2375
      resources:
        requests:
          memory: 128Mi
          cpu: 100m
        limits:
          memory: 1G
          cpu: 1000m
    - name: docker-daemon
      image: docker:18.06.3-dind
      securityContext:
        privileged: true
      env:
        - name: DOCKER_TLS_CERTDIR
          value: ""
      resources:
        requests:
          memory: 128Mi
          cpu: 100m
        limits:
          memory: 2G
          cpu: 1000m     
'''
    }
  }

  stages {
    stage('Build Redash Image') {
      when {
        branch 'master-beat-v7'
      }
      steps {
        container('docker') {
          sh "docker build -t registry.bigdata.thebeat.co/beat/redash:${env.GIT_COMMIT} ."
          sh "docker tag registry.bigdata.thebeat.co/beat/redash:${env.GIT_COMMIT} registry.bigdata.thebeat.co/beat/redash:latest"
          sh "docker push registry.bigdata.thebeat.co/beat/redash:${env.GIT_COMMIT}"
          sh "docker push registry.bigdata.thebeat.co/beat/redash:latest"
        }
      }
    }

  }

}
