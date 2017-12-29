class AGN_Weapon_Beacon extends Rx_Weapon_Beacon;

function bool IsValidPosition() 
{
	local vector HitLocation, HitNormal, off;
	local Actor HitActor;
	local float ZDistToBuildingCenter;
	
	if(bBlockDeployCloseToOwnBase && GetNearestSpottargetLocationIsOwnTeamBuilding())
	{
	  Rx_Controller(Pawn(Owner).Controller).ClientMessage("Planting Beacon failed: This location is too close to your base!");
	  return false;	
	}
	 
	off = Pawn(Owner).location;
	off.z -= 100;  
	HitActor = Trace(HitLocation, HitNormal, off, Pawn(Owner).location, true);
	if(Rx_Building(HitActor) != none) ZDistToBuildingCenter = abs(Rx_Building(HitActor).location.z - Pawn(Owner).location.z);
	if((Rx_Building(HitActor) != None && ZDistToBuildingCenter > 440) && !(Rx_Building_WeaponsFactory(HitActor) != None && ZDistToBuildingCenter < 800) )
	{
		Rx_Controller(Pawn(Owner).Controller).ClientMessage("Planting Beacon failed: This location is invalid!");
		return false; // to prevent beacons to be placed on chimneys, the Hand of the HON etc
	}
	
	return true;
}