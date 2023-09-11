pipeline {
  environment {
    DOCKER_REPO = 'niranx/corretto-assessment'
  }
  agent any
  tools {
    maven 'mvn-3.6'
    jdk 'jdk-11'
  }
  stages {
    stage ('Initialize') {
      steps {
        sh '''
          java -version
          mvn -version
        '''
      }
    }
    stage ('Build Image') {
      steps {
        script {
          appImage = docker.build("${DOCKER_REPO}")
        }
      }
    }
    stage ('Publish Image') {
      steps {
        script {
          docker.withRegistry('', 'docker-credentials') {
            appImage.push("${env.BUILD_NUMBER}")
            appImage.push("latest")
          }
        }
      }
    }
    stage ('Deploy Image') {
      steps {
        sh '''
        docker compose down --remove-orphans
        docker compose up -d --wait
        '''
      }
    }
    stage ('App Test') {
      steps {
          sh '''
          curl http://localhost | grep "Elastic Beanstalk"
          '''
      }
    }
  }
}
