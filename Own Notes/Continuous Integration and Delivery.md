# 🔁 CI/CD with Jenkins & GitLab

## 🚀 **Continuous Integration (CI)**

* Practice of **automatically integrating code changes** into a shared repository multiple times a day.
* Each integration triggers **automated builds and tests** to catch issues early.
* Goal: detect errors quickly and improve software quality.

## 🚢 **Continuous Delivery (CD)**

* Automates the process of **delivering validated code to a staging or production environment**.
* Every change that passes the CI pipeline is automatically deployable.
* Some teams also use **CD** to mean **Continuous Deployment**, where code is actually **deployed automatically** to users after passing tests.

---

## 🔁 CI/CD in Practice

| Step                   | Purpose                         | Example Tool                |
| ---------------------- | ------------------------------- | --------------------------- |
| Code Commit            | Developers push code to Git     | GitHub/GitLab               |
| Continuous Integration | Builds & runs tests             | Jenkins, GitHub Actions     |
| Artifact Creation      | Build Docker images or binaries | Docker                      |
| Continuous Delivery    | Deploy to staging/prod          | Jenkins, Argo CD, GitLab CI |
| Monitoring             | Check deployed app health       | Prometheus, Grafana         |

---

## ✅ Benefits of CI/CD

* Faster release cycles
* Higher code quality
* Automated testing and deployment
* Easier rollback and debugging

> **Summary:** CI/CD automates the build → test → deploy cycle, allowing teams to deliver software faster and more reliably.

---

## 🧰 What is Jenkins?

- Open-source automation server for **continuous integration and delivery (CI/CD)**.
- Highly customizable via plugins (Docker, Kubernetes, SonarQube, etc.).
- Pipelines are defined in a `Jenkinsfile`, written in **Groovy-based DSL**.

> **Note:** Jenkinsfiles are version-controlled and describe build, test, and deploy stages.

---

## 📦 Typical Jenkins CI/CD Pipeline for Microservices

```plaintext
1. Clone Repository
2. SonarQube Code Scan
3. IQ Server Dependency Scan
4. Unit Tests (if available)
5. Docker Build & Push
6. Deploy to OCP (OpenShift) / Kubernetes
7. Post-deploy Test or Cleanup
````

### 🔍 Stage-by-Stage Breakdown

#### 1. **Clone Source Code**

```groovy
checkout scm
```

#### 2. **Static Code Scans**

* **SonarQube**: Bugs, code smells, vulnerabilities.
* **IQ Server (Nexus Lifecycle)**: CVEs and license violations in dependencies.

```groovy
sh 'sonar-scanner -Dsonar.projectKey=my-app'
sh './iq-cli app-scan -a my-app'
```

#### 3. **Unit Testing**

* Example: `pytest`, `JUnit`

```groovy
sh 'pytest --junitxml=results.xml'
junit 'results.xml'
```

#### 4. **Docker Build & Push**

```groovy
sh 'docker build -t my-app:latest .'
sh 'docker push registry.example.com/my-app:latest'
```

#### 5. **Deployment to Container Orchestrator**

* Usually OpenShift (`oc`) or Kubernetes (`kubectl`)

```groovy
sh 'oc apply -f deployment.yaml'
```

#### 6. **Post-Deploy Validation or Cleanup**

* Smoke tests, endpoint pings, or teardown

```groovy
sh 'curl http://my-app/health'
```

> **Note:** Post-deploy logic can vary based on environment. Images might be removed (dev) or retained (test validation).

---

## 🧩 Jenkins CI/CD Summary

| Step            | Tools Example             |
| --------------- | ------------------------- |
| Code Checkout   | Git / SCM                 |
| Code Scan       | SonarQube                 |
| Dependency Scan | IQ Server                 |
| Unit Tests      | pytest, JUnit             |
| Build           | Docker                    |
| Deploy          | OpenShift, K8s            |
| Post-Deploy     | Curl, custom test scripts |

---

## 🆚 GitLab CI/CD — All-in-One Alternative

### ✅ Key Features

* Integrated **CI/CD + Git repo + Container Registry**
* Native support for:

  * Docker builds
  * Kubernetes deployment
  * Code quality and security scanning
  * Secrets, runners, merge gates

### 📄 Example `.gitlab-ci.yml`

```yaml
stages:
  - build
  - test
  - deploy

build:
  script:
    - docker build -t registry.gitlab.com/my-app .
    - docker push registry.gitlab.com/my-app

test:
  script:
    - pytest tests/

deploy:
  script:
    - kubectl apply -f k8s/
```

> **Note:** GitLab offers a seamless CI/CD experience, especially for teams looking to avoid managing separate tools.

---

## 🤖 CI/CD for ML Models (MLflow Context)

### How It Differs from App/Service CI/CD

| Step        | Microservice CI/CD       | ML Model CI/CD                        |
| ----------- | ------------------------ | ------------------------------------- |
| Testing     | Unit/integration tests   | Model evaluation (accuracy, F1, etc.) |
| Scan        | Code & dependency checks | Also validate data & lineage          |
| Build       | Dockerize app            | Package model + environment           |
| Deploy      | API on OCP/K8s           | MLflow registry or model server       |
| Post-deploy | Health check endpoints   | Prediction validation, drift checks   |

### 🧪 MLflow CI/CD Example Flow

```plaintext
1. Clone repo + load model
2. Evaluate performance
3. Validate metrics
4. Register model to MLflow
5. Optionally deploy as REST API (FastAPI or MLflow server)
6. Run test predictions
```

> **Note:** In ML, deployment might not be a service — it could just mean registering the model or running batch inference.

---

## 🧠 Summary Points

* **Jenkins:** Highly customizable CI/CD using Groovy-based pipelines.
* **Post-deploy logic** (e.g., teardown, endpoint testing) depends on environment and use case.
* **GitLab CI/CD:** Simplifies the DevOps lifecycle with built-in tools — minimal config, powerful for teams.
* **ML Pipelines:** Focus on **metrics, reproducibility, and registry** — not just deploy-to-service.
