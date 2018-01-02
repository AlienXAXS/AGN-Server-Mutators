/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_InventoryManager_GDI_Sydney extends AGN_InventoryManager_Adv_GDI;

DefaultProperties
{
	PrimaryWeapons[0] = class'AGN_Weapon_PersonalIonCannon' // Lets leave it at this.
    PrimaryWeapons(1)=none
    PrimaryWeapons(2)=class'Rx_Weapon_ATMine'
    SidearmWeapons(0)=class'Rx_Weapon_HeavyPistol'
    AvailableSidearmWeapons(0)=class'Rx_Weapon_HeavyPistol'
    AvailableAbilityWeapons(0)=class'Rx_WeaponAbility_EMPGrenade'
}