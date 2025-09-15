#!/bin/sh
set -e

echo "=== MLflow Stack MinIO Initialization ==="

# Wait for MinIO to be ready
echo "Waiting for MinIO to be available..."
until mc alias set myminio http://minio:9000 "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD" 2>/dev/null; do
  echo "MinIO not ready, waiting 5 seconds..."
  sleep 5
done
echo "MinIO is ready!"

# Create bucket if it doesn't exist
echo "Creating bucket '$MINIO_BUCKET'..."
mc mb "myminio/$MINIO_BUCKET" --ignore-existing

# Set bucket policy for MLflow access
echo "Setting bucket policy..."
cat > /tmp/policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"AWS": ["*"]},
      "Action": ["s3:GetBucketLocation"],
      "Resource": ["arn:aws:s3:::$MINIO_BUCKET"]
    },
    {
      "Effect": "Allow",
      "Principal": {"AWS": ["*"]},
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::$MINIO_BUCKET"]
    },
    {
      "Effect": "Allow",
      "Principal": {"AWS": ["*"]},
      "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
      "Resource": ["arn:aws:s3:::$MINIO_BUCKET/*"]
    }
  ]
}
EOF

mc anonymous set-json /tmp/policy.json "myminio/$MINIO_BUCKET"

echo "=== Initialization Complete ==="
echo "MinIO bucket '$MINIO_BUCKET' is ready for MLflow artifacts"