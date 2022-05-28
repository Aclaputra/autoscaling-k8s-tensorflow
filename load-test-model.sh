echo "Load test the model"
cd locust
locust -f locust/tasks.py --headless --users 32 --spawn-rate 1 --step-load --step-users 1 --step-time 30s --host http://[EXTERNAL_IP]:8501

echo "-Observe the TF Serving Deployment in GKE dashboard.-"
echo "-Observe the default node-pool-"
