/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_InventoryManager_GDI_RocketSoldier extends AGN_InventoryManager_Adv_GDI;

DefaultProperties
{
	PrimaryWeapons[0] = class'Rx_Weapon_MissileLauncher' //2
	SidearmWeapons[0] = class'Rx_Weapon_SMG_GDI' //1
	PrimaryWeapons[1] = class'Rx_Weapon_ATMine' //4
	
	//Minor Customization
	AvailableSidearmWeapons(0) = class'Rx_Weapon_SMG_GDI'
	
	//AvailableExplosiveWeapons(2) = class'Rx_Weapon_ATMine'
	
	}

