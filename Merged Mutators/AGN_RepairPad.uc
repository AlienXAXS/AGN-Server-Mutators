/*
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 *
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 *
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 *
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_RepairPad extends Rx_Building implements (RxIfc_TargetedDescription);

var int RepairDistance, RepairRate, CostPerRepair, RepairRatePowerOffline, CostPerRepairRefinaryOffline;
var bool IgnoreHiddenCollidingActors;
var Rx_Building_GDI_PowerFactory GDIPowerFactory;
var Rx_Building_GDI_MoneyFactory GDIMoneyFactory;
var Rx_Building_Nod_PowerFactory NodPowerFactory;
var Rx_Building_Nod_MoneyFactory NodMoneyFactory;
var ParticleSystemComponent xEffect;

var repnotify bool bStartEmitter;

replication
{
	if (bNetDirty && Role<=Role_Authority)
		bStartEmitter;
}

simulated event ReplicatedEvent(name VarName)
{
	if ( VarName == 'bStartEmitter' )
	{
		if ( bStartEmitter )
			StartRepairPadVisuals();
		else
			StopRepairPadVisuals();
	}
}

simulated function string GetTargetedDescription(PlayerController PlayerPerspective)
{
	if (GetHealth() > 0 && Rx_Building_Team_Internals(BuildingInternals).bNoPower)
		return "Low Efficiency";
	return "";
}

function StartRepairPadVisualsServer()
{
	bStartEmitter = true;
}

function StopRepairPadVisualsServer()
{
	bStartEmitter = false;
}

simulated function StartRepairPadVisuals()
{
	if ( xEffect == None )
		xEffect = class'WorldInfo'.static.GetWorldInfo().MyEmitterPool.SpawnEmitter(ParticleSystem'AGN_FX_Package.Particles.Explosions.P_RepairField', Location, Rotation);
}

simulated function StopRepairPadVisuals()
{
	if ( xEffect != None )
	{
		xEffect.SetActive(false);
		class'WorldInfo'.static.GetWorldInfo().MyEmitterPool.OnParticleSystemFinished(xEffect);
		class'WorldInfo'.static.GetWorldInfo().MyEmitterPool.ClearPoolComponents();
		xEffect = None;
	}
}

// Start our timer
function PostBeginPlay()
{
	local Rx_Building building;

	// Call our Super, otherwise our Repair Pad will never get init
	Super.PostBeginPlay();

	// Get our buildings so we dont have to loop around them each time like we did before.
	ForEach Rx_Game(`WorldInfoObject.Game).AllActors(class'Rx_Building',building)
	{
		if ( Rx_Building_GDI_PowerFactory(building) != None )
			GDIPowerFactory = Rx_Building_GDI_PowerFactory(building);
		if ( Rx_Building_GDI_MoneyFactory(building) != None )
			GDIMoneyFactory = Rx_Building_GDI_MoneyFactory(building);
		if ( Rx_Building_Nod_MoneyFactory(building) != None )
			NodMoneyFactory = Rx_Building_Nod_MoneyFactory(building);
		if ( Rx_Building_Nod_PowerFactory(building) != None )
			NodPowerFactory = Rx_Building_Nod_PowerFactory(building);
	}

	`log("[AGN-RepairPad] GDI POWER: " $ GDIPowerFactory == None ? "NOT_FOUND" : "FOUND" $ "  GDI REFINARY: " $ GDIMoneyFactory == None ? "NOT FOUND" : "FOUND" );
	`log("[AGN-RepairPad] Nod POWER: " $ NodPowerFactory == None ? "NOT_FOUND" : "FOUND" $ "  Nod REFINARY: " $ NodMoneyFactory == None ? "NOT FOUND" : "FOUND" );

	// Start our repairpad tick
	SetTimer(1, true, 'RepairPadTick');
	SetTimer(5, true, 'RepairPadSelfDestruct');
}

function RepairPadSelfDestruct()
{
	local Rx_Building building;
	local AGN_Weapon_CrateNuke BeaconNuke;
	local AGN_Weapon_CrateIon BeaconIon;
	local int xCount;
	local vector loc;

	// Go around all buildings, check the team, if it's dead and if it's not a repair pad, counter++
	ForEach Rx_Game(`WorldInfoObject.Game).AllActors(class'Rx_Building',building)
		if ( building.GetTeamNum() == TeamID && !building.isDestroyed() && AGN_Repairpad_Nod(building) == None && AGN_RepairPad_GDI(building) == None )
			xCount++;

	if ( xCount == 0 )
	{
		loc = location;
		loc.z += 100;
		// Destroy our own Repair pad to win the game for the enemy team.
		if ( TeamID == TEAM_GDI )
		{
			// Spawn a Nuke on the repair pad
			BeaconNuke = Spawn(class'AGN_Weapon_CrateNuke',,,loc, Rotation);
			BeaconNuke.TeamNum = TEAM_NOD;
		} else {
			// Spawn an Orbital Strike on the repair pad
			BeaconIon = Spawn(class'AGN_Weapon_CrateIon',,,loc, Rotation);
			BeaconIon.TeamNum = TEAM_GDI;
		}
		SetTimer(5, false, 'KillBuilding');
		ClearTimer('RepairPadSelfDestruct');
	}
}

function KillBuilding()
{
	local int dmgLodLevel;

	if ( isDestroyed() )
		return;

	Rx_Building_Team_Internals(self.BuildingInternals).Armor = 0;
	Rx_Building_Team_Internals(self.BuildingInternals).Health = 0;
	Rx_Building_Team_Internals(self.BuildingInternals).bDestroyed = true;
	Rx_Building_Team_Internals(self.BuildingInternals).PlayDestructionAnimation();
	Rx_Game(WorldInfo.Game).CheckBuildingsDestroyed(Rx_Building_Team_Internals(self.BuildingInternals).BuildingVisuals);

	dmgLodLevel = Rx_Building_Team_Internals(self.BuildingInternals).GetBuildingHealthLod();
	if(dmgLodLevel != Rx_Building_Team_Internals(self.BuildingInternals).DamageLodLevel)
	{
		Rx_Building_Team_Internals(self.BuildingInternals).DamageLodLevel = dmgLodLevel;
		Rx_Building_Team_Internals(self.BuildingInternals).ChangeDamageLodLevel(dmgLodLevel);
	}
}

// Repair Pads v3.5 - NEW RepairPad Tick! (Much Much faster and SFPS friendly than AllActors as this uses the collision hash)
function RepairPadTick()
{
	local UTVehicle thisVehicle;
	local int calculatedRepairRate;
	local int calculatedRepairCost;
	local Rx_PRI playerRepInfo;
	local int count;
	local vector thisLocation;

	// Is this repairpad dead?
	if ( IsDestroyed() )
	{
		`log("[AGN-RepairPad] Repair Pad " $ string(self) $ " is dead, tick timer is about to be killed");
		ClearTimer('RepairPadTick'); // Stop the timer
		return;
	}
	
	thisLocation = Location;
	thisLocation.Z += 50;

	ForEach VisibleCollidingActors(class'UTVehicle', thisVehicle, RepairDistance, thisLocation, IgnoreHiddenCollidingActors)
	{
		if ( IsValidVehicle(thisVehicle) == false )
		{
			`log("[AGN-RepairPad] Repair Pad " $ string(self) $ " : Found an invalid vehicle " $ string(thisVehicle) $ ", more details below if possible");
		
			if ( thisVehicle.Driver != None )
				`log("[AGN-RepairPad] Repair Pad " $ string(self) $ " : Driver Object: " $ string(thisVehicle.Driver) $ " team:" $ string(thisVehicle.Driver.GetTeamNum()) $ " expected " $ string(TeamID));
			
			continue;
		}

		calculatedRepairRate = CalculateRepairRate();
		calculatedRepairCost = CalculateCostPerRepair();
		playerRepInfo = Rx_PRI(thisVehicle.PlayerReplicationInfo);

		if ( thisVehicle.Health < thisVehicle.HealthMax )
		{
			if ( playerRepInfo.GetCredits() > calculatedRepairCost )
			{
				playerRepInfo.RemoveCredits(calculatedRepairCost);
				thisVehicle.HealDamage(calculatedRepairRate, thisVehicle.Controller, class'Rx_DmgType_Pistol');

				if(`WorldInfoObject.NetMode == NM_DedicatedServer)
					StartRepairPadVisualsServer();
				else
					StartRepairPadVisuals();
				count++;
			} else {
				thisVehicle.Driver.ClientMessage("Unable to repair: Not enough credits");
			}
		}
	}

	if ( count == 0 )
		if(`WorldInfoObject.NetMode == NM_DedicatedServer)
			StopRepairPadVisualsServer();
		else
			StopRepairPadVisuals();
}

function bool IsValidVehicle(UTVehicle thisVehicle)
{
	if ( thisVehicle.Driver != None )
		if ( Rx_Pawn(thisVehicle.Driver) != None || Rx_PRI(thisVehicle.PlayerReplicationInfo) != None )
			if ( thisVehicle.Driver.GetTeamNum() == TeamID )
				return true;

	// Invalid vehicle on pad
	return false;
}

// Calculates the repair rate based on the current building status
function int CalculateRepairRate()
{
	if ( TeamID == TEAM_GDI )
		if ( GDIPowerFactory != none && GDIPowerFactory.IsDestroyed() )
			return RepairRatePowerOffline;
	else
		if ( NodPowerFactory != none && NodPowerFactory.IsDestroyed() )
			return RepairRatePowerOffline;

	return RepairRate;
}

function int CalculateCostPerRepair()
{
	if ( TeamID == TEAM_GDI )
		if ( GDIMoneyFactory != none && GDIMoneyFactory.IsDestroyed() )
			return CostPerRepairRefinaryOffline;
	else
		if ( NodMoneyFactory != none && NodMoneyFactory.IsDestroyed() )
			return CostPerRepairRefinaryOffline;

	return CostPerRepair;
}

function SendMessageToAllPlayers(string message)
{
	local Controller c;
	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
	{
		if ( c != None && Rx_Controller(c) != None )
			Rx_Controller(c).CTextMessage("[AGN] " $ message,'LightGreen',50);
	}
}

DefaultProperties
{
	// The distance to check for applicable vehicles to be repaired on each pad
	RepairDistance = 350

	// How much HP to repair the Vehicle per second when power is online
	RepairRate = 25

	// How much HP to repair the Vehicle per second when power is offline
	RepairRatePowerOffline = 15

	// How much to charge the player per second when power is online
	CostPerRepair = 4

	// How much to charge the player per second when power is offline
	CostPerRepairRefinaryOffline = 2

	// Ignore this, do not change
	IgnoreHiddenCollidingActors = true
}
