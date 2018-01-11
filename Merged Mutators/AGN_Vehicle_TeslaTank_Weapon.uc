/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_Vehicle_TeslaTank_Weapon extends APB_Vehicle_TeslaTank_Weapon;

DefaultProperties
{
	//Increase range from 4000
	WeaponRange=4500.0
	
	//Increase from 150
	InstantHitDamage(0)=200
	InstantHitDamage(1)=200
	
	// Vet changes 
	Vet_ClipSizeModifier(0)=0 //Recruit
	Vet_ClipSizeModifier(1)=0 //Veteran 
	Vet_ClipSizeModifier(2)=1 //Elite
	Vet_ClipSizeModifier(3)=2 //Heroic
	
	Vet_DamageModifier(0)=1  
	Vet_DamageModifier(1)=1.05 //210
	Vet_DamageModifier(2)=1.10 //220
	Vet_DamageModifier(3)=1.15 //230
}
