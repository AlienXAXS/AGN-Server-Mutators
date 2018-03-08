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

var int NOD_TURRET;
var int NOD_GUARDTOWER;
var int GDI_GUARDTOWER;

function InitSystem()
{
	local string mapname;
	local Rx_Defence xDefenceTurret;
		
	mapname=string(WorldInfo.GetPackageName()); 			
	if(right(mapname, 6) ~= "_NIGHT") mapname = Left(mapname, Len(mapname)-6);   	
	if(right(mapname, 4) ~= "_DAY") mapname = Left(mapname, Len(mapname)-4);
	CurrentMapName = mapname;
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Islands
	///
	//GDI, by the WF + Tunnels
	AddDefensiveStructure("CNC-Islands",	TEAM_GDI,	vect(9563.457031,10765.051758,-171.459473), rot(0,-32672,0), 	true, 		750,	GDI_GUARDTOWER);
	AddDefensiveStructure("CNC-Islands",	TEAM_GDI,	vect(15270.881836,8603.498047,-265.831451),	rot(0,-93408,0), 	true, 		750,	GDI_GUARDTOWER);
	
	//Nod Infrantry Path
	AddDefensiveStructure("CNC-Islands",	TEAM_NOD,	vect(9535.521484,3132.285889,-136.438507),	rot(0,2496,0),		true,		750,	NOD_GUARDTOWER);
	
	//Islands Nod Turret
	AddDefensiveStructure("CNC-Islands",	TEAM_NOD,	vect(8935.323242,2062.293457,-187.514847),	rot(0,-29632,0),	true,		550,	NOD_TURRET);
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Under
	///
	// Nod GT by end of Strip
	AddDefensiveStructure("CNC-Under",		TEAM_NOD,	vect(4922.829102,-1268.094727,133.085495), 	rot(0,16288,0),		true,		750,	NOD_GUARDTOWER);

	// GDI GT by WF
	AddDefensiveStructure("CNC-Under",		TEAM_GDI,	vect(-3031.028809,-7673.423340,229.389114),	rot(0,32768,0), 	true, 		750,	GDI_GUARDTOWER);

	// GDI GT middle of base
	AddDefensiveStructure("CNC-Under",		TEAM_GDI,	vect(-1074.669800,-4904.338867,123.952759),	rot(0,32768,0), 	true, 		750,	GDI_GUARDTOWER);

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Field_X
	///
	//Nod GT by PP
	AddDefensiveStructure("CNC-Field_X",	TEAM_NOD,	vect(7634.499512,-3708.821289,266.901215),	rot(0,16384,0), 	true, 		750,	NOD_GUARDTOWER);
	
	//GDI by PP
	AddDefensiveStructure("CNC-Field_X",	TEAM_GDI,	vect(-2956.268311,7779.490234,204.547958),	rot(0,0,0), 		true, 		750,	GDI_GUARDTOWER);

	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Walls Flying
	///
	// GDI Left
	AddDefensiveStructure("CNC-Walls_Flying",	TEAM_GDI,	vect(-8671.990234,4034.258789,737.538513), rot(0,-16384,0), 	true, 		750,	GDI_GUARDTOWER);
	
	// GDI Right
	AddDefensiveStructure("CNC-Walls_Flying",	TEAM_GDI,	vect(-14383.990234,4034.258789,737.538513), rot(0,-16384,0),	true, 		750,	GDI_GUARDTOWER);
	
	// Nod Left
	AddDefensiveStructure("CNC-Walls_Flying",	TEAM_GDI,	vect(-14383.990234,-4541.740723,737.538513), rot(0,16384,0),	true, 		750,	NOD_GUARDTOWER);
	
	// Nod Right
	AddDefensiveStructure("CNC-Walls_Flying",	TEAM_GDI,	vect(-8671.990234,-4541.740723,737.538513), rot(0,-49152,0),	true, 		750,	NOD_GUARDTOWER);

	
	// Add the defence turrets that are already on the existing map
	foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Rx_Defence', xDefenceTurret)
	{
		if ( Rx_Defence_GuardTower(xDefenceTurret) != None || Rx_Defence_GuardTower_Nod(xDefenceTurret) != None )
		{
			`log("Found a defence turret in-map at " $ xDefenceTurret.Location $ " - We will be spawning our own");
			AddDefensiveStructure(CurrentMapName, xDefenceTurret.TeamID, xDefenceTurret.Location, xDefenceTurret.Rotation, false, 750, 0);
			xDefenceTurret.Destroy();
		}
		
		if ( Rx_Defence_Turret(xDefenceTurret) != None )
		{
			`log("Found a defence turret in-map at " $ xDefenceTurret.Location $ " - We will be spawning our own");
			AddDefensiveStructure(CurrentMapName, xDefenceTurret.TeamID, xDefenceTurret.Location, xDefenceTurret.Rotation, false, 550, 1);
			xDefenceTurret.Destroy();
		}
	}
}

function OnMatchStart()
{
	`log("=================================================================================");
	`log("=================              AGN TURRET SYSTEM              ===================");
	`log("=================================================================================");
	SpawnDefensiveStructures();
}

function AddDefensiveStructure(string MapName, byte TheTeam, Vector TheLocation, Rotator TheRotation, bool bStartDead = false, int PurchasePrice = 550, byte TurretType = 0)
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

function OnDefenceDestroyed(byte Team, int towerID)
{
	local array<DefencePositionStruct> _defStructGDI;
	local array<DefencePositionStruct> _defStructNod;
	
	if ( Team == TEAM_GDI )
	{
		_defStructGDI = FindDefenceStructuresForMap(TEAM_GDI);
		SpawnPurchaseableTurret(_defStructGDI[towerID], towerID);
	} else {
		_defStructNod = FindDefenceStructuresForMap(TEAM_NOD);
		SpawnPurchaseableTurret(_defStructNod[towerID], towerID);
	}
}

function SpawnPurchaseableTurret(DefencePositionStruct _thisTurret, int towerID)
{
	local AGN_Rebuildable_Defence_Tower_Destroyed _thisGDITower;
	local AGN_Rebuildable_Defence_TowerNod_Destroyed _thisNodTower;
	local AGN_Rebuildable_Defence_Turret_Destroyed _thisNodTurret;
	
	local vector HitLocation;
	
	HitLocation = _thisTurret.Location;// + vect(0,0,50);
	
	if ( _thisTurret.Team == TEAM_GDI )
	{
		_thisGDITower = Spawn(class'AGN_Rebuildable_Defence_Tower_Destroyed', , , HitLocation, _thisTurret.Rotation, , false);
		_thisGDITower.InitializeDefence(self, towerID);
		_thisGDITower.SetPurchasePrice(_thisTurret.PurchasePrice);
	} else {
		if ( _thisTurret.TurretType == NOD_GUARDTOWER )
		{
			_thisNodTower = Spawn(class'AGN_Rebuildable_Defence_TowerNod_Destroyed', , , HitLocation, _thisTurret.Rotation, , false);
			_thisNodTower.InitializeDefence(self, towerID);
			_thisNodTower.SetPurchasePrice(_thisTurret.PurchasePrice);
		} else {
			_thisNodTurret = Spawn(class'AGN_Rebuildable_Defence_Turret_Destroyed', , , HitLocation, _thisTurret.Rotation, , false);
			_thisNodTurret.InitializeDefence(self, towerID);
			_thisNodTurret.SetPurchasePrice(_thisTurret.PurchasePrice);
		}
	}
}

function CallInTowerAirDropFromTowerID(byte Team, int towerID)
{
	local array<DefencePositionStruct> _defStructGDI;
	local array<DefencePositionStruct> _defStructNod;
	
	if ( Team == TEAM_GDI )
	{
		_defStructGDI = FindDefenceStructuresForMap(TEAM_GDI);
		CallInTowerAirdropFromDataObject(_defStructGDI[towerID], towerID);
	} else {
		_defStructNod = FindDefenceStructuresForMap(TEAM_NOD);
		CallInTowerAirdropFromDataObject(_defStructNod[towerID], towerID);
	}
}

function CallInTowerAirdropFromDataObject(DefencePositionStruct thisTower, int towerID)
{
	local vector tempLocation;
	local AGN_Rebuildable_Defence_Airdrop AirdropingChinook;
	
	tempLocation = thisTower.Location;
	tempLocation.Z -= 350;
	
	AirdropingChinook = Spawn(class'AGN_Rebuildable_Defence_Airdrop', , , tempLocation, thisTower.Rotation, , false);
	//byte TeamID, AGN_Rebuildable_Defence_Handler OurHandler, vector thisLocation, rotator thisRotation, int OurHandlerID, int OurTurretType
	AirdropingChinook.Init(thisTower.Team, self, thisTower.Location, thisTower.Rotation, towerID, thisTower.TurretType);
}

function SpawnDefensiveStructures()
{
	local array<DefencePositionStruct> _defStructGDI;
	local array<DefencePositionStruct> _defStructNod;
	local DefencePositionStruct _thisStruct;
	local int counter;
	
	_defStructGDI = FindDefenceStructuresForMap(TEAM_GDI);
	_defStructNod = FindDefenceStructuresForMap(TEAM_NOD);
	
	counter = 0;
	// Spawn all GDI Structures
	foreach _defStructGDI(_thisStruct)
	{
		if ( _thisStruct.bStartDead )
		{
			`log("[AGN-Turret-System] Spawning a purchaseable turret of type " $ string(_thisStruct.TurretType) $ " for team " $ string(_thisStruct.Team) $ " at coords " $ string(_thisStruct.Location));
			SpawnPurchaseableTurret(_thisStruct, counter);
		} else {
			`log("[AGN-Turret-System] Calling in an airdrop for the tower type of " $ string(_thisStruct.TurretType) $ " for team " $ string(_thisStruct.Team) $ " at coords " $ string(_thisStruct.Location));
			CallInTowerAirdropFromDataObject(_thisStruct, counter);
		}
		counter++;
	}
	
	counter = 0;
	// Spawn all Nod Structures
	foreach _defStructNod(_thisStruct)
	{
		if ( _thisStruct.bStartDead )
		{
			`log("[AGN-Turret-System] Spawning a purchaseable turret of type " $ string(_thisStruct.TurretType) $ " for team " $ string(_thisStruct.Team) $ " at coords " $ string(_thisStruct.Location));
			SpawnPurchaseableTurret(_thisStruct, counter);
		} else {
			`log("[AGN-Turret-System] Calling in an airdrop for the tower type of " $ string(_thisStruct.TurretType) $ " for team " $ string(_thisStruct.Team) $ " at coords " $ string(_thisStruct.Location));
			CallInTowerAirdropFromDataObject(_thisStruct, counter);
		}
		counter++;
	}
}

defaultproperties
{
	NOD_TURRET = 1
	NOD_GUARDTOWER = 0
	GDI_GUARDTOWER = 0
}