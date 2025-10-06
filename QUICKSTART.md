# DevOps Assessment - Quick Start Guide

This guide will help you get the Next.js application up and running locally, build Docker images, and deploy to Kubernetes.

## 📋 Prerequisites

- **Node.js** 20.x or higher
- **Docker** (for containerization)
- **Kubernetes cluster** (Minikube, Kind, or cloud provider)
- **kubectl** (for Kubernetes deployment)
- **Git** (for version control)

## 🚀 Local Development

### 1. Clone the Repository

```bash
git clone <repository-url>
cd devops-assignment
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Run Development Server

```bash
npm run dev
```

The application will be available at [http://localhost:3000](http://localhost:3000)

### 4. Build for Production

```bash
npm run build
npm start
```

## 🐳 Docker Setup

### Build Docker Image

```bash
docker build -t nextjs-app:latest .
```

### Run Docker Container

```bash
docker run -p 3000:3000 nextjs-app:latest
```

Access the application at [http://localhost:3000](http://localhost:3000)

### Test the Container

```bash
# Check if container is running
docker ps

# View container logs
docker logs <container-id>
```

## 🔄 CI/CD Pipeline

The project includes a GitHub Actions workflow that automatically:

1. **Triggers** on push to `main` branch
2. **Builds** the Docker image using multi-stage build
3. **Pushes** to GitHub Container Registry (ghcr.io)
4. **Tags** with both `latest` and commit SHA

### Workflow File Location
`.github/workflows/docker-build.yml`

### Required Secrets
- `GITHUB_TOKEN` (automatically provided by GitHub Actions)

## ☸️ Kubernetes Deployment

### Prerequisites
- Running Kubernetes cluster
- `kubectl` configured with cluster access

### Deploy to Kubernetes

```bash
# Apply Kubernetes manifests
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

### Verify Deployment

```bash
# Check deployment status
kubectl get deployments

# Check pods
kubectl get pods

# Check service
kubectl get services
```

### Access the Application

For **LoadBalancer** type service:
```bash
kubectl get service nextjs-service
```

For **Minikube**:
```bash
minikube service nextjs-service
```

For **Port-forward** (local testing):
```bash
kubectl port-forward service/nextjs-service 8080:80
```
Then access at [http://localhost:8080](http://localhost:8080)

## 📊 Monitoring & Health Checks

The deployment includes:
- **Liveness Probe**: Checks app health every 10s
- **Readiness Probe**: Ensures app is ready to receive traffic
- **Replicas**: 2 pods for high availability

### Check Pod Health

```bash
# View pod details
kubectl describe pod <pod-name>

# View logs
kubectl logs <pod-name>

# Follow logs
kubectl logs -f <pod-name>
```

## 🔧 Common Commands

### Scaling

```bash
# Scale to 3 replicas
kubectl scale deployment nextjs-deployment --replicas=3
```

### Update Deployment

```bash
# Update image
kubectl set image deployment/nextjs-deployment nextjs-app=ghcr.io/shravankumar8/nextjs-app:<new-tag>

# Rollout status
kubectl rollout status deployment/nextjs-deployment

# Rollback if needed
kubectl rollout undo deployment/nextjs-deployment
```

### Cleanup

```bash
# Delete all resources
kubectl delete -f k8s/deployment.yaml
kubectl delete -f k8s/service.yaml

# Or delete by name
kubectl delete deployment nextjs-deployment
kubectl delete service nextjs-service
```

## 🏗️ Project Structure

```
devops-assignment/
├── .github/
│   └── workflows/
│       └── docker-build.yml    # CI/CD pipeline
├── k8s/
│   ├── deployment.yaml         # Kubernetes deployment
│   └── service.yaml            # Kubernetes service
├── src/                        # Next.js source code
├── public/                     # Static assets
├── Dockerfile                  # Multi-stage Docker build
├── package.json               # Node.js dependencies
└── next.config.ts             # Next.js configuration
```

## 🧪 Testing the Setup

1. **Local Test**:
   ```bash
   npm run dev
   curl http://localhost:3000
   ```

2. **Docker Test**:
   ```bash
   docker build -t test-nextjs .
   docker run -p 3000:3000 test-nextjs
   curl http://localhost:3000
   ```

3. **Kubernetes Test**:
   ```bash
   kubectl apply -f k8s/
   kubectl wait --for=condition=ready pod -l app=nextjs-app --timeout=60s
   kubectl port-forward service/nextjs-service 8080:80
   curl http://localhost:8080
   ```

## 📝 Notes

- The Docker image uses a **multi-stage build** for optimal size
- Container runs as **non-root user** for security
- Kubernetes deployment uses **2 replicas** for high availability
- Service is configured as **LoadBalancer** type
- Health checks ensure zero-downtime deployments

## 🆘 Troubleshooting

### Container won't start
```bash
docker logs <container-id>
```

### Pods in CrashLoopBackOff
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Service not accessible
```bash
# Check service endpoints
kubectl get endpoints nextjs-service

# Check if pods are ready
kubectl get pods -l app=nextjs-app
```

## 📚 Additional Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [Docker Documentation](https://docs.docker.com)
- [Kubernetes Documentation](https://kubernetes.io/docs)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
