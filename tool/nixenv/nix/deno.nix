# Minimal Deno development environment with Git
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "deno-env";

  # Dependencies for the environment
  buildInputs = [
    pkgs.deno   # Deno runtime
    pkgs.git    # Git for version control
  ];

  # Optional: Set environment variables if needed
  DENO_ENV = "development";

  # Shell hook for initialization messages
  shellHook = ''
    echo "Welcome to the Deno development environment!"
    echo "Deno version: $(deno --version)"
    echo "Git version: $(git --version)"
  '';
}

