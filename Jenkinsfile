pipeline {
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "us-east-1"
        DOCKER_ID = credentials('DOCKER_ID')
        DOCKER_ID_SECRET = credentials('DOCKER_ID_SECRET')
        DOCKER_IMAGE_CARTS = "carts"
        DOCKER_IMAGE_CATALOGUE = "catalogue"
        DOCKER_IMAGE_CATALOGUE_DB = "catalogue-db"
        DOCKER_IMAGE_FRONT_END = "front-end"
        DOCKER_IMAGE_ORDERS = "orders"
        DOCKER_IMAGE_PAYMENT = "payment"
        DOCKER_IMAGE_QUEUE = "queue-master"
        DOCKER_IMAGE_SHIPPING = "shipping"
        DOCKER_IMAGE_USER = "user"
        DOCKER_IMAGE_USER_DB = "user-db"
        DOCKER_TAG = "${BUILD_ID}"
        BUILD_AGENT  = ""
        NAMESPACE = "sock-shop"
    }
agent any
    stages {
        stage("Create an EKS Cluster") {
            steps {
                script {
                    dir('terraform') {
                        sh "terraform init -reconfigure"
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
        stage('Build') {
            steps { //create a loop somehow??
                sh 'docker build -t $DOCKER_ID/$DOCKER_IMAGE_CARTS:$DOCKER_TAG ./microservices/carts'
                sh 'docker build -t $DOCKER_ID/$DOCKER_IMAGE_CATALOGUE:$DOCKER_TAG ./microservices/catalogue'
                sh 'docker build -t $DOCKER_ID/$DOCKER_IMAGE_CATALOGUE_DB:$DOCKER_TAG ./microservices/catalogue-db'
                sh 'docker build -t $DOCKER_ID/$DOCKER_IMAGE_FRONT_END:$DOCKER_TAG ./microservices/front-end'
                sh 'docker build -t $DOCKER_ID/$DOCKER_IMAGE_ORDERS:$DOCKER_TAG ./microservices/orders'
                sh 'docker build -t $DOCKER_ID/$DOCKER_IMAGE_PAYMENT:$DOCKER_TAG ./microservices/payment'
                sh 'docker build -t $DOCKER_ID/$DOCKER_IMAGE_QUEUE:$DOCKER_TAG ./microservices/queue-master'
                sh 'docker build -t $DOCKER_ID/$DOCKER_IMAGE_SHIPPING:$DOCKER_TAG ./microservices/shipping'
                sh 'docker build -t $DOCKER_ID/$DOCKER_IMAGE_USER:$DOCKER_TAG ./microservices/user'
                sh 'docker build -t $DOCKER_ID/$DOCKER_IMAGE_USER_DB:$DOCKER_TAG ./microservices/user-db'
            }
        }

        stage('Push') {
            environment {
                DOCKER_ID = credentials('DOCKER_ID')
                DOCKER_ID_SECRET = credentials('DOCKER_ID_SECRET')
            }
            steps {
                sh 'docker image tag $DOCKER_ID/$DOCKER_IMAGE_CARTS:$DOCKER_TAG $DOCKER_ID/$DOCKER_IMAGE_CARTS:latest'
                sh 'docker image tag $DOCKER_ID/$DOCKER_IMAGE_CATALOGUE:$DOCKER_TAG $DOCKER_ID/$DOCKER_IMAGE_CATALOGUE:latest'
                sh 'docker image tag $DOCKER_ID/$DOCKER_IMAGE_CATALOGUE_DB:$DOCKER_TAG $DOCKER_ID/$DOCKER_IMAGE_CATALOGUE_DB:latest'
                sh 'docker image tag $DOCKER_ID/$DOCKER_IMAGE_FRONT_END:$DOCKER_TAG $DOCKER_ID/$DOCKER_IMAGE_FRONT_END:latest'
                sh 'docker image tag $DOCKER_ID/$DOCKER_IMAGE_ORDERS:$DOCKER_TAG $DOCKER_ID/$DOCKER_IMAGE_ORDERS:latest'
                sh 'docker image tag $DOCKER_ID/$DOCKER_IMAGE_PAYMENT:$DOCKER_TAG $DOCKER_ID/$DOCKER_IMAGE_PAYMENT:latest'
                sh 'docker image tag $DOCKER_ID/$DOCKER_IMAGE_QUEUE:$DOCKER_TAG $DOCKER_ID/$DOCKER_IMAGE_QUEUE:latest'
                sh 'docker image tag $DOCKER_ID/$DOCKER_IMAGE_SHIPPING:$DOCKER_TAG $DOCKER_ID/$DOCKER_IMAGE_SHIPPING:latest'
                sh 'docker image tag $DOCKER_ID/$DOCKER_IMAGE_USER:$DOCKER_TAG $DOCKER_ID/$DOCKER_IMAGE_USER:latest'
                sh 'docker image tag $DOCKER_ID/$DOCKER_IMAGE_USER_DB:$DOCKER_TAG $DOCKER_ID/$DOCKER_IMAGE_USER_DB:latest'
                sh 'docker login -u $DOCKER_ID -p $DOCKER_ID_SECRET'
                sh 'docker push $DOCKER_ID/$DOCKER_IMAGE_CARTS:$DOCKER_TAG && docker push $DOCKER_ID/$DOCKER_IMAGE_CARTS:latest'
                sh 'docker push $DOCKER_ID/$DOCKER_IMAGE_CATALOGUE:$DOCKER_TAG && docker push $DOCKER_ID/$DOCKER_IMAGE_CATALOGUE:latest'
                sh 'docker push $DOCKER_ID/$DOCKER_IMAGE_CATALOGUE_DB:$DOCKER_TAG && docker push $DOCKER_ID/$DOCKER_IMAGE_CATALOGUE_DB:latest'
                sh 'docker push $DOCKER_ID/$DOCKER_IMAGE_FRONT_END:$DOCKER_TAG && docker push $DOCKER_ID/$DOCKER_IMAGE_FRONT_END:latest'
                sh 'docker push $DOCKER_ID/$DOCKER_IMAGE_ORDERS:$DOCKER_TAG && docker push $DOCKER_ID/$DOCKER_IMAGE_ORDERS:latest'
                sh 'docker push $DOCKER_ID/$DOCKER_IMAGE_PAYMENT:$DOCKER_TAG && docker push $DOCKER_ID/$DOCKER_IMAGE_PAYMENT:latest'
                sh 'docker push $DOCKER_ID/$DOCKER_IMAGE_QUEUE:$DOCKER_TAG && docker push $DOCKER_ID/$DOCKER_IMAGE_QUEUE:latest'
                sh 'docker push $DOCKER_ID/$DOCKER_IMAGE_SHIPPING:$DOCKER_TAG && docker push $DOCKER_ID/$DOCKER_IMAGE_SHIPPING:latest'
                sh 'docker push $DOCKER_ID/$DOCKER_IMAGE_USER:$DOCKER_TAG && docker push $DOCKER_ID/$DOCKER_IMAGE_USER:latest'
                sh 'docker push $DOCKER_ID/$DOCKER_IMAGE_USER_DB:$DOCKER_TAG && docker push $DOCKER_ID/$DOCKER_IMAGE_USER_DB:latest'
            }
        }
        stage("Deploy to EKS") {
            steps {
                script {
                    dir('kubernetes') {
                        sh "aws eks update-kubeconfig --name myapp-eks-cluster"
                        //sh "kubectl apply -f nginx-deployment.yaml"
                        //sh "kubectl apply -f nginx-service.yaml"
                        //sh 'kubectl get namespace'
                        //sh 'kubectl create namespace $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/front-end/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/ingress -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/catalogue-db/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/catalogue/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/carts-db/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/carts/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/queue-master/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/rabbitmq/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/user-db/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/user/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/orders-db/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/orders/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/payment/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/shipping/manifests -n $NAMESPACE'
                        sh 'kubectl get ingress -n $NAMESPACE'
                    }
                }
            }
        }
    }
}