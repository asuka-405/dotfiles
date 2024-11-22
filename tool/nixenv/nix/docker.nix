# Sandboxed docker & docker-compose environment

{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "docker-env";

  # Dependencies for Docker and Docker Compose
  buildInputs = [
    pkgs.docker
    pkgs.docker-compose
  ];

  # Environment variables or configurations
  shellHook = ''
    echo "Docker environment is ready!"
    echo "Use 'docker' and 'docker-compose' to manage containers."
    
    # Start Docker daemon if it's not already running
    if ! systemctl is-active --quiet docker; then
      echo "Starting Docker daemon..."
      sudo systemctl start docker
    fi
  '';
}

