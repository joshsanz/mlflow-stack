# MLflow Stack - Docker Compose Setup

This Docker Compose setup provides the same MLflow + MinIO + PostgreSQL stack as the Helm chart, but using Docker Compose for easier local development and testing.

## Architecture

The stack consists of:
- **PostgreSQL 15**: Database backend for MLflow metadata
- **MinIO**: S3-compatible object storage for MLflow artifacts
- **MLflow Server**: MLflow tracking server with web UI
- **MinIO Init**: One-time setup container to configure MinIO bucket

## Quick Start

1. Navigate to the docker directory:
   ```bash
   cd docker
   ```

2. Start the stack:
   ```bash
   docker-compose up -d
   ```

3. Access the services:
   - **MLflow UI**: http://localhost:32000
   - **MinIO Console**: http://localhost:30091
   - **MinIO API**: http://localhost:30090

## Configuration

### Environment Variables

Copy and modify the `.env` file to customize the configuration:

```bash
cp .env .env.local
# Edit .env.local with your custom values
```

Available variables:
- `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`: PostgreSQL credentials
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`: MinIO credentials
- `MINIO_BUCKET`: S3 bucket name for MLflow artifacts
- `MINIO_API_PORT`, `MINIO_CONSOLE_PORT`, `MLFLOW_PORT`: Port mappings

### Security Note

⚠️ **Important**: Change the default credentials in production! The default values are:
- MinIO: `minioadmin` / `minioadmin123`
- PostgreSQL: `mlflow` / `mlflowpass`

## Data Persistence

Data is persisted in Docker volumes:
- `postgresql_data`: PostgreSQL database files
- `minio_data`: MinIO object storage
- `mlflow_data`: MLflow server data

## Management Commands

```bash
# Start the stack
docker-compose up -d

# Stop the stack
docker-compose down

# View logs
docker-compose logs -f [service_name]

# Remove everything (including data)
docker-compose down -v

# Rebuild services
docker-compose up -d --build
```

## Port Mapping

The ports match the NodePort configuration from the original Helm chart:
- MLflow: 32000
- MinIO API: 30090
- MinIO Console: 30091
- PostgreSQL: 5432 (for external access if needed)

## Differences from Helm Chart

1. **Persistent Volumes**: Uses Docker volumes instead of Kubernetes PVs
2. **Secrets**: Uses environment variables instead of Kubernetes secrets
3. **Init Job**: Replaced with a dependency-based init container
4. **NodePort**: Direct port mapping instead of Kubernetes NodePort service
5. **Health Checks**: Added Docker health checks for better reliability

## Troubleshooting

### MinIO bucket creation fails
Check the MinIO initialization logs:
```bash
docker-compose logs minio-init
```

### MLflow cannot connect to PostgreSQL
Ensure PostgreSQL is healthy:
```bash
docker-compose ps
docker-compose logs postgresql
```

### Permission issues with volumes
On some systems, you might need to adjust volume permissions:
```bash
docker-compose down
sudo chown -R $(id -u):$(id -g) /var/lib/docker/volumes/docker_*
docker-compose up -d
```