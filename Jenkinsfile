node('DockerIO') {
    stage 'Checkout'
    git "https://github.com/kohsuke/petclinic.git"

    stage 'Build application war file'
    // Build petclinic in a Maven3+JDK8 Docker container
    docker.image('maven:3-jdk-8').inside('-v /.m2:/root/.m2') {
        sh 'mvn -B package -DskipTests'
    }

    stage 'Build application Docker image'
    def appImg = docker.build("petclinic")

    stage 'Push to GCR'
       sh ''' ibmcloud login --apikey pukDLNLc1Csk5RXHJs1WpOJKYE-V0aK6U2lpvv4PLjB6 &&
        ibmcloud cr login &&
        docker tag petclinic us.icr.io/liberty_test/petclinic:latest &&
        docker push us.icr.io/liberty_test/petclinic:latest &&
        ibmcloud cs init &&
        `ibmcloud cs cluster-config jenkinstest | grep export` &&
          ls -altr &&
        /opt/kubectl apply -f iksdeploy.yml '''
   

    stage 'Run app on Kubernetes'
    withKubernetes( serverUrl: 'https://146.148.36.159', credentialsId: 'kubeadmin' ) {
          sh 'kubectl run petclinic --image=registry.ng.bluemix.net/liberty_test/petclinic --port=8080'
    }

    // ... Do some tests on deployed application web UI
}
