pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    DOCKER_PROJECT_NAME = "odh-swaggerui"
    DOCKER_IMAGE = '755952719952.dkr.ecr.eu-west-1.amazonaws.com/odh-swaggerui'
    DOCKER_TAG = "test-$BUILD_NUMBER"
    SERVER_PORT = "1050"

    SWAGGER_JSON = "/code/default.yml"
    DOC_EXPANSION = "none"
    DISPLAY_REQUEST_DURATION = true
  }

  stages {
    stage('Configure') {
      steps {
        sh """
          rm -f .env
          cp .env.example .env
          echo 'COMPOSE_PROJECT_NAME=${DOCKER_PROJECT_NAME}' >> .env
          echo 'DOCKER_IMAGE=${DOCKER_IMAGE}' >> .env
          echo 'DOCKER_TAG=${DOCKER_TAG}' >> .env
          echo 'SERVER_PORT=${SERVER_PORT}' >> .env

          echo 'SWAGGER_JSON=${SWAGGER_JSON}' >> .env
          echo 'DOC_EXPANSION=${DOC_EXPANSION}' >> .env
          echo 'DISPLAY_REQUEST_DURATION=${DISPLAY_REQUEST_DURATION}' >> .env
        """
      }
    }
    stage('Build') {
      steps {
        sh '''
          aws ecr get-login --region eu-west-1 --no-include-email | bash
          docker-compose --no-ansi -f infrastructure/docker-compose.build.yml build --pull
          docker-compose --no-ansi -f infrastructure/docker-compose.build.yml push
        '''
      }
    }
    stage('Deploy') {
      steps {
        sshagent(['jenkins-ssh-key']) {
          sh """
            (cd infrastructure/ansible && ansible-galaxy install -f -r requirements.yml)
            (cd infrastructure/ansible && ansible-playbook --limit=test deploy.yml --extra-vars "release_name=${BUILD_NUMBER}")
          """
        }
      }
    }
  }
}
