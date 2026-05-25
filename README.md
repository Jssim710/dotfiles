# General Dotfiles

This is a collection of environment-agnostic dotfiles and configuration scripts.

## Structure
- `1-general/`: Core bash and profile settings.
- `2-vim/`: Vim configuration and plugins.
- `3-gcp/`: GCP and Kubernetes environment helpers (Starship based).
- `4-git/`: Git aliases and global configuration.
- `5-vscode/`: VS Code settings and shortcuts.

## Installation
Most subdirectories contain a `setup.sh` or specific instructions in their respective `README.md` for linking the configurations to your local environment.

## Available Shell Functions
The following helpers are provided by the **`3-gcp/`** directory:
- **`gcp`**: Activates GCP workspace and Starship prompt.
- **`ungcp`**: Deactivates GCP mode.
- **`k8s`**: Selects a GKE cluster (requires `gcp` mode).
- **`unk8s`**: Deactivates Kubernetes mode and returns to standard GCP mode.
