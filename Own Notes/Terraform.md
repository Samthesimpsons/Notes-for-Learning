# Terraform Deep Dive Notes

## 1. 🌟 Why Terraform & Infrastructure as Code (IaC)?

### What *is* IaC?

* **Infrastructure as Code (IaC)** is the practice of defining servers, networks, and other resources in declarative files, instead of using GUIs.

#### Benefits

* **Version‑controlled**: Track infrastructure changes like code.
* **Repeatable**: Spin up identical dev/staging/prod environments.
* **Auditable**: All changes have commit history.
* **Collaborative**: Leverage pull requests and code review.

### Why Terraform Shines

| Capability              | What it Means                                                     | Why it Matters                                    |
| ----------------------- | ----------------------------------------------------------------- | ------------------------------------------------- |
| ☁️ **Multi‑Cloud**      | One syntax for AWS, Azure, GCP, Kubernetes, VMware, on‑prem, etc. | Avoids vendor lock‑in; standard tooling.          |
| 🧩 **Modular**          | Re‑usable modules package best‑practice resources.                | Speeds delivery, enforces consistency.            |
| 🔄 **Idempotent**       | Repeated `terraform apply` → same result.                         | Predictable, safe deployments.                    |
| 📋 **State Management** | Tracks real-world infra to plan minimal changes.                  | Enables drift detection and targeted updates.     |
| 🤝 **Ecosystem**        | Registry of providers & modules.                                  | Works with SaaS like GitHub, Datadog, Cloudflare. |
| 🔐 **Policy Support**   | Sentinel, OPA, etc.                                               | Enforce compliance and governance rules.          |

### Popular IaC Alternatives

| Tool                               | Scope                 | Strengths                                                 |
| ---------------------------------- | --------------------- | --------------------------------------------------------- |
| **AWS CloudFormation / CDK / SAM** | AWS only              | Deep feature support, native integration.                 |
| **Azure Bicep / ARM**              | Azure only            | First-class in Azure portal.                              |
| **Pulumi**                         | Multi-cloud           | Write infra in real languages (TypeScript, Python, etc.). |
| **Ansible**                        | Config & Provisioning | Agentless, great for OS-level config.                     |
| **Crossplane**                     | K8s-native            | Define cloud infra via Kubernetes CRDs.                   |

> **When to choose Terraform?**
> ✅ Multi-cloud consistency
> ✅ Large, mature ecosystem
> ✅ Declarative, stateful, predictable infrastructure

### Automating Large‑Scale Cloud Builds

* **Scale horizontally**: Use `for_each` to create N resources (e.g., OpenShift nodes).
* **Immutable infrastructure**: Recreate from scratch → test → `terraform destroy`.
* **CI/CD integration**: Terraform runs as part of GitHub Actions, GitLab CI, Jenkins.
* **Multi-region/account**: Separate state files or workspaces keep things isolated.

### Example: Launching Multiple OCP Servers on AWS

```hcl
variable "ocp_count" {
  default = 3
}

module "ocp_nodes" {
  source = "community/modules/aws-instance"
  for_each = toset(range(var.ocp_count))

  name          = "ocp-node-${each.key}"
  ami_id        = data.aws_ami.openshift.id
  instance_type = "m6i.large"
  tags = {
    Cluster = "openshift-prod"
  }
}
```

---

## 2. ✅ Minimal Setup – Just a `.tf` File

* Terraform uses `.tf` or `.tf.json` files to define infrastructure.
* All `.tf` files in the same directory are processed together.
* Common file naming:

  * `main.tf`: primary definitions
  * `variables.tf`: input variables
  * `outputs.tf`: output values
  * `terraform.tfvars`: input values

---

## 3. 🔌 Adding Providers & `terraform init`

### Define a Provider

```hcl
provider "aws" {
  region     = "us-east-1"
  access_key = "..."
  secret_key = "..."
}
```

### Initialize the Directory

```bash
terraform init
```

* Downloads provider plugins to `.terraform/`.
* Creates `.terraform.lock.hcl` to lock dependency versions.

> ⚠️ Don’t delete `.terraform/` or the lock file unless re-initializing.

---

## 4. 📦 Adding Resources & Using the Documentation

### Example Resource

```hcl
resource "aws_instance" "my_server" {
  ami           = "ami-0abc123"
  instance_type = "t2.micro"

  tags = {
    Name        = "MyInstance"
    Environment = "Dev"
  }
}
```

### Explanation

* `aws_instance`: Type of resource.
* `my_server`: Name used for reference inside Terraform.
* Use [Terraform Registry](https://registry.terraform.io) to browse resource types & options.

---

## 5. 🔄 Core Commands & Variable Management

### Core Terraform Commands

* `terraform plan`: Preview changes.
* `terraform apply`: Apply changes.
* `terraform destroy`: Delete all resources.

### Variable Management

#### Option 1: Inline in `.tf`

```hcl
variable "instance_type" {
  default = "t2.micro"
}
```

#### Option 2: `terraform.tfvars`

```hcl
instance_type = "t3.micro"
```

```bash
terraform apply -var-file="custom.tfvars"
```

#### Option 3: CLI Flag

```bash
terraform apply -var="instance_type=t3.medium"
```

#### Option 4: Interactive Prompt

```hcl
variable "db_password" {}
```

> If not set, Terraform prompts the user.

---

## 6. 📤 Output Variables

Expose values from resources:

```hcl
output "instance_ip" {
  value = aws_instance.my_server.public_ip
}
```

Access it:

```bash
terraform output instance_ip
```

---

## 7. 💣 Destroying Resources & Targeted Operations

### Destroy All Resources

```bash
terraform destroy
```

### Apply/Destroy Specific Resources

```bash
terraform apply -target=aws_instance.my_server
terraform destroy -target=aws_instance.my_server
```

---

## 8. ⚙️ Common Flags & Best Practices

### Common Flags

* `--auto-approve`: Skip confirmation prompts.
* `-var`, `-var-file`: Pass variables at runtime.
* `-target`: Focus on specific resources.
* `-refresh=false`: Avoid refreshing remote state.

### Best Practices

* Use `.terraformignore` to exclude unnecessary files.
* Format with `terraform fmt`.
* **Never hardcode secrets**:

  * Use environment variables
  * Store in `secrets.tfvars` and `.gitignore` it

---

## 9. 📁 Useful Terraform Files

| File                  | Purpose                                   |
| --------------------- | ----------------------------------------- |
| `.terraform/`         | Plugin/module cache                       |
| `.terraform.lock.hcl` | Dependency lock file                      |
| `terraform.tfstate`   | Actual infra state (do not manually edit) |
| `terraform.tfvars`    | Variable values                           |
| `variables.tf`        | Input variable definitions                |
| `outputs.tf`          | Output value definitions                  |

---
