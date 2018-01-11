class AGN_Vehicle_ReconBike_Weapon extends TS_Vehicle_ReconBike_Weapon;

DefaultProperties
{
	// Reference to our new projectile
	WeaponProjectiles(1) = Class'AGN_Vehicle_ReconBike_Projectile'
	
	// Increased Reload Time
        ReloadTime(0) = 5.5 //4.0
    	ReloadTime(1) = 5.5 //4.0

	// This is unchanged
	Vet_ReloadSpeedModifier(0)=1.00 //Normal (should be 1)
	Vet_ReloadSpeedModifier(1)=0.95 //Veteran 
	Vet_ReloadSpeedModifier(2)=0.90 //Elite
	Vet_ReloadSpeedModifier(3)=0.85 //Heroic

}
