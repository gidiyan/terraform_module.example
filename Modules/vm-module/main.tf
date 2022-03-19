data "azurerm_client_config" "current" {}

resource "azurerm_public_ip" "pip" {
  allocation_method   = var.pip_allocation_method
  location            = var.location
  name                = var.pip_name
  resource_group_name = var.rg
}

data "azurerm_public_ip" "pip" {
  name                = azurerm_public_ip.pip.name
  resource_group_name = azurerm_public_ip.pip.resource_group_name
}

resource "azurerm_network_interface" "nic" {
  location            = var.location
  name                = var.nic_name
  resource_group_name = var.rg
  ip_configuration {
    name                          = var.nic_name
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_virtual_machine" "vm" {
  location              = var.location
  name                  = var.vm_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  resource_group_name   = var.rg
  vm_size               = "Standard_B1s"
  storage_os_disk {
    create_option     = "FromImage"
    name              = "local-${var.vm_name}"
    managed_disk_type = "Standard_LRS"
  }
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  os_profile {
    computer_name  = "vm-${var.vm_name}"
    admin_username = var.user
    admin_password = var.vm_pass
  }
  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      key_data = file("./.terraform/modules/vm/id_rsa.pub")
      path     = "/home/${var.user}/.ssh/authorized_keys"
    }
  }
  provisioner "remote-exec" {
    inline = [
      "echo ${var.vm_pass} | sudo -S apt update && sudo -S apt install htop -y",
      "echo ${var.vm_pass} > ~/test.txt",
      "cat ~/.ssh/authorized_keys > ~/key",
    ]
  }
  connection {
    type        = "ssh"
    user        = var.user
    password    = var.vm_pass
    host        = data.azurerm_public_ip.pip.ip_address
  }
}

