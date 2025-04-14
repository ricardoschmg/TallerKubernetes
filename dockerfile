# Usa una imagen base de OpenJDK
FROM openjdk:17-jdk-slim

# Copia el archivo .jar desde el directorio target a /app.jar
COPY target/miapp-1.0-SNAPSHOT.jar /app.jar

# Expone el puerto 8080
EXPOSE 8080

# Comando para ejecutar la aplicación

ENTRYPOINT ["java", "-jar", "/app.jar"]