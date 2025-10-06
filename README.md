# DevOps Internship Assessment - Next.js Containerized Application

[![Build and Push Docker Image](https://github.com/shravankumar8/devops-assignment/actions/workflows/docker-build.yml/badge.svg)](https://github.com/shravankumar8/devops-assignment/actions/workflows/docker-build.yml)

## 📋 Project Overview

This project demonstrates the complete DevOps workflow for containerizing and deploying a Next.js application using modern cloud-native tools and practices.

### Technologies Used
- **Next.js 15.5.4** - React framework for production
- **Docker** - Container platform with multi-stage builds
- **GitHub Actions** - CI/CD automation
- **GitHub Container Registry (GHCR)** - Container image registry
- **Kubernetes (Minikube)** - Container orchestration
- **TypeScript** - Type-safe development

### GHCR Image
```
ghcr.io/shravankumar8/nextjs-app:latest
```

## 🎯 Assessment Objectives Completed

✅ Created Next.js application using `create-next-app`
✅ Dockerized application with multi-stage build and security best practices
✅ Automated CI/CD pipeline with GitHub Actions
✅ Container images pushed to GitHub Container Registry (GHCR)
✅ Kubernetes manifests for deployment and service
✅ Health checks and replicas configured
✅ Complete documentation with deployment guide

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed:
- **Node.js** 20.x or higher
- **Docker** 20.x or higher
- **Minikube** v1.30 or higher
- **kubectl** v1.27 or higher
- **Git**

### Installation

1. **Clone the Repository**

```bash
git clone https://github.com/shravankumar8/devops-assignment.git
cd devops-assignment
```

2. **Install Dependencies**

```bash
npm install
```

---

## 💻 Local Development

### Run Development Server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

### Build for Production

```bash
npm run build
npm start
```

### Lint Code

```bash
npm run lint
```

---

## 🐳 Docker Setup

### Dockerfile Overview

The project uses a **multi-stage Docker build** with the following optimizations:

**Stage 1: Builder**
- Uses `node:20-alpine` for minimal image size
- Installs dependencies with `npm ci` for reproducible builds
- Builds the Next.js application

**Stage 2: Runner**
- Minimal production image
- Runs as non-root user (`nextjs`) for security
- Only includes runtime dependencies
- Optimized for production workloads

### Build Docker Image Locally

```bash
docker build -t nextjs-app:local .
```

### Run Docker Container Locally

```bash
docker run -p 3000:3000 nextjs-app:local
```

Visit [http://localhost:3000](http://localhost:3000) to view the application.

### Test Container

```bash
# Check running containers
docker ps

# View logs
docker logs <container-id>

# Stop container
docker stop <container-id>
```

---

## 🔄 GitHub Actions CI/CD

### Workflow Overview

The GitHub Actions workflow (`.github/workflows/docker-build.yml`) automates:

1. **Trigger**: Runs on push to `main` branch
2. **Checkout**: Clones repository code
3. **Login**: Authenticates to GitHub Container Registry
4. **Build**: Creates Docker image using Buildx
5. **Push**: Publishes to GHCR with two tags:
   - `latest` - Always points to most recent build
   - `<commit-sha>` - Specific version for rollbacks

### Image Tags

```
ghcr.io/shravankumar8/nextjs-app:latest
ghcr.io/shravankumar8/nextjs-app:<commit-sha>
```

### Workflow File

Location: `.github/workflows/docker-build.yml`

**Key Features:**
- Uses `docker/build-push-action@v6` for efficient builds
- Leverages BuildKit for layer caching
- Automatic authentication with `GITHUB_TOKEN`
- Multi-tag strategy for versioning

### Viewing Builds

Check workflow runs: [Actions Tab](https://github.com/shravankumar8/devops-assignment/actions)

---

## ☸️ Kubernetes Deployment (Minikube)

### Step 1: Start Minikube

```bash
# Start Minikube cluster
minikube start

# Verify cluster is running
kubectl cluster-info
kubectl get nodes
```

### Step 2: Deploy Application

```bash
# Apply Kubernetes manifests
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

### Step 3: Verify Deployment

```bash
# Check deployment status
kubectl get deployments

# Expected output:
# NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
# nextjs-deployment    2/2     2            2           1m

# Check pods
kubectl get pods

# Expected output:
# NAME                                 READY   STATUS    RESTARTS   AGE
# nextjs-deployment-xxxxxxxxxx-xxxxx   1/1     Running   0          1m
# nextjs-deployment-xxxxxxxxxx-xxxxx   1/1     Running   0          1m

# Check service
kubectl get service nextjs-service

# Expected output:
# NAME              TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
# nextjs-service    LoadBalancer   10.96.x.x       <pending>     80:xxxxx/TCP   1m
```

### Step 4: Access the Application

#### Option 1: Using Minikube Service (Recommended)

```bash
minikube service nextjs-service
```

This will automatically open your browser to the application URL.

#### Option 2: Get Service URL

```bash
minikube service nextjs-service --url
```

Copy the URL and paste it in your browser.

#### Option 3: Port Forwarding

```bash
kubectl port-forward service/nextjs-service 8080:80
```

Access at: [http://localhost:8080](http://localhost:8080)

---

## 📊 Kubernetes Configuration Details

### Deployment Configuration (`k8s/deployment.yaml`)

**Key Features:**
- **Replicas**: 2 pods for high availability
- **Container Image**: `ghcr.io/shravankumar8/nextjs-app:latest`
- **Port**: Container listens on 3000
- **Health Checks**:
  - **Liveness Probe**: Ensures container is alive (checks every 10s)
  - **Readiness Probe**: Ensures container is ready to serve traffic (checks every 5s)

```yaml
livenessProbe:
  httpGet:
    path: /
    port: 3000
  initialDelaySeconds: 10
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /
    port: 3000
  initialDelaySeconds: 5
  periodSeconds: 5
```

### Service Configuration (`k8s/service.yaml`)

**Key Features:**
- **Type**: LoadBalancer (exposes app externally)
- **Port**: External port 80 → Internal port 3000
- **Selector**: Routes traffic to pods with label `app: nextjs-app`

---

## 🛠️ Common Operations

### Scale Deployment

```bash
# Scale to 3 replicas
kubectl scale deployment nextjs-deployment --replicas=3

# Verify
kubectl get pods
```

### Update Deployment

```bash
# Update to specific image version
kubectl set image deployment/nextjs-deployment \
  nextjs-app=ghcr.io/shravankumar8/nextjs-app:<commit-sha>

# Check rollout status
kubectl rollout status deployment/nextjs-deployment
```

### Rollback Deployment

```bash
# Rollback to previous version
kubectl rollout undo deployment/nextjs-deployment

# Check rollout history
kubectl rollout history deployment/nextjs-deployment
```

### View Logs

```bash
# Get pod name
kubectl get pods

# View logs
kubectl logs <pod-name>

# Follow logs in real-time
kubectl logs -f <pod-name>

# View logs from all replicas
kubectl logs -l app=nextjs-app --all-containers=true
```

### Describe Resources

```bash
# Detailed pod information
kubectl describe pod <pod-name>

# Detailed deployment information
kubectl describe deployment nextjs-deployment

# Detailed service information
kubectl describe service nextjs-service
```

---

## 🧹 Cleanup

### Delete Kubernetes Resources

```bash
# Delete all resources
kubectl delete -f k8s/

# Or delete individually
kubectl delete deployment nextjs-deployment
kubectl delete service nextjs-service
```

### Stop Minikube

```bash
# Stop cluster (preserves state)
minikube stop

# Delete cluster (removes all data)
minikube delete
```

---

## 🏗️ Project Structure

```
devops-assignment/
├── .github/
│   └── workflows/
│       └── docker-build.yml      # GitHub Actions CI/CD pipeline
├── k8s/
│   ├── deployment.yaml           # Kubernetes Deployment manifest
│   └── service.yaml              # Kubernetes Service manifest
├── src/
│   └── app/
│       ├── layout.tsx            # Root layout
│       ├── page.tsx              # Home page
│       └── globals.css           # Global styles
├── public/                       # Static assets
├── Dockerfile                    # Multi-stage Docker build
├── package.json                  # Node.js dependencies and scripts
├── next.config.ts                # Next.js configuration
├── tsconfig.json                 # TypeScript configuration
├── tailwind.config.ts            # Tailwind CSS configuration
├── README.md                     # This file
└── QUICKSTART.md                 # Quick reference guide
```

---

## 🔒 Docker Best Practices Implemented

1. ✅ **Multi-stage build** - Reduces final image size
2. ✅ **Alpine base image** - Minimal attack surface (node:20-alpine)
3. ✅ **Non-root user** - Container runs as `nextjs` user
4. ✅ **Layer caching** - Dependencies installed before copying source
5. ✅ **Production mode** - `NODE_ENV=production`
6. ✅ **Minimal runtime** - Only necessary files copied to final image
7. ✅ **Security groups** - User added to `nodejs` group
8. ✅ **Explicit EXPOSE** - Documents port 3000

---

## 🧪 Testing the Complete Workflow

### 1. Test Locally

```bash
npm install
npm run build
npm start
# Visit http://localhost:3000
```

### 2. Test Docker Build

```bash
docker build -t test-nextjs .
docker run -p 3000:3000 test-nextjs
# Visit http://localhost:3000
```

### 3. Test Kubernetes Deployment

```bash
minikube start
kubectl apply -f k8s/
kubectl wait --for=condition=ready pod -l app=nextjs-app --timeout=60s
minikube service nextjs-service
```

### 4. Test CI/CD

```bash
# Make a change and push to main
git add .
git commit -m "Test CI/CD pipeline"
git push origin main

# Check GitHub Actions
# Navigate to: https://github.com/shravankumar8/devops-assignment/actions
```

---

## 🆘 Troubleshooting

### Issue: Minikube won't start

```bash
# Check Minikube status
minikube status

# Delete and recreate
minikube delete
minikube start --driver=docker
```

### Issue: Pods in CrashLoopBackOff

```bash
# Check pod logs
kubectl logs <pod-name>

# Check pod events
kubectl describe pod <pod-name>

# Common fixes:
# - Verify image exists: docker pull ghcr.io/shravankumar8/nextjs-app:latest
# - Check resource limits
# - Verify health check paths
```

### Issue: Service not accessible

```bash
# Check if pods are running
kubectl get pods

# Check service endpoints
kubectl get endpoints nextjs-service

# For Minikube, use:
minikube service nextjs-service --url
```

### Issue: GitHub Actions fails

- Verify repository is public or GHCR permissions are set
- Check workflow syntax: `.github/workflows/docker-build.yml`
- Ensure `GITHUB_TOKEN` has package write permissions

---

## 📚 Additional Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Kubernetes Documentation](https://kubernetes.io/docs)
- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)

---

## 👨‍💻 Author

**[Your Name]**

---

## 📝 License

This project is created for educational purposes as part of a DevOps internship assessment.

---

## 🙏 Acknowledgments

- Next.js team for the excellent framework
- GitHub for Actions and Container Registry
- Kubernetes community for comprehensive documentation
