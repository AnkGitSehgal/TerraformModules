module "container_module" {
  depends_on        = [module.storgaccnt_module]
  source            = "../../Module/Azurerm_Container"
  contchildvariable = var.cont_parent
}
module "nic_module" {
  depends_on        = [module.subnet_module, module.pip_module, module.rg_module]
  source            = "../../Module/azurerm_NIC"
  nicchildvariable  = var.nic_parent
  sn_data_module    = var.subnet_parent
  pip_data_variable = var.pip_parent
}
module "pip_module" {
  depends_on       = [module.rg_module]
  source           = "../../Module/Azurerm_PIP"
  pipchildvariable = var.pip_parent
}
module "rg_module" {
  source          = "../../Module/azurerm_RG"
  rgchildvariable = var.rg_parent
}
module "storgaccnt_module" {
  depends_on      = [module.rg_module]
  source          = "../../Module/azurerm_Storage_Acc"
  sachildvariable = var.storage_acc_parent
}
module "subnet_module" {
  depends_on      = [module.virtual_network_module, module.rg_module]
  source          = "../../Module/azurerm_SubNet"
  snchildvariable = var.subnet_parent
}
module "virtualmachine_module" {
  depends_on      = [module.nic_module, module.subnet_module, module.kv_module]
  source          = "../../Module/azurerm_VM"
  lvmvariable     = var.vm_parent
  nic_data_module = var.nic_parent
  ukv             = var.usecrets
  usecrets        = var.usecrets
  random          = var.random
}
module "virtual_network_module" {
  depends_on      = [module.rg_module]
  source          = "../../Module/azurerm_VNET"
  vnchildvariable = var.Virtual_Network_Parent
}
module "kv_module" {
  depends_on  = [module.rg_module]
  source      = "../../Module/azurerm_KeyVault"
  kv_variable = var.kv_variable
  usecrets    = var.usecrets
}
module "bastion_module" {
  depends_on = [module.pip_module, module.subnet_module, module.virtualmachine_module, module.kv_module, module.nic_module]
  source     = "../../Module/azurerm_Bastion"
  bastion    = var.bastion
}
# module "module_loadbalancer" {
#   depends_on = [module.virtual_network_module,module.pip_module]
#   source = "../../Module/Aazurerm_LB"
#   outdoorlb = var.outdoorlb
# }
module "module_nsg" {
  depends_on = [module.rg_module,module.subnet_module]
  source = "../../Module/azurerm_NSG"
  nsg_rule = var.nsg_rule
}
module "appgw_module" {
depends_on = [module.virtualmachine_module]
  source = "../../Module/azurerm_APGW"
  appgateway = var.appgateway
}


