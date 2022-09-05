

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "acctest-compute-220905045548133554"
  location = "West Europe"
}

resource "azurerm_shared_image_gallery" "test" {
  name                = "acctestsig220905045548133554"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
}


resource "azurerm_gallery_application" "test" {
  name              = "acctest-app-220905045548133554"
  gallery_id        = azurerm_shared_image_gallery.test.id
  location          = azurerm_resource_group.test.location
  supported_os_type = "Linux"

  description           = "This is the gallery application description."
  end_of_life_date      = "2022-09-05T14:55:48Z"
  eula                  = "https://eula.net"
  privacy_statement_uri = "https://privacy.statement.net"
  release_note_uri      = "https://release.note.net"

  tags = {
    ENV = "Test"
  }
}
