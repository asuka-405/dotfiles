# PostgreSQL hosting environment with custom service account and port
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "postgres-host";

  # Dependencies for the environment
  buildInputs = [
    pkgs.postgresql # PostgreSQL database
  ];

  # Shell hook for setup
  shellHook = ''
    echo "Initializing PostgreSQL hosting environment..."

    # Prompt for a service account name
    read -p "Enter the service account name: " SERVICE_ACCOUNT
    if [[ -z "$SERVICE_ACCOUNT" ]]; then
      echo "Service account name cannot be empty. Exiting."
      exit 1
    fi

    # Prompt for a custom port
    read -p "Enter the PostgreSQL port (default 5432): " CUSTOM_PORT
    CUSTOM_PORT=${CUSTOM_PORT:-5432}

    # Initialize the PostgreSQL database
    echo "Setting up PostgreSQL on port $CUSTOM_PORT..."
    initdb -D $PWD/data
    echo "port = $CUSTOM_PORT" >> $PWD/data/postgresql.conf

    # Start PostgreSQL in the foreground (you can change this to suit your needs)
    echo "Starting PostgreSQL..."
    pg_ctl -D $PWD/data -o "-p $CUSTOM_PORT" start

    # Create the service account
    psql -p $CUSTOM_PORT -c "CREATE ROLE $SERVICE_ACCOUNT WITH LOGIN CREATEDB PASSWORD 'changeme';"
    echo "Service account '$SERVICE_ACCOUNT' created with default password 'changeme'."

    echo "PostgreSQL hosting environment is ready."
    echo "Database directory: $PWD/data"
    echo "Custom port: $CUSTOM_PORT"
    echo "Service account: $SERVICE_ACCOUNT"
  '';
}

