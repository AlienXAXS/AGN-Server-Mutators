/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_Weapon_Beacon extends Rx_Weapon_Beacon;

function bool IsValidPosition() 
{
	local vector HitLocation, HitNormal, off;
	local Actor HitActor;
	local float ZDistToBuildingCenter;
	
	local vector traceDownwards;
	
	if(bBlockDeployCloseToOwnBase && GetNearestSpottargetLocationIsOwnTeamBuilding())
	{
	  Rx_Controller(Pawn(Owner).Controller).ClientMessage("Planting Beacon failed: This location is too close to your base!");
	  return false;	
	}
	 
	off = Pawn(Owner).location;
	off.z -= 100;  
	HitActor = Trace(HitLocation, HitNormal, off, Pawn(Owner).location, true);
	
	`log("HitActor is " $ string(HitActor));
	
	if(Rx_Building(HitActor) != none) ZDistToBuildingCenter = abs(Rx_Building(HitActor).location.z - Pawn(Owner).location.z);
	if((Rx_Building(HitActor) != None && ZDistToBuildingCenter > 440) && !(Rx_Building_WeaponsFactory(HitActor) != None && ZDistToBuildingCenter < 800) )
	{
		Rx_Controller(Pawn(Owner).Controller).ClientMessage("Planting Beacon failed: This location is invalid!");
		return false; // to prevent beacons to be placed on chimneys, the Hand of the HON etc
	}
	
	if ( Rx_Defence_RocketEmplacement(HitActor) != None || Rx_Defence_SAMSite(HitActor) != None || Rx_Defence_Turret(HitActor) != None )
	{
		`log("Hit actor is a Defence, blocking beacon placement");
		Rx_Controller(Pawn(Owner).Controller).ClientMessage("Planting Beacon failed: This location is invalid!");
		class'AGN_UtilitiesX'.Static.SendMessageToOnlineAdministrators("[WARNING] " $ (Rx_PRI(Rx_Controller(Pawn(Owner).Controller).PlayerReplicationInfo).PlayerName) $ " has attempted to plant a beacon in a glitch spot ontop of a " $ string(HitActor));
		return false;
	} else {
		`log("Hit actor is not a defence");
	}
	
	return true;
}

