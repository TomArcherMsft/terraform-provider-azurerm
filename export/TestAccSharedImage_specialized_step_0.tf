
provider "azurerm" {
  features {}
}

variable "hyper_v_generation" {
  default = "V1"
}

resource "azurerm_resource_group" "test" {
  name     = "acctestRG-221019054023432878"
  location = "West Europe"
}

resource "azurerm_shared_image_gallery" "test" {
  name                = "acctestsig221019054023432878"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
}

resource "azurerm_shared_image" "test" {
  name                = "acctestimg221019054023432878"
  gallery_name        = azurerm_shared_image_gallery.test.name
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  os_type             = "Linux"
  specialized         = true
  hyper_v_generation  = var.hyper_v_generation != "" ? var.hyper_v_generation : null

  identifier {
    publisher = "AccTesPublisher221019054023432878"
    offer     = "AccTesOffer221019054023432878"
    sku       = "AccTesSku221019054023432878"
  }
}
