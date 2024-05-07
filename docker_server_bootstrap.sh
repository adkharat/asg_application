#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker $(whoami)
newgrp docker
sudo chmod 666 /var/run/docker.sock

# Run Frontend application on host port 80
docker run -d -p 80:80 -e REACT_APP_PUBLIC_URL=weekendbuyer.shop adkharat/react-currency-exchange-app-fe:16   

# Run Backend application-1 on host port 8080 with environment variables
docker run -d -p 8080:8080 -e SPRING_DATASOURCE_USERNAME=root -e SPRING_DATASOURCE_PASSWORD=qwertyui -e SPRING_DATASOURCE_URL="jdbc:mysql://database-13.ct62ugc84t0z.us-east-1.rds.amazonaws.com:3306/company?createDatabaseIfNotExist=true&characterEncoding=UTF-8&useUnicode=true&useSSL=false&allowPublicKeyRetrieval=true" -e FEIGN_CLIENT_NAME=localhost -e FEIGN_CLIENT_URL=http://localhost:8081 adkharat/first_spring_boot_to_rds_1:16
  
# Run Backend application-2 on host port 8081 with environment variables
docker run -d -p 8081:8081 -e SPRING_DATASOURCE_USERNAME=root -e SPRING_DATASOURCE_PASSWORD=qwertyui -e SPRING_DATASOURCE_URL="jdbc:mysql://database-13.ct62ugc84t0z.us-east-1.rds.amazonaws.com:3306/company?createDatabaseIfNotExist=true&characterEncoding=UTF-8&useUnicode=true&useSSL=false&allowPublicKeyRetrieval=true" adkharat/second_spring_boot_to_rds_1:16


#Note : 
#Update above script as per your database URL, PORT, ENV_VARIABLES, etc...