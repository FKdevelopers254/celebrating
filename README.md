# Spring Cloud Microservices Project

This project demonstrates a microservices architecture using Spring Cloud, consisting of the following services:

## Infrastructure Services
1. Config Server (Port 8888)
2. Service Registry (Eureka) (Port 8761)
3. API Gateway (Port 8080)

## Backend Services for Flutter App
4. Auth Service (Port 8081) - Handles authentication and authorization
5. User Service (Port 8082) - Manages user profiles and related operations
6. Post Service (Port 8083) - Manages posts and related content
7. Messaging Service (Port 8084) - Handles real-time messaging between users
8. News Feed Service (Port 8085) - Aggregates and delivers news feeds to users
9. Notification Service (Port 8086) - Manages user notifications
10. Award Service (Port 8087) - Handles user awards and achievements
11. Rating-Review Service (Port 8088) - Manages ratings and reviews for posts/users
12. Analytics-Logging Service (Port 8089) - Collects analytics and logging data
13. Moderation Service (Port 8090) - Handles content moderation and reports
14. Search Service (Port 8091) - Provides search functionality for users and posts

## Prerequisites

- Java 17 or later
- Gradle 8.x
- Git
- PostgreSQL 14 or later
- Flutter (for web app development)
- Chrome browser (for Flutter web app)

## Project Structure

```
celebrating-microservices-main/
├── config-server/         # Spring Cloud Config Server
├── service-registry/      # Eureka Service Registry
├── api-gateway/           # Spring Cloud Gateway
├── auth-service/          # Authentication & Authorization Service
├── user-service/          # User Management Service
├── post-service/          # Post Management Service
├── messaging-service/     # Real-time Messaging Service
├── news-feed-service/     # News Feed Service
├── notification-service/  # Notification Service
├── award-service/         # Award Service
├── rating-review-service/ # Rating & Review Service
├── analytics-logging-service/ # Analytics & Logging Service
├── moderation-service/    # Moderation Service
├── search-service/        # Search Service
├── celebrate/             # Flutter Web Application
├── config-repo/           # Configuration Repository
└── docker/                # Docker configuration files
```

## Step-by-Step Setup Guide

### 1. Database Setup

1. Install PostgreSQL 14 or later
2. Run the database setup script:
   ```bash
   setup_database.bat
   ```
   This will:
   - Create the following databases:
     - `celebratedb` (core services)
     - `celebrate_news_feed`
     - `celebrate_notification`
     - `celebrate_award`
     - `celebrate_rating_review`
     - `celebrate_analytics`
     - `celebrate_moderation`
     - `celebrate_search`
   - Set up required extensions
   - Create necessary tables and indexes

### 2. Build All Services

1. Open a terminal in the project root directory
2. Build all services:
   ```bash
   gradlew clean build
   ```

### 3. Start All Services

The easiest way to start all services is using the provided batch script:

```bash
start-services.bat
```

This script will:
1. Start Config Server (Port 8888)
2. Start Service Registry (Port 8761)
3. Start Auth Service (Port 8081)
4. Start User Service (Port 8082)
5. Start Post Service (Port 8083)
6. Start Messaging Service (Port 8084)
7. Start News Feed Service (Port 8085)
8. Start Notification Service (Port 8086)
9. Start Award Service (Port 8087)
10. Start Rating-Review Service (Port 8088)
11. Start Analytics-Logging Service (Port 8089)
12. Start Moderation Service (Port 8090)
13. Start Search Service (Port 8091)
14. Start API Gateway (Port 8080)
15. Start Flutter Web App (Port 53042)

### 4. Verify Services

After starting all services, verify they are running correctly:

1. Config Server:
   - Health check: http://localhost:8888/actuator/health
   - Expected response: `{"status":"UP"}`

2. Service Registry (Eureka):
   - Dashboard: http://localhost:8761
   - Verify all services are registered

3. API Gateway:
   - Health check: http://localhost:8080/actuator/health
   - Should be registered with Eureka

4. Flutter Web App:
   - Open: http://localhost:53042
   - Should load the web interface

### 5. Access Points

- Eureka Dashboard: http://localhost:8761
- API Gateway: http://localhost:8080
- Flutter Web App: http://localhost:53042

## Manual Service Start (Alternative)

If you prefer to start services manually, follow this order:

1. Config Server:
   ```bash
   cd config-server
   gradlew bootRun
   ```

2. Service Registry:
   ```bash
   cd service-registry
   gradlew bootRun
   ```

3. Backend Services (in separate terminals, in this order):
   ```bash
   cd auth-service
   gradlew bootRun

   cd user-service
   gradlew bootRun

   cd post-service
   gradlew bootRun

   cd messaging-service
   gradlew bootRun

   cd news-feed-service
   gradlew bootRun

   cd notification-service
   gradlew bootRun

   cd award-service
   gradlew bootRun

   cd rating-review-service
   gradlew bootRun

   cd analytics-logging-service
   gradlew bootRun

   cd moderation-service
   gradlew bootRun

   cd search-service
   gradlew bootRun
   ```

4. API Gateway:
   ```bash
   cd api-gateway
   gradlew bootRun
   ```

5. Flutter Web App:
   ```bash
   cd celebrate
   flutter run -d chrome
   ```

## Troubleshooting

1. **Service Start Order**: Always ensure services are started in the correct order:
   - Config Server first
   - Service Registry second
   - Backend services (see above order)
   - API Gateway last
   - Flutter Web App last

2. **Port Conflicts**: Make sure no other applications are using the required ports:
   - 8888 (Config Server)
   - 8761 (Eureka)
   - 8080 (API Gateway)
   - 8081-8091 (Backend Services)
   - 53042 (Flutter Web App)

3. **Database Issues**:
   - Verify PostgreSQL is running
   - Check database credentials in configuration
   - Ensure all databases are created using setup_database.bat

4. **Common Issues**:
   - If services fail to start, check the logs in their respective windows
   - Ensure all Gradle builds are successful
   - Verify Config Server can access its configuration repository

## Technology Stack

- Spring Boot 3.x
- Spring Cloud 2023.x
- PostgreSQL 14+
- Flutter (Web)
- Netflix Eureka for service discovery
- Spring Cloud Config for centralized configuration
- Spring Cloud Gateway for API routing
- JWT for authentication
- WebSocket for real-time messaging

## Stopping Services

To stop all services:
1. Press `Ctrl+C` in each service window
2. Close the Chrome window running the Flutter web app

## Contributing

Feel free to submit issues and enhancement requests. 
