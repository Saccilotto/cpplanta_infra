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

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowPostregresql"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowMongoDB"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "27017"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowPrometheus"
    priority                   = 1005
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9090"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowNode"
    priority                   = 1006
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {	 
    name                       = "AllowNodeExporter"	    
    priority                   = 1007	   
    direction                  = "Inbound"	
    access                     = "Allow"	
    protocol                   = "Tcp"	
    source_port_range          = "*"	
    destination_port_range     = "9100"	
    source_address_prefix      = "*"	
    destination_address_prefix = "*"	
  }	

  security_rule {
    name                       = "AllowPostgresqlExporter"	
    priority                   = 1008
    direction                  = "Inbound"	
    access                     = "Allow"	
    protocol                   = "Tcp"	
    source_port_range          = "*"	
    destination_port_range     = "9187"	
    source_address_prefix      = "*"	
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowFrontend"	
    priority                   = 1009	
    direction                  = "Inbound"	
    access                     = "Allow"	
    protocol                   = "Tcp"	
    source_port_range          = "*"	
    destination_port_range     = "8080"	
    source_address_prefix      = "*"	
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowFrontend"
    priority                   = 1006
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3001"
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