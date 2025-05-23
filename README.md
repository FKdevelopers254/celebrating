# Celebrating Microservices

A microservices-based application with authentication, user management, and other features.

## Services Overview

1. Service Registry (Eureka) - Port 8761
2. API Gateway - Port 8080
3. Auth Service - Port 8081
4. User Service - Port 8082
5. Post Service - Port 8083
6. Messaging Service - Port 8084
7. Search Service - Port 8088
8. Rating & Review Service - Port 8090
9. Analytics & Logging Service - Port 8091

## Prerequisites

- Java 17
- PostgreSQL 15+
- Gradle
- Docker (optional)

## Database Setup

1. Install PostgreSQL if not already installed
2. Create the database:
```sql
CREATE DATABASE celebratedb;
```

## Service Startup Sequence

For proper functionality, start the services in the following order:

1. **Service Registry (Eureka)**
```bash
cd service-registry
./gradlew bootRun
```

2. **API Gateway**
```bash
cd api-gateway
./gradlew bootRun
```

3. **Auth Service**
```bash
cd auth-service
./gradlew bootRun
```

4. **Other Services** (can be started in any order after the above)
```bash
cd user-service
./gradlew bootRun
```

## API Endpoints

### Auth Service
- Register: POST http://localhost:8080/api/auth/register
  ```json
  {
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123"
  }
  ```
- Login: POST http://localhost:8080/api/auth/login
  ```json
  {
    "email": "test@example.com",
    "password": "password123"
  }
  ```

## Configuration Notes

1. **API Gateway Routes**
   - All requests are routed through the API Gateway (port 8080)
   - Auth service routes: /api/auth/**
   - User service routes: /api/users/**
   - Post service routes: /api/posts/**
   - Messaging service routes: /api/messages/**

2. **CORS Configuration**
   - CORS is handled at the API Gateway level
   - Allowed origins: localhost and 127.0.0.1
   - Allowed methods: GET, POST, PUT, DELETE, OPTIONS, HEAD
   - Credentials are allowed
   - Max age: 3600 seconds

3. **Database Configuration**
   - URL: jdbc:postgresql://localhost:5432/celebratedb
   - Username: postgres
   - Password: postgres
   - Each service manages its own schema

4. **Service Discovery**
   - All services register with Eureka (http://localhost:8761)
   - Health checks are enabled
   - Services use the hostname: localhost

## Troubleshooting

1. **Service Registration Issues**
   - Ensure Service Registry (Eureka) is running first
   - Check if services are visible in Eureka dashboard (http://localhost:8761)
   - Verify correct service names in application.yml files

2. **API Gateway Issues**
   - Check if services are registered in Eureka
   - Verify route configurations in api-gateway/application.yml
   - Check service health endpoints

3. **Database Issues**
   - Verify PostgreSQL is running
   - Check database exists and is accessible
   - Verify database credentials in application.yml files

## Monitoring

- Each service exposes actuator endpoints
- Health check: /actuator/health
- Metrics: /actuator/metrics
- Environment: /actuator/env

## Development Notes

1. **Adding New Services**
   - Add service configuration to API Gateway
   - Configure Eureka client in the new service
   - Add appropriate security configuration
   - Update database schema if needed

2. **Security**
   - JWT authentication is implemented
   - Tokens are required for protected endpoints
   - CORS is configured at the API Gateway level

## Logging

- All services use Spring Boot's default logging
- Log levels can be adjusted in application.yml
- Gateway logs are set to DEBUG level for troubleshooting
