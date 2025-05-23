# Celebrating Microservices

A comprehensive microservices-based application for celebrating achievements and milestones.

## Services Overview

1. **Service Registry (Eureka)** - Port 8761
   - Service discovery and registration
   - Health monitoring
   - Load balancing support

2. **Config Server** - Port 8888
   - Centralized configuration management
   - Git-based config repository
   - Dynamic configuration updates

3. **API Gateway** - Port 8080
   - Request routing
   - Load balancing
   - Global CORS configuration
   - Authentication filter
   - Rate limiting

4. **Auth Service** - Port 8081
   - User authentication
   - JWT token management
   - User registration
   - Password encryption (BCrypt)

5. **User Service** - Port 8082
   - User profile management
   - User preferences
   - Account settings

6. **Post Service** - Port 8083
   - Create and manage posts
   - Media handling
   - Post interactions

7. **Messaging Service** - Port 8084
   - Real-time messaging
   - Chat functionality
   - Notifications integration

8. **News Feed Service** - Port 8085
   - Personalized feed generation
   - Content aggregation
   - Feed preferences

9. **Moderation Service** - Port 8086
   - Content moderation
   - Report handling
   - Community guidelines enforcement

10. **Notification Service** - Port 8087
    - Push notifications
    - Email notifications
    - In-app notifications

11. **Search Service** - Port 8088
    - Full-text search
    - Advanced filtering
    - Search analytics

12. **Award Service** - Port 8089
    - Achievement management
    - Badge system
    - Rewards tracking

13. **Rating & Review Service** - Port 8090
    - User ratings
    - Review management
    - Reputation system

14. **Analytics & Logging Service** - Port 8091
    - User analytics
    - System metrics
    - Audit logging

## Prerequisites

- Java 17 or higher
- PostgreSQL 15+
- Gradle 7.x
- Docker (optional)
- Node.js 18+ (for frontend)

## Database Setup

1. Install PostgreSQL if not already installed
2. Create the database:
```sql
CREATE DATABASE celebratedb;
```
3. Run the database setup script:
```bash
./setup_database.bat  # Windows
./setup_database.sh   # Linux/Mac
```

## Service Startup Sequence

For proper functionality, start the services in the following order:

1. **Service Registry (Eureka)**
```bash
cd service-registry
./gradlew bootRun
```

2. **Config Server**
```bash
cd config-server
./gradlew bootRun
```

3. **API Gateway**
```bash
cd api-gateway
./gradlew bootRun
```

4. **Auth Service**
```bash
cd auth-service
./gradlew bootRun
```

5. **Core Services** (can be started in any order)
```bash
# Start each in a separate terminal
cd user-service
./gradlew bootRun

cd post-service
./gradlew bootRun

cd messaging-service
./gradlew bootRun
```

6. **Supporting Services** (can be started in any order)
```bash
# Start each in a separate terminal
cd notification-service
./gradlew bootRun

cd search-service
./gradlew bootRun

cd award-service
./gradlew bootRun

cd rating-review-service
./gradlew bootRun

cd analytics-logging-service
./gradlew bootRun

cd news-feed-service
./gradlew bootRun

cd moderation-service
./gradlew bootRun
```

## Quick Start (Using Scripts)

Windows:
```bash
start-services.bat
```

Linux/Mac:
```bash
./start-services.sh
```

## API Documentation

- Swagger UI: http://localhost:8080/swagger-ui.html
- API Documentation: http://localhost:8080/api-docs

## Monitoring

- Eureka Dashboard: http://localhost:8761
- Spring Boot Admin: http://localhost:8080/admin
- Actuator Endpoints: Available on each service at /actuator

## Testing

Each service includes:
- Unit tests
- Integration tests
- API tests (Postman collections in /postman directory)

## Docker Support

Build all services:
```bash
docker-compose build
```

Run the entire stack:
```bash
docker-compose up -d
```

## Kubernetes Support

Deployment manifests are available in the `k8s` directory.

## Contributing

Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

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
