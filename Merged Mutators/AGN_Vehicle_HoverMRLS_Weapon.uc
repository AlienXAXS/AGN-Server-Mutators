class AGN_Vehicle_HoverMRLS_Weapon extends TS_Vehicle_HoverMRLS_Weapon;

DefaultProperties
{
	// Increased Reload Time
	ReloadTime(0) = 4.5 //4.0
    ReloadTime(1) = 4.5 //4.0
	
	// Shorter lock range
	LockRange = 10000 //12000
	
	// Vet changes 
	Vet_ClipSizeModifier(0)=0 //Normal (should be 1)
	Vet_ClipSizeModifier(1)=1 //Veteran 
	Vet_ClipSizeModifier(2)=2 //Elite
	Vet_ClipSizeModifier(3)=3 //Heroic
	
	// Overwrite weapon classes
	WeaponProjectiles(0) = Class'AGN_Vehicle_HoverMRLS_Projectile'
	WeaponProjectiles(1) = Class'AGN_Vehicle_HoverMRLS_Projectile'
	
	// Slightly slower firing speed
	FireInterval(0)=0.4
    FireInterval(1)=0.4
}