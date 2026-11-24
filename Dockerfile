# Etapa 1: Compilación del proyecto Spring Boot con Maven y Java 17
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app
COPY . .
RUN if [ -f project.tar.gz ]; then tar -xzf project.tar.gz; fi \
    && sed -i 's/\r$//' mvnw \
    && chmod +x mvnw \
    && ./mvnw clean package -DskipTests

# Etapa 2: Imagen ligera de ejecución 24/7 en la nube (incluye base de datos precargada automáticamente)
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8085
ENTRYPOINT ["sh", "-c", "java -Dspring.profiles.active=cloud -Dserver.port=${PORT:-8085} -jar app.jar"]
