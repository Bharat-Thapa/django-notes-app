# Stage 1: Build environment
FROM python:3.9 AS builder

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

# Run migrations
RUN python manage.py migrate

# Stage 2: Production environment
FROM python:3.9-slim AS production

WORKDIR /app

COPY --from=builder /app .

RUN pip install -r requirements.txt

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
