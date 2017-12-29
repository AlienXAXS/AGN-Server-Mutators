/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_InventoryManager_Nod_Raveshaw extends AGN_InventoryManager_Adv_NOD;

DefaultProperties
{
	PrimaryWeapons[0] = class'Rx_Weapon_Railgun' //2
	PrimaryWeapons[1] = class'Rx_Weapon_ATMine' //4
	PrimaryWeapons[2] = class'Rx_Weapon_EMPGrenade_Rechargeable' //5
	SidearmWeapons[0] = class'Rx_Weapon_HeavyPistol' //1
	ExplosiveWeapons[0] = class'Rx_Weapon_TimedC4' //3
	
	
	AvailableSidearmWeapons(0) = class'Rx_Weapon_HeavyPistol'
	
	//Minor Customization
	//AvailableSidearmWeapons(1) = class'Rx_Weapon_SMG_NOD'
	//AvailableExplosiveWeapons(2) = class'Rx_Weapon_ATMine'
}

