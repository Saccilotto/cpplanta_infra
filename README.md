
### Key Components

- **Terraform**: Used for provisioning and managing the infrastructure.
- **Ansible**: Used for configuration management and application deployment.
- **Docker Swarm**: Used for container orchestration.

## Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Docker](https://docs.docker.com/get-docker/)

### Setup

1. **Clone the repository**:
    ```sh
    git clone <repository-url>
    cd <repository-directory>
    ```

2. **Set up environment variables**:
    - Create a `.env` file in the root directory and add the necessary environment variables.

3. **Set up Swarm/static_ip.ini ips**:
    - Add the static IP addresses and SSH locations details for the VMs in the `Swarm/static_ip.ini` file.

4. **Set up SSH keys**:
    - Add the private keys for SSH access to the VMs in the `ssh_keys/` directory.

### Deployment

1. **Run the deployment script**:

    Set up permissions to the script:
    ```sh
    chmod +x deploy.sh
    ```

    ```sh
    ./deploy.sh
    ```

    This script will:
    - Initialize and apply the Terraform configuration to provision the infrastructure.
    - Deploy the Docker Swarm stack using Ansible.
    - Run additional Ansible playbooks to configure the VMs.

### Destroying the Infrastructure

1. **Run the destroy script**:
    ```sh
    ./destroy.sh
    ```

    This script will:
    - Destroy the infrastructure provisioned by Terraform.

## Configuration Details

### Ansible Playbooks

- **Configuration/runners.yml**: Contains tasks to set up GitLab Runners.
- **Swarm/swarm_setup.yml**: Contains tasks to configure the Docker Swarm cluster.

### Inventory

- **Swarm/static_ip.ini**: Contains the static IP addresses and SSH details for the VMs.

### SSH Keys

- **ssh_keys/**: Contains the private keys for SSH access to the VMs.

## Integrate with Your Tools

- [Set up project integrations](https://tools.ages.pucrs.br/cp-planta/infrastructure/-/settings/integrations)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/index.html)

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [AGES](https://www.ages.pucrs.br/) for providing the VMs and support.
- [GitLab](https://about.gitlab.com/) for CI/CD tools and documentation.
- [Docker](https://www.docker.com/) for containerization tools.
- [HashiCorp](https://www.hashicorp.com/) for Terraform.
