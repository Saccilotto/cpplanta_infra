# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_prefixes
}

# Public IP for cp-planta VMs
resource "azurerm_public_ip" "cp-planta_vm_public_ip" {
  for_each            = toset(var.vm_names)
  name                = "cp-planta-vm-public-ip-${each.key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic" {
  for_each            = toset(var.vm_names)
  name                = "cp-planta-nic-${each.key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.cp-planta_vm_public_ip[each.key].id
  }
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "cp-planta-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Docker Swarm Manager
  security_rule {
    name                       = "allow-docker-swarm-manager"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "2377"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Docker Swarm Node Communication
  security_rule {
    name                       = "allow-docker-swarm-communication"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "7946"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Docker Swarm Overlay Network
  security_rule {
    name                       = "allow-docker-swarm-overlay-network"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "UDP"
    source_port_range          = "*"
    destination_port_range     = "4789"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # PostgreSQL
  security_rule {
    name                       = "allow-postgresql"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # pgAdmin HTTP
  security_rule {
    name                       = "allow-pgadmin"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # pgAdmin HTTPS
  security_rule {
    name                       = "allow-pgadmin-https"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Backend Node.js (Port 3000)
  security_rule {
    name                       = "allow-backend-nodejs"
    priority                   = 160
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Frontend Node.js (Port 3001)
  security_rule {
    name                       = "allow-frontend-nodejs"
    priority                   = 170
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "3001"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # GitLab Runner SSH
  security_rule {
    name                       = "allow-gitlab-runner-ssh"
    priority                   = 180
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # GitLab Runner HTTP
  security_rule {
    name                       = "allow-gitlab-runner-http"
    priority                   = 190
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # GitLab Runner HTTPS
  security_rule {
    name                       = "allow-gitlab-runner-https"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # SSH access for VM management
  security_rule {
    name                       = "allow-ssh"
    priority                   = 210
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "nsg_association" {
  for_each                   = azurerm_network_interface.nic
  network_interface_id       = each.value.id 
  network_security_group_id  = azurerm_network_security_group.nsg.id
}