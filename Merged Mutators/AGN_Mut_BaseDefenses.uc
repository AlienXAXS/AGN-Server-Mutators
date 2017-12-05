/** 
 *  Mesh to be created for GDI:
 *  StaticMesh'RX_BU_RepairFacility.Meshes.SM_RepFacility_GDI'
 *
 *  NOD:
 *	StaticMesh'RX_BU_RepairFacility.Meshes.SM_RepFacility_NOD'
 * */
class AGN_Mut_BaseDefenses extends RX_Mutator;

var array<AGN_Memory> Defenses;
var repnotify Rx_Building_Internals myBuildingInternals;

function InitMutator(string options, out string errorMessage)
{
	FindBaseDefences();
}

reliable server function FindBaseDefences()
{
	local Rx_Defence thisTurret;
	local Vector tmpSpawnPoint;
	local Rotator tmpRotator;
	local int tmpYaw;
	local AGN_CapturableMCT myActor;
	local AGN_Memory agnMemory;
	local Rx_CapturableMCT thisMCT;
	local Rx_Building tmpBuilding;

	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'Rx_Defence', thisTurret)
	{
		agnMemory = new class'AGN_Memory';
		agnMemory.Turret = thisTurret;
		agnMemory.TurretLocation = thisTurret.Location;
		agnMemory.TurretRotation = thisTurret.Rotation;
	
		tmpSpawnPoint = thisTurret.Location - vector(thisTurret.Rotation)*100;
		//tmpSpawnPoint.X -= 500;
		//tmpSpawnPoint.Y -= -350;
		tmpYaw = thisTurret.Rotation.Yaw + 32768;
		tmpRotator.Yaw = tmpYaw;
		tmpSpawnPoint.Z -= 20;

		
		LogInternal ( "[AGN] Spawning in our CapturableMCT at " $ string(tmpSpawnPoint) );
		myActor = Spawn(class'AGN_Mut_AlienXSystem.AGN_CapturableMCT',,, tmpSpawnPoint, tmpRotator);
		if ( myActor != none )
			LogInternal ( "    -> SUCCESS" );
		else
			LogInternal ( "    -> FAILURE" );
		
		agnMemory.AssignedMCT = myActor;
		//tmpBuilding = Spawn(class'Rx_Building_Silo',,, tmpSpawnPoint, tmpRotator);
		//tmpBuilding.Health = 1000;
		//tmpBuilding.HealthMax = 1000;
		
		if ( Rx_Building_TechBuilding_Internals(myActor.BuildingInternals) != None )
		{
			//myBuildingInternals = spawn(class'AGN_BaseDefenceMCT_Internals',myActor,class'AGN_BaseDefenceMCT_Internals'.Name,thisTurret.Location,thisTurret.Rotation);
			//myBuildingInternals.BuildingVisuals = tmpBuilding;
			//myBuildingInternals.Init(tmpBuilding, false);
			//myBuildingInternals.Health = 1000;
			//myBuildingInternals.HealthMax = 1000;
			
			//myActor.BuildingInternals.Destroy();
			//myActor.BuildingInternals = myBuildingInternals;
			AGN_BaseDefenceMCT_Internals(myActor.BuildingInternals).ChangeTeamReplicate(255, true);
			AGN_BaseDefenceMCT_Internals(myActor.BuildingInternals).Health = 0;
			AGN_BaseDefenceMCT_Internals(myActor.BuildingInternals).HealthMax = 400;
			LogInternal ( "[AGN] Changed team replicate for this MCT | myBuildingInternals.GetTeamNum() = " $ myBuildingInternals.GetTeamNum() );
		}
		else
			LogInternal ( "[AGN] Unable to ChangeTeamReplicate to TEAM_NOD" );
		
		Defenses.AddItem(agnMemory);
	}
}

function Mutate(string MutateString, PlayerController Sender)
{}

function SendMessageToAllPlayers(string message)
{
	local Controller c;
	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
	{
		if ( c != None )
			if ( Rx_Controller(c) != none )
				Rx_Controller(c).CTextMessage("[AGN] " $ message,'LightGreen',50);
	}
}

function bool CheckReplacement(Actor Other)
{
	return true;
}

DefaultProperties
{

}