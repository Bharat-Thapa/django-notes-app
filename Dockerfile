# Stage 1: Build environment
FROM python:3.9 AS builder

WORKDIR /app/backend

COPY requirements.txt /app/backend
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

COPY . .

# Run migrations
RUN python manage.py migrate

# Stage 2: Production environment
FROM python:3.9-slim AS production

WORKDIR /app/backend

COPY --from=builder /app/backend /app/backend

RUN pip install -r requirements.txt

EXPOSE 8000

CMD ["python", "/app/backend/manage.py", "runserver", "0.0.0.0:8000"]
