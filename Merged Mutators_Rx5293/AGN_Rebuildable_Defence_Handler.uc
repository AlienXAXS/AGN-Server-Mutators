class AGN_Rebuildable_Defence_Handler extends Rx_Mutator;

struct native DefencePositionStruct {
	var String MapName;
	var byte Team;
	var Vector Location;
	var Rotator Rotation;
	var bool bStartDead;
	var int PurchasePrice;
	var byte TurretType; //0 = Gun Turret | 1 = NodTurret
};

var string CurrentMapName;
var transient array<DefencePositionStruct> DefenceStructures;

function InitSystem()
{
	local string mapname;
	local Rx_Defence xDefenceTurret;
	
	// Dont spawn these on a client
	if(`WorldInfoObject.NetMode != NM_DedicatedServer)
		return;
	
	mapname=string(WorldInfo.GetPackageName()); 			
	if(right(mapname, 6) ~= "_NIGHT") mapname = Left(mapname, Len(mapname)-6);   	
	if(right(mapname, 4) ~= "_DAY") mapname = Left(mapname, Len(mapname)-4);
	CurrentMapName = mapname;
	
	//Islands - GDI, by the WF
	//					  MAP				TEAM		Location									ROTATION			StartDead	Price	TurretType
	AddDefensiveStructure("CNC-Islands",	TEAM_GDI,	vect(9563.457031,10765.051758,-171.459473), rot(0,-32672,0), 	true, 		1500,	0);
	AddDefensiveStructure("CNC-Islands",	TEAM_GDI,	vect(15270.881836,8603.498047,-265.831451),	rot(0,-93408,0), 	true, 		1500,	0);
	
	// Islands Nod Infrantry Path
	AddDefensiveStructure("CNC-Islands",	TEAM_NOD,	vect(9535.521484,3132.285889,-136.438507),	rot(0,2496,0),		true,		1500,	0);
	
	//Islands Nod Turret
	AddDefensiveStructure("CNC-Islands",	TEAM_NOD,	vect(8935.323242,2062.293457,-187.514847),	rot(0,-29632,0),	true,		1500,	1);

	// Add the defence turrets that are already on the existing map
	foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Rx_Defence', xDefenceTurret)
	{
		if ( Rx_Defence_GuardTower(xDefenceTurret) != None || Rx_Defence_GuardTower_Nod(xDefenceTurret) != None )
		{
			`log("Found a defence turret in-map at " $ xDefenceTurret.Location $ " - We will be spawning our own");
			AddDefensiveStructure(CurrentMapName, xDefenceTurret.TeamID, xDefenceTurret.Location, xDefenceTurret.Rotation, false, 1500, 0);
			xDefenceTurret.Destroy();
		}
		
		if ( Rx_Defence_Turret(xDefenceTurret) != None )
		{
			`log("Found a defence turret in-map at " $ xDefenceTurret.Location $ " - We will be spawning our own");
			AddDefensiveStructure(CurrentMapName, xDefenceTurret.TeamID, xDefenceTurret.Location, xDefenceTurret.Rotation, false, 1500, 1);
			xDefenceTurret.Destroy();
		}
	}
	
	SpawnDefensiveStructures();
}

function AddDefensiveStructure(string MapName, byte TheTeam, Vector TheLocation, Rotator TheRotation, bool bStartDead = false, int PurchasePrice = 1500, byte TurretType = 0)
{
	local DefencePositionStruct DefenceStructure;
	
	DefenceStructure.MapName = MapName;
	DefenceStructure.Team = TheTeam;
	DefenceStructure.Location = TheLocation;
	DefenceStructure.Rotation = TheRotation;
	DefenceStructure.bStartDead = bStartDead;
	DefenceStructure.PurchasePrice = PurchasePrice;
	DefenceStructure.TurretType = TurretType;
	
	DefenceStructures.AddItem(DefenceStructure);
	
	LogInternal ( "[AGN-DefenceStructures] Successfully added DefenceStructure: MAP: " $ MapName $ " Team: " $ TheTeam $ " Location: " $ string(TheLocation) $ " Rotation: " $ string(TheRotation) $ " TotalStructs: " $ string(DefenceStructures.Length) );
}

function array<DefencePositionStruct> FindDefenceStructuresForMap(byte TeamID)
{
	local array<DefencePositionStruct> _defStruct;
	local DefencePositionStruct _thisStruct;
	
	foreach DefenceStructures(_thisStruct)
	{
		if ( _thisStruct.MapName == CurrentMapName && _thisStruct.Team == TeamID )
			_defStruct.AddItem(_thisStruct);
	}
	
	return _defStruct;
}

function SpawnDefensiveStructures()
{
	local array<DefencePositionStruct> _defStructGDI;
	local array<DefencePositionStruct> _defStructNod;
	
	local DefencePositionStruct _thisStruct;
	
	local AGN_Rebuildable_Defence_Tower _thisGDITower;
	local AGN_Rebuildable_Defence_TowerNod _thisNodTower;
	local AGN_Rebuildable_Defence_Turret _thisTurret;
	
	_defStructGDI = FindDefenceStructuresForMap(TEAM_GDI);
	_defStructNod = FindDefenceStructuresForMap(TEAM_NOD);
	
	// Spawn all GDI Structures
	foreach _defStructGDI(_thisStruct)
	{
		_thisGDITower = Spawn(class'AGN_Rebuildable_Defence_Tower',,, _thisStruct.Location, _thisStruct.Rotation);
		_thisGDITower.InitializeDefence();
		_thisGDITower.SetPurchasePrice(_thisStruct.PurchasePrice);
		if ( _thisStruct.bStartDead )
			_thisGDITower.DeactivateStructure();
	}
	
	// Spawn all Nod Structures
	foreach _defStructNod(_thisStruct)
	{
		// Nod have both Turrets, and a special Tower
		if ( _thisStruct.TurretType == 0 )
		{
			_thisNodTower = Spawn(class'AGN_Rebuildable_Defence_TowerNod',,, _thisStruct.Location, _thisStruct.Rotation);
			_thisNodTower.InitializeDefence();
			_thisNodTower.SetPurchasePrice(_thisStruct.PurchasePrice);
			if ( _thisStruct.bStartDead )
				_thisNodTower.DeactivateStructure();
		}
		else
		{
			_thisTurret = Spawn(class'AGN_Rebuildable_Defence_Turret',,, _thisStruct.Location, _thisStruct.Rotation);
			_thisTurret.InitializeDefence();
			_thisTurret.SetPurchasePrice(_thisStruct.PurchasePrice);
			if ( _thisStruct.bStartDead )
				_thisTurret.DeactivateStructure();
		}
	}
}