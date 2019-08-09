agent {
        node {
            label 'DockerIO'
        }
    }
stages{
    stage 'Checkout'
    git "https://github.com/kohsuke/petclinic.git"

    stage 'Build application war file'
    // Build petclinic in a Maven3+JDK8 Docker container
    docker.image('maven:3-jdk-8').inside('-v /.m2:/root/.m2') {
        sh 'mvn -B package -DskipTests'
    }

    stage 'Build application Docker image'
    def appImg = docker.build("nicolas-deloof/petclinic")

    stage 'Push to GCR'
    steps{
       sh 'bx login -a https://api.ng.bluemix.net -apikey SB8RT-E15jVemTpuOjg91p6rwUnkfJyofi_e4vK_7y6e -o ADMNextGen -s devtest' +
       'bx cr login'
       'docker tag nicolas-deloof/petclinic registry.ng.bluemix.net/liberty_test/petclinic' +
       'docker push registry.ng.bluemix.net/liberty_test/petclinic'
    } 
    }

    stage 'Run app on Kubernetes'
    withKubernetes( serverUrl: 'https://146.148.36.159', credentialsId: 'kubeadmin' ) {
          sh 'kubectl run petclinic --image=registry.ng.bluemix.net/liberty_test/petclinic --port=8080'
    }

    // ... Do some tests on deployed application web UI

}
}
