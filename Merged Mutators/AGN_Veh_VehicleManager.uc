class AGN_Veh_VehicleManager extends Rx_VehicleManager;

function Initialize(GameInfo Game, UTTeamInfo GdiTeamInfo, UTTeamInfo NodTeamInfo)
{
	local Vector loc;
	local Rotator rot;
	
	Super.Initialize(Game, GdiTeamInfo, NodTeamInfo);

	// Reset the vehicle spawning locations for both buildings, otherwise stuff spawns god knows where!
	if(WorldInfo.Netmode != NM_Client) {
		AirStrip.BuildingInternals.BuildingSkeleton.GetSocketWorldLocationAndRotation('Veh_DropOff', loc, rot);
		loc.z+=1000;
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