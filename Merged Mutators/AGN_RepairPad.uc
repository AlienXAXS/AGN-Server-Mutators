class AGN_RepairPad extends Rx_Building;

var int RepairDistance, RepairRate, CostPerRepair, RepairRatePowerOffline, CostPerRepairRefinaryOffline;
var bool IgnoreHiddenCollidingActors;
var Rx_Building_GDI_PowerFactory GDIPowerFactory;
var Rx_Building_GDI_MoneyFactory GDIMoneyFactory;
var Rx_Building_Nod_PowerFactory NodPowerFactory;
var Rx_Building_Nod_MoneyFactory NodMoneyFactory;


function StartRepairPadVisuals()
{
	Spawn(class'AGN_Mut_AlienXSystem.AGN_RepairPad_Emitter',,, Location, Rotation);
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
}

// Repair Pads v3.5 - NEW RepairPad Tick! (Much Much faster and SFPS friendly than AllActors as this uses the collision hash)
function RepairPadTick()
{
	local UTVehicle thisVehicle;
	local int calculatedRepairRate;
	local int calculatedRepairCost;
	local Rx_PRI playerRepInfo;
	
	// Is this repairpad dead?
	if ( IsDestroyed() )
	{
		ClearTimer('RepairPadTick'); // Stop the timer
		return;
	}
		
	ForEach VisibleCollidingActors(class'UTVehicle', thisVehicle, RepairDistance, Location, IgnoreHiddenCollidingActors)
	{
		if ( IsValidVehicle(thisVehicle) == false )
			continue;
	
		calculatedRepairRate = CalculateRepairRate();
		calculatedRepairCost = CalculateCostPerRepair();
		playerRepInfo = Rx_PRI(thisVehicle.PlayerReplicationInfo);
		
		if ( thisVehicle.Health < thisVehicle.HealthMax )
		{
			if ( playerRepInfo.GetCredits() > calculatedRepairCost )
			{
				playerRepInfo.RemoveCredits(calculatedRepairCost);
				thisVehicle.HealDamage(calculatedRepairRate, thisVehicle.Controller, class'Rx_DmgType_Pistol');

				StartRepairPadVisuals();
			} else {
				thisVehicle.Driver.ClientMessage("Unable to repair: Not enough credits");
			}
		}
	}
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
	RepairDistance = 350
	RepairRate = 25
	RepairRatePowerOffline = 15
	CostPerRepair = 4
	CostPerRepairRefinaryOffline = 2
	IgnoreHiddenCollidingActors = true
}