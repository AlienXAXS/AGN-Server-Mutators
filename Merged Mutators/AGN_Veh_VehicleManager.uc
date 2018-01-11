/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_Veh_VehicleManager extends Rx_VehicleManager;

function Initialize(GameInfo Game, UTTeamInfo GdiTeamInfo, UTTeamInfo NodTeamInfo)
{
	local Vector loc;
	local Rotator rot;
	
	Super.Initialize(Game, GdiTeamInfo, NodTeamInfo);

	// Reset the vehicle spawning locations for both buildings, otherwise stuff spawns god knows where!
	if(WorldInfo.Netmode != NM_Client) {
		AirStrip.BuildingInternals.BuildingSkeleton.GetSocketWorldLocationAndRotation('Veh_DropOff', loc, rot);
		loc.z+=100;
		Set_NOD_ProductionPlace(loc, rot);
		WeaponsFactory.BuildingInternals.BuildingSkeleton.GetSocketWorldLocationAndRotation('Veh_Spawn', loc, rot);
		Set_GDI_ProductionPlace(loc, rot);
	}
	
	// Spawn the harvs on single player.
	if(`WorldInfoObject.NetMode != NM_DedicatedServer)
		SpawnInitialHarvesters();
}

DefaultProperties
{
	MessageClass = class'AGN_Veh_Message_VehicleProduced'
}

