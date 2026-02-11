# Ansible Playbooks and Roles

Reusable Ansible playbooks and roles for common infrastructure and application deployment tasks.

## Playbooks

### deploy-app.yml

Deploys an application to servers with systemd service management.

**Usage:**
```bash
ansible-playbook -i inventory deploy-app.yml \
  -e app_name=myapp \
  -e artifact_url=https://example.com/app.jar \
  -e app_port=8080
```

### update-packages.yml

Updates system packages on all servers.

**Usage:**
```bash
ansible-playbook -i inventory update-packages.yml
```

### configure-docker.yml

Installs and configures Docker on target hosts.

**Usage:**
```bash
ansible-playbook -i inventory configure-docker.yml \
  -e docker_users=['ubuntu','deploy']
```

## Roles

### common

Common tasks for all servers (package updates, common tools, directories).

**Usage:**
```yaml
- hosts: all
  roles:
    - common
  vars:
    timezone: America/New_York
```

### docker

Installs and configures Docker.

**Usage:**
```yaml
- hosts: docker_hosts
  roles:
    - docker
  vars:
    docker_users:
      - ubuntu
      - deploy
```

### kubernetes

Installs Kubernetes components (kubeadm, kubelet, kubectl).

**Usage:**
```yaml
- hosts: kubernetes_nodes
  roles:
    - kubernetes
  vars:
    kubernetes_version: "1.28"
```

## Inventory

See `inventory.example` for inventory structure.

## Best Practices

1. Use roles for reusable tasks
2. Ensure idempotency
3. Use variables for customization
4. Document all variables and usage
