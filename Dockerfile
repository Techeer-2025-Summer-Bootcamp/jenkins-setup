FROM jenkins/jenkins:latest

# Switch to root for installing packages
USER root

# Install essential tools
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    nodejs \
    npm \
    wget \
    openssh-client \
    git

# Add Docker's GPG key
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Register Docker repo
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker CLI & Compose Plugin
RUN apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add Jenkins to Docker group
RUN usermod -aG docker jenkins && \
    usermod -aG users jenkins

# Revert back to Jenkins user
USER jenkins
