class AGN_Veh_PurchaseSystem extends Rx_PurchaseSystem
	config(AGN_Prices);

// Maybe fix for UDKCrash?
// Turns out yes -- AlienX
var config int                          GDIInfantryPricesAGN[15];
var config int                          NodInfantryPricesAGN[15];
var config int                          GDIVehiclePricesAGN[7];
var config int                          NodVehiclePricesAGN[8];

/*
	Crash, among other things related to:
	Failed to find function GetClassPrices in AGN_Veh_PurchaseSystem CNC-Islands.TheWorld:PersistentLevel.AGN_Veh_PurchaseSystem_0
	
	Seems extending this class from Rx_PurchaseSystem works, however calling functions inside it doesnt work from other extended classes, re-writing the functions here
	fixes this problem, but it does cause a larger file... but whatever. -- AlienX
*/

simulated function PostBeginPlay()
{
	local byte i;
	
	for ( i=0; i<15; i++)
	{
		`log("GDIInfantryPricesAGN["$i$"] = "$GDIInfantryPricesAGN[i]);
	}
	
	for ( i=0; i<15; i++)
	{
		`log("NodInfantryPricesAGN["$i$"] = "$NodInfantryPricesAGN[i]);
	}
	
	for ( i=0; i<=7; i++)
	{
		`log("GDIVehiclePricesAGN["$i$"] = "$GDIVehiclePricesAGN[i]);
	}
	
	for ( i=0; i<=8; i++)
	{
		`log("NodVehiclePricesAGN["$i$"] = "$NodVehiclePricesAGN[i]);
	}
}

simulated function int GetClassPrices(byte teamID, int charid)
{
	local float Multiplier;
	local int price;
	Multiplier = 1;
	
	if (PowerPlants[teamID] != None && PowerPlants[teamID].IsDestroyed()) 
	{
		Multiplier = 1.5; // if powerplant is dead then everything costs 2 times as much
	}

	if(AreHighTierPayClassesDisabled(TeamID))
		Multiplier *= 2.0;

	if (teamID == TEAM_GDI)
	{
		price = GDIInfantryPricesAGN[charid] * Multiplier;
		//`log("GetClassPrices Team:" $ teamID $ " charID: " $ charid $ " Price: " $ price);
		return price;
	} 
	else
	{
		price = NodInfantryPricesAGN[charid] * Multiplier;
		//`log("GetClassPrices Team:" $ teamID $ " charID: " $ charid $ " Price: " $ price);
		return price;
	}
}

simulated function int GetVehiclePrices(byte teamID, int VehicleID, bool bViaAirdrop)
{
	local float Multiplier;
	local int price;
	Multiplier = 1.0;
	
	if (PowerPlants[teamID] != None && PowerPlants[teamID].IsDestroyed()) 
	{
		Multiplier = 1.5; // if powerplant is dead then everything costs [REDACTED] 1 and a half times as much
	}
	
	if(bViaAirdrop)
		Multiplier *= 2.0;

	if (teamID == TEAM_GDI)
	{
		if (VehicleID == 5)
			return 1000 * Multiplier;
		else if (VehicleID == 6)
		{
			if(bViaAirdrop)
				return 1500;
			else
				return 1000;
		}
		else if (VehicleID == 7)
			return 1500 * Multiplier;
		else if (VehicleID == 8)
			return 1000 * Multiplier;
		else
		{
			price = GDIVehiclePricesAGN[VehicleID] * Multiplier;
			`log("GetVehiclePrices Team:" $ teamID $ " vehID: " $ VehicleID $ " Price: " $ price);
			return price;
		}
	}
	else
	{
		if (VehicleID == 6)
		{
			if(bViaAirdrop)
				return 1200;
			else
				return 800;
		}
		else if (VehicleID == 7)
			return 800 * Multiplier;
		else if (VehicleID == 8)
			return 1200 * Multiplier;
		else
		{
			price = NodVehiclePricesAGN[VehicleID] * Multiplier;
			//`log("GetVehiclePrices Team:" $ teamID $ " vehID: " $ VehicleID $ " Price: " $ price);
			return price;
		}
	}
}

DefaultProperties
{
	GDIVehicleClasses[0]   = class'AGN_Mut_AlienXSystem.AGN_Vehicle_Humvee'
	GDIVehicleClasses[1]   = class'AGN_Mut_AlienXSystem.AGN_Vehicle_APC_GDI'
	GDIVehicleClasses[2]   = class'AGN_Mut_AlienXSystem.AGN_Vehicle_MRLS'
	GDIVehicleClasses[3]   = class'AGN_Mut_AlienXSystem.AGN_Vehicle_MediumTank'
	GDIVehicleClasses[4]   = class'AGN_Mut_AlienXSystem.AGN_Vehicle_MammothTank'
	GDIVehicleClasses[5]   = class'AGN_Mut_AlienXSystem.AGN_Vehicle_HoverMRLS'
	GDIVehicleClasses[6]   = class'AGN_Mut_AlienXSystem.AGN_Vehicle_Wolverine'
	GDIVehicleClasses[7]   = class'AGN_Mut_AlienXSystem.AGN_Vehicle_Titan'

	NodVehicleClasses[0]   = class'AGN_Mut_AlienXSystem.AGN_Vehicle_Buggy'
	NodVehicleClasses[1]   = class'AGN_Mut_AlienXSystem.AGN_Vehicle_APC_Nod'
	NodVehicleClasses[2]   = class'AGN_Mut_AlienXSystem.AGN_Vehicle_Artillery'
	NodVehicleClasses[3]   = class'AGN_Mut_AlienXSystem.AGN_Vehicle_FlameTank'
	NodVehicleClasses[4]   = class'AGN_Mut_AlienXSystem.AGN_Vehicle_LightTank'
	NodVehicleClasses[5]   = class'AGN_Mut_AlienXSystem.AGN_Vehicle_StealthTank'
	NodVehicleClasses[6]   = class'AGN_Mut_AlienXSystem.AGN_Vehicle_ReconBike'
	NodVehicleClasses[7]   = class'AGN_Mut_AlienXSystem.AGN_TS_Vehicle_Buggy'
	NodVehicleClasses[8]   = class'AGN_Mut_AlienXSystem.AGN_Vehicle_TickTank'
}