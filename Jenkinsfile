pipeline {
  agent any

  options {
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '30'))
  }

  environment {
    APP_NAME = 'linkcust-ai'
    HARBOR_PROJECT = 'linkcust'
  }

  stages {
    stage('Validate branch') {
      steps {
        script {
          if (!(env.BRANCH_NAME == 'develop' || env.BRANCH_NAME == 'main')) {
            currentBuild.result = 'NOT_BUILT'
            error("Deployment pipeline only supports develop and main; got ${env.BRANCH_NAME}")
          }
        }
      }
    }

    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Metadata') {
      steps {
        script {
          env.GIT_SHORT_SHA = sh(script: 'git rev-parse --short=8 HEAD', returnStdout: true).trim()
          env.DEPLOY_ENV = env.BRANCH_NAME == 'main' ? 'production' : 'test'
          env.IMAGE_TAG = "${env.BRANCH_NAME}-${env.GIT_SHORT_SHA}"
          env.MOVING_TAG = env.BRANCH_NAME == 'main' ? 'latest' : 'develop'
        }
      }
    }

    stage('Install & verify') {
      steps {
        sh 'corepack enable'
        sh 'yarn install --immutable'
        sh 'yarn nx run twenty-shared:build || true'
        sh 'yarn nx lint:diff-with-main twenty-server || true'
      }
    }

    stage('Build & push image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'harbor-linkcust', usernameVariable: 'HARBOR_USER', passwordVariable: 'HARBOR_PASSWORD')]) {
          sh '''
            set -euo pipefail
            echo "$HARBOR_PASSWORD" | docker login "$HARBOR_REGISTRY" -u "$HARBOR_USER" --password-stdin
            docker build \
              --label org.opencontainers.image.revision="$GIT_COMMIT" \
              --label org.opencontainers.image.source="https://github.com/agakong-tech/linkcust-ai" \
              -t "$HARBOR_REGISTRY/$HARBOR_PROJECT/$APP_NAME:$IMAGE_TAG" \
              -t "$HARBOR_REGISTRY/$HARBOR_PROJECT/$APP_NAME:$MOVING_TAG" \
              .
            docker push "$HARBOR_REGISTRY/$HARBOR_PROJECT/$APP_NAME:$IMAGE_TAG"
            docker push "$HARBOR_REGISTRY/$HARBOR_PROJECT/$APP_NAME:$MOVING_TAG"
          '''
        }
      }
    }

    stage('Deploy') {
      steps {
        script {
          def credentialId = env.BRANCH_NAME == 'main' ? 'linkcust-production-ssh' : 'linkcust-test-ssh'
          def targetHost = env.BRANCH_NAME == 'main' ? env.PRODUCTION_HOST : env.TEST_HOST
          sshagent(credentials: [credentialId]) {
            sh """
              ssh -o StrictHostKeyChecking=accept-new ${targetHost} \
                'cd /opt/linkcust && IMAGE_TAG=${env.IMAGE_TAG} HARBOR_REGISTRY=${env.HARBOR_REGISTRY} ./deploy/scripts/deploy.sh ${env.DEPLOY_ENV}'
            """
          }
        }
      }
    }
  }

  post {
    always { cleanWs() }
  }
}
