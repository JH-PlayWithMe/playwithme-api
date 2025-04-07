# Step 1: React 빌드
# Base image : Node -> Frontend
FROM node:18 AS frontend-build

WORKDIR /app
# frontend 폴더 복사
COPY frontend/ ./
RUN npm install
RUN npm run build

# Step 2: Spring Boot 빌드
FROM maven:3.9.4-eclipse-temurin-17 AS backend-build

WORKDIR /app
COPY . .
COPY --from=frontend-build /app/build ./src/main/resources/static
RUN ./mvnw clean package -DskipTests

# Step 3: 실행 이미지
FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY --from=backend-build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]