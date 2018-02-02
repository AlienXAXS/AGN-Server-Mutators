/*
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 *
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 *
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 *
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_Weapon_RepairGunAdvanced extends AGN_Weapon_RepairGun;

DefaultProperties
{
    HealAmount = 40;
	  MineDamageModifier=2.0;
	  WeaponRange=900.0

  	InventoryMovieGroup=20

	/*******************/
	/*Veterancy*/
	/******************/

	 Vet_DamageModifier(0)=1  //Applied to instant-hits only
	 Vet_DamageModifier(1)=1.05 //42
	 Vet_DamageModifier(2)=1.10 //44
	 Vet_DamageModifier(3)=1.15 //46

	/**********************/

	 WeaponIconTexture=Texture2D'RX_WP_RepairGun.UI.T_WeaponIcon_RepairGunAdvanced'
}
