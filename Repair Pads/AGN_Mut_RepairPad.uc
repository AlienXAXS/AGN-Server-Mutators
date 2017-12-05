/** 
 *  Mesh to be created for GDI:
 *  StaticMesh'RX_BU_RepairFacility.Meshes.SM_RepFacility_GDI'
 *
 *  NOD:
 *	StaticMesh'RX_BU_RepairFacility.Meshes.SM_RepFacility_NOD'
 * */
class AGN_Mut_RepairPad extends RX_Mutator;

struct native RepairPadStruct {
	var String MapName;
	var String Team;
	var Vector Location;
	var Rotator Rotation;
};

var string CurrentMapName;
var RepairPadStruct ActiveRepairPad_GDI;
var RepairPadStruct ActiveRepairPad_Nod;
var bool SpawnedAlready;
var Rx_Building NodPad;
var Rx_Building GDIPad;

var transient array<RepairPadStruct> RepairPads;

function InitMutator(string options, out string errorMessage)
{
	SetRepairPadsForMaps();
	createPad();
	
	// Only activate the timer if we have an active repair pad.
	
	LogInternal ( "[AGN-RepairPads-DEBUG] GDI: " $ string(GDIPad) $ " NOD: " $ string(NodPad) );
	
	if ( NodPad != None || GDIPad != None )
		setTimer(1, true, 'FindAndRepair');
		
	NextMutator.InitMutator(options, errorMessage);
}


// Scans all vehicles, finds the vehicle loc and checks distance from the repair pad.
reliable server function FindAndRepair()
{
	local Rx_Vehicle thisVehicle;
	local int distance;
	local int repairRate;
	local int otherRepairRate;
	local Rx_Building building;
	local int creditCostPerTick;
	local int otherCreditCostPerTick;
	local Rx_PRI PlayerReplicationInfo;
	local Rx_Building thisRepairPad;
	
	distance = 400;
	repairRate = 25;
	creditCostPerTick = 4;

	// Loop around each vehicle
	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'Rx_Vehicle', thisVehicle)
	{
		otherRepairRate = repairRate;
		otherCreditCostPerTick = creditCostPerTick;
		if (thisVehicle.isA('Rx_Vehicle_Harvester') || thisVehicle.isA('Rx_Defence_Turret') ) //`
			continue;
			
		if ( thisVehicle.Driver != None )
		{
			if ( Rx_Pawn(thisVehicle.Driver) == none || Rx_PRI(thisVehicle.PlayerReplicationInfo) == none )
				continue;
			
			PlayerReplicationInfo = Rx_PRI(thisVehicle.PlayerReplicationInfo);

			if ( thisVehicle.Driver.GetTeamNum() == TEAM_GDI && !GDIPad.IsDestroyed() )
				thisRepairPad = GDIPad;
			else
				if ( NodPad.IsDestroyed() )
					continue;
				else
					thisRepairPad = NodPad;
						
			if ( !IsDistanceLessThan(thisRepairPad.Location, thisVehicle.Location, distance) )
				continue;
								
			if ( thisVehicle.Health < thisVehicle.HealthMax )
			{
				//Figure out repair rate if the powerplant is killed
				ForEach Rx_Game(`WorldInfoObject.Game).AllActors(class'Rx_Building',building)  //`
				{
					if ( thisVehicle.Driver.GetTeamNum() == TEAM_GDI )
					{
						if ( Rx_Building_GDI_PowerFactory(building) != none && Rx_Building_GDI_PowerFactory(building).IsDestroyed() )
							otherRepairRate = (repairRate / 2);
							
						if ( Rx_Building_GDI_PowerFactory(building) != none && Rx_Building_GDI_PowerFactory(building).IsDestroyed() )
							otherRepairRate = (repairRate / 2);
							
					} else {
						if ( Rx_Building_Nod_MoneyFactory(building) != none && Rx_Building_Nod_MoneyFactory(building).IsDestroyed() )
							otherCreditCostPerTick = 3;
							
						if ( Rx_Building_GDI_MoneyFactory(building) != none && Rx_Building_GDI_MoneyFactory(building).IsDestroyed() )
							otherCreditCostPerTick = 3;
					}
				}
				
				if ( PlayerReplicationInfo.GetCredits() > creditCostPerTick )
				{
					PlayerReplicationInfo.RemoveCredits(otherCreditCostPerTick);
					
					if ( (thisVehicle.Health + otherRepairRate)  > thisVehicle.HealthMax )
						thisVehicle.Health = thisVehicle.HealthMax;
					else
						thisVehicle.Health += otherRepairRate;
				} else {
					thisVehicle.Driver.ClientMessage("Unable to repair: Not enough credits");
				}
			}
		}
	}
}

function SendMessageToAllPlayers(string message)
{
	local Controller c;
	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
	{
		if ( c != None )
			Rx_Controller(c).CTextMessage("[AGN] " $ message,'LightGreen',50);
	}
}

function bool IsDistanceLessThan(vector a, vector b, float distance)
{
   return (VSizeSq(a-b) < distance**2 );
}

function RepairPadStruct FindRepairPadForThisMap(string TeamName)
{
	local RepairPadStruct RepairPad;
	local RepairPadStruct RepairPadNone;
	
	foreach RepairPads ( RepairPad )
	{
		if ( RepairPad.MapName ~= CurrentMapName && RepairPad.Team ~= TeamName )
		{
			return RepairPad;
		}
	}

	RepairPadNone.Team = "";
	return RepairPadNone;
}

reliable server function SetRepairPadsForMaps()
{
	local String mapname;
	
	if ( SpawnedAlready == true )
		return;
	
	SpawnedAlready = true;
	
	mapname=string(WorldInfo.GetPackageName()) ; 			
	if(right(mapname, 6) ~= "_NIGHT") mapname = Left(mapname, Len(mapname)-6);   	
	if(right(mapname, 4) ~= "_DAY") mapname = Left(mapname, Len(mapname)-4);
	CurrentMapName = mapname;
	
	/*
	* MAP:
	 * 	CNC-Fort
	 */
	AddRepairPad("CNC-Fort", "GDI", vect(5636, -4604, -38), rot(0, 9216, 0)); //GDI
	AddRepairPad("CNC-Fort", "Nod", vect(-8214, 5872, -69), rot(0, 3072, 0)); //NOD

	// CNC-Under
	// GDI: Object.Movement.Location (X=-1777.700439,Y=-3044.976074,Z=-9.931030) | Object.Movement.Rotation (Pitch=0,Yaw=5760,Roll=0)
	// NOD: Object.Movement.Location (X=8260.000000,Y=3788.000000,Z=-6.000000) | Object.Movement.Rotation (Pitch=0,Yaw=-4096,Roll=0)
	AddRepairPad("CNC-Under", "GDI", vect(-1777.700439,-3044.976074,-9.931030), rot(0, 5760, 0));
	AddRepairPad("CNC-Under", "Nod", vect(8260.000000,3788.000000,-6.000000), rot(0, -4096, 0));

	//CNC-Island
	//GDI: Object.Movement.Location (X=13345.544922,Y=13167.833984,Z=-390.768707) | Object.Movement.Rotation (Pitch=-416,Yaw=1120,Roll=-173)
	//NOD: Object.Movement.Location (X=11518.041992,Y=-1853.886475,Z=-422.133636) | Object.Movement.Rotation (Pitch=-878,Yaw=597,Roll=-188)
	AddRepairPad("CNC-Islands", "GDI", vect(13345.544922,13167.833984,-390.768707), rot(-416,1120,-173));
	AddRepairPad("CNC-Islands", "Nod", vect(11518.041992,-1853.886475,-422.133636), rot(-878,597,-188));

	//CNC-Walls_Flying
	//GDI: Object.Movement.Location (X=-15026.807617,Y=6580.989258,Z=-26.022339) | Object.Movement.Rotation (Pitch=-361,Yaw=-7791,Roll=1034)
	//NOD: Object.Movement.Location (X=-6602.080566,Y=-7998.065918,Z=-217.232254) | Object.Movement.Rotation (Pitch=288,Yaw=0,Roll=224)
	AddRepairPad("CNC-Walls_Flying", "GDI", vect(-15026.807617,6580.989258,-26.022339), rot(-361,-7791,1034));
	AddRepairPad("CNC-Walls_Flying", "Nod", vect(-6602.080566,-7998.065918,-217.232254), rot(288,0,224));

	//CNC-Xmountain
	//GDI: Object.Movement.Location (X=21039.857422,Y=18616.523438,Z=1411.893677) | Object.Movement.Rotation (Pitch=0,Yaw=-3232,Roll=704)
	//NOD: Object.Movement.Location (X=16000.715820,Y=9112.289063,Z=1442.319946) | Object.Movement.Rotation (Pitch=-1312,Yaw=-28,Roll=-640)
	AddRepairPad("CNC-Xmountain", "GDI", vect(21039.857422,18616.523438,1411.893677), rot(0,-3232,704));
	AddRepairPad("CNC-Xmountain", "Nod", vect(16000.715820,9112.289063,1442.319946), rot(-1312,-28,-640));

	//CNC-Field
	//GDI: Object.Movement.Location (X=234.495621,Y=8966.664063,Z=85.967491) | Object.Movement.Rotation (Pitch=0,Yaw=0,Roll=-544)
	//NOD: Object.Movement.Location (X=6677.260254,Y=115.203735,Z=44.816742) | Object.Movement.Rotation (Pitch=0,Yaw=0,Roll=0)
	AddRepairPad("CNC-Field", "GDI", vect(234.495621,8966.664063,85.967491), rot(0,0,-544));
	AddRepairPad("CNC-Field", "Nod", vect(6677.260254,115.203735,44.816742), rot(0,0,0));

	//CNC-LakeSide
	AddRepairPad("CNC-LakeSide", "GDI", vect(-379.420929, 5134.744141, -5270.529297), rot(192,-43, 832));
	AddRepairPad("CNC-LakeSide", "Nod", vect(-34.048794, -7152.664551, -5301.770020), rot(344, -252, 435));

	//CNC-Tunnels
	AddRepairPad("CNC-Tunnels", "GDI", vect(12068.624023 , 7013.181641, -10.813853), rot(0,0, -64));
	AddRepairPad("CNC-Tunnels", "Nod", vect(-12305.467773, -5516.544434, -3.057502), rot(344, -252, 435));

	//CNC-Complex
	AddRepairPad("CNC-Complex", "GDI", vect(12394.444336, 1651.816406, 461.762970), rot(0, 0, 0));
	AddRepairPad("CNC-Complex", "Nod", vect(-4705.955566, 4071.534424, 479.759766), rot(-36, -2624, -64));

	AddRepairPad("CNC-Whiteout", "GDI", vect(-9790.363281, 9821.301758, -107.533974), rot(0, 0, 0));
	AddRepairPad("CNC-Whiteout", "Nod", vect(-13344.160156, -8841.881836, -52.702999), rot(0, 8032, 0));

	//CNC-Volcano
	AddRepairPad("CNC-Volcano", "GDI", vect(1678.898926, 1804.753296, 1395.703857), rot(0, 0, 0));
	AddRepairPad("CNC-Volcano", "Nod", vect(14273.462891, 6932.705078, 1410.435425), rot(-457, -4010, 146));

	//CNC-Reservoir
	AddRepairPad("CNC-Reservoir", "GDI", vect(-7218.759766, -475.030121, 1173.788940), rot(1344, 0, 0));
	AddRepairPad("CNC-Reservoir", "Nod", vect(6132.775391, 2371.423828, 1260.554321), rot(0, 0, 0));

	//CNC-TombRedux
	AddRepairPad("CNC-TombRedux", "GDI", vect(-9.000076, 4663.391113, -25.084736), rot(0, 0, 0));
	AddRepairPad("CNC-TombRedux", "Nod", vect(2843.917480, -6272.639648, -4.511409), rot(0, 0, 0));

	//CNC-Mesa
	AddRepairPad("CNC-Mesa", "GDI", vect(-5063.855957, 1628.243286, 35.749413), rot(0, 0, 0));
	AddRepairPad("CNC-Mesa", "Nod", vect(2659.239258, -3863.669922, 47.344437), rot(0, 0, 0));
}

reliable server function createPad()
{
	
	// Get the repair pads for this map
	ActiveRepairPad_GDI = FindRepairPadForThisMap("GDI");
	ActiveRepairPad_Nod = FindRepairPadForThisMap("NOD");
	
	// If this map has a GDI Repair pad, lets spawn it.
	if ( ActiveRepairPad_GDI.Team != "" )
	{
		LogInternal ( "[AGN-RepairPads] SPAWNING GDI REPAIRPAD");
		GDIPad = Spawn(class'AGN_Mut_RepairPad.AGN_RepairPad_GDI',,, ActiveRepairPad_GDI.Location, ActiveRepairPad_GDI.Rotation);
	}
	
	if ( ActiveRepairPad_Nod.Team != "" )
	{
		LogInternal ( "[AGN-RepairPads] SPAWNING NOD REPAIRPAD");
		NodPad = Spawn(class'AGN_Mut_RepairPad.AGN_RepairPad_NOD',,, ActiveRepairPad_Nod.Location, ActiveRepairPad_Nod.Rotation);
	}
}

function AddRepairPad(string MapName, string TheTeam, Vector TheLocation, Rotator TheRotation)
{
	local RepairPadStruct RepairPad;
	
	RepairPad.MapName = MapName;
	RepairPad.Team = TheTeam;
	RepairPad.Location = TheLocation;
	RepairPad.Rotation = TheRotation;
	
	RepairPads.AddItem(RepairPad);
	
	LogInternal ( "[AGN-RepairPads] Successfully added repairpad: MAP: " $ MapName $ " Team: " $ TheTeam $ " Location: " $ string(TheLocation) $ " Rotation: " $ string(TheRotation) $ " TotalPads: " $ string(RepairPads.Length) );
}

function bool CheckReplacement(Actor Other)
{
	
	return true;
}

DefaultProperties
{

}