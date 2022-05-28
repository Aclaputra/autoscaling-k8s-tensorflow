echo "-Set the default compute zone-"

PROJECT_ID=sacred-armor-346113
gcloud config set project $PROJECT_ID
gcloud config set compute/zone us-central1-f

echo "-Set the cluster name-"
CLUSTER_NAME=chatbot-cluster

echo "-Creating a Kubernetes cluster with 3 nodes in the default node pool-"
gcloud beta container clusters create $CLUSTER_NAME \
  --cluster-version=latest \
  --machine-type=e2-standard-2 \
  --enable-autoscaling \
  --min-nodes=1 \
  --max-nodes=3 \
  --num-nodes=1 

echo "-Check that the cluster is up and running-"
gcloud container clusters list

echo "-Get the credentials for you new cluster so you can interact with it using kubectl-"
gcloud container clusters get-credentials $CLUSTER_NAME 

echo "-List the cluster's nodes-"
kubectl get nodes

echo "-Create new bucket-"
export MODEL_BUCKET=${PROJECT_ID}-bucket
gsutil mb gs://${MODEL_BUCKET}

echo "-After the bucket has been created copy the model files-"
gsutil cp -r gs://workshop-datasets/models/resnet_101 gs://${MODEL_BUCKET}

echo "-Deploying a model-"
kubectl apply -f tf-serving/configmap.yaml

echo "Create TF Serving Deployment."
kubectl apply -f tf-serving/deployment.yaml

echo "Create TF Serving Service."
kubectl apply -f tf-serving/service.yaml

echo "-Get the external address for the TF Serving service-"
kubectl get svc image-classifier

echo "Verify that the model is up and operational."
curl -d @locust/request-body.json -X POST http://[EXTERNAL_IP]:8501/v1/models/image_classifier:predict

echo "Configure Horizontal Pod Autoscaler."
kubectl autoscale deployment image-classifier --cpu-percent=60 --min=1 --max=4

echo "Check the status of the autoscaler."
kubectl get hpa

echo "-Your k8s Cluster, deployment, service have been added with Horizontal Pod Autoscaling-"
echo "-Next try run load-test-model.sh for-"
