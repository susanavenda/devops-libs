# Observability Config

Prometheus scrape configs, Grafana dashboards and provisioning. Reusable across apps.

## Contents

- **prometheus/** - prometheus.yml with scrape configs
- **grafana/** - Dashboards, datasource provisioning
- **kubernetes/** - Prometheus deployment for K8s

## Usage

### Docker Compose
```yaml
volumes:
  - ./packages/observability-config/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro
  - ./packages/observability-config/grafana/provisioning:/etc/grafana/provisioning:ro
```

### Kubernetes
```bash
kubectl apply -f packages/observability-config/kubernetes/
```
