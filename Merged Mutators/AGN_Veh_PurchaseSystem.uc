/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_Veh_PurchaseSystem extends Rx_PurchaseSystem;

// Maybe fix for UDKCrash?
// Turns out yes -- AlienX
var int GDIInfantryPricesAGN[15];
var int GDIVehiclePricesAGN[7];
var int GDIWeaponPricesAGN[7];
var int GDIItemPricesAGN[8];
var int NodInfantryPricesAGN[15];
var int NodVehiclePricesAGN[8];
var int NodWeaponPricesAGN[7];
var int NodItemPricesAGN[8];

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
	
	Super.PostBeginPlay();
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

simulated function int GetItemPrices(byte teamID, int charid)
{
	if (teamID == TEAM_GDI)
	{
		return GDIItemPricesAGN[charid];
	} 
	else
	{
		return NodItemPricesAGN[charid];
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
			return 1300 * Multiplier;
		else if (VehicleID == 6)
		{
			if(bViaAirdrop)
				return 1250;
			else
				return 700;
		}
		else if (VehicleID == 7)
			return 1500 * Multiplier;
		else if (VehicleID == 8)
			return 1000 * Multiplier;
		else
		{
			price = GDIVehiclePricesAGN[VehicleID] * Multiplier;
			//`log("GetVehiclePrices Team:" $ teamID $ " vehID: " $ VehicleID $ " Price: " $ price);
			return price;
		}
	}
	else
	{
		if (VehicleID == 6)
		{
			if(bViaAirdrop)
				return 1150;
			else
				return 700;
		}
		else if (VehicleID == 7)
			return 600 * Multiplier;
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
	
	NodInfantryClasses[0]  = class'AGN_FamilyInfo_Nod_Soldier'
	NodInfantryClasses[1]  = class'AGN_FamilyInfo_Nod_Shotgunner'
	NodInfantryClasses[2]  = class'AGN_FamilyInfo_Nod_FlameTrooper'
	NodInfantryClasses[3]  = class'AGN_FamilyInfo_Nod_Marksman'
	NodInfantryClasses[4]  = class'AGN_FamilyInfo_Nod_Engineer'
	NodInfantryClasses[5]  = class'AGN_FamilyInfo_Nod_Officer'
	NodInfantryClasses[6]  = class'AGN_FamilyInfo_Nod_RocketSoldier'	
	NodInfantryClasses[7]  = class'AGN_FamilyInfo_Nod_ChemicalTrooper'
	NodInfantryClasses[8]  = class'AGN_FamilyInfo_Nod_blackhandsniper'
	NodInfantryClasses[9]  = class'AGN_FamilyInfo_Nod_Stealthblackhand'
	NodInfantryClasses[10] = class'AGN_FamilyInfo_Nod_LaserChainGunner'
	NodInfantryClasses[11] = class'AGN_FamilyInfo_Nod_Sakura'		
	NodInfantryClasses[12] = class'AGN_FamilyInfo_Nod_Raveshaw'
	NodInfantryClasses[13] = class'AGN_FamilyInfo_Nod_Mendoza'
	NodInfantryClasses[14] = class'AGN_FamilyInfo_Nod_Technician'
	
	GDIInfantryClasses[0]  = class'AGN_FamilyInfo_GDI_Soldier'	
	GDIInfantryClasses[1]  = class'AGN_FamilyInfo_GDI_Shotgunner'
	GDIInfantryClasses[2]  = class'AGN_FamilyInfo_GDI_Grenadier'
	GDIInfantryClasses[3]  = class'AGN_FamilyInfo_GDI_Marksman'
	GDIInfantryClasses[4]  = class'AGN_FamilyInfo_GDI_Engineer'
	GDIInfantryClasses[5]  = class'AGN_FamilyInfo_GDI_Officer'
	GDIInfantryClasses[6]  = class'AGN_FamilyInfo_GDI_RocketSoldier'
	GDIInfantryClasses[7]  = class'AGN_FamilyInfo_GDI_McFarland'
	GDIInfantryClasses[8]  = class'AGN_FamilyInfo_GDI_Deadeye'
	GDIInfantryClasses[9]  = class'AGN_FamilyInfo_GDI_Gunner'
	GDIInfantryClasses[10] = class'AGN_FamilyInfo_GDI_Patch'
	GDIInfantryClasses[11] = class'AGN_FamilyInfo_GDI_Havoc'
	GDIInfantryClasses[12] = class'AGN_FamilyInfo_GDI_Sydney'
	GDIInfantryClasses[13] = class'AGN_FamilyInfo_GDI_Mobius'
	GDIInfantryClasses[14] = class'AGN_FamilyInfo_GDI_Hotwire'

	GDIInfantryPricesAGN[0] = 0
	GDIInfantryPricesAGN[1] = 0
	GDIInfantryPricesAGN[2] = 0
	GDIInfantryPricesAGN[3] = 0
	GDIInfantryPricesAGN[4] = 0
	GDIInfantryPricesAGN[5] = 175
	GDIInfantryPricesAGN[6] = 225
	GDIInfantryPricesAGN[7] = 250
	GDIInfantryPricesAGN[8] = 500
	GDIInfantryPricesAGN[9] = 400
	GDIInfantryPricesAGN[10] = 450
	GDIInfantryPricesAGN[11] = 1000
	GDIInfantryPricesAGN[12] = 1000
	GDIInfantryPricesAGN[13] = 1000
	GDIInfantryPricesAGN[14] = 350

	NodInfantryPricesAGN[0] = 0
	NodInfantryPricesAGN[1] = 0
	NodInfantryPricesAGN[2] = 0
	NodInfantryPricesAGN[3] = 0
	NodInfantryPricesAGN[4] = 0
	NodInfantryPricesAGN[5] = 175
	NodInfantryPricesAGN[6] = 225
	NodInfantryPricesAGN[7] = 250
	NodInfantryPricesAGN[8] = 500
	NodInfantryPricesAGN[9] = 400
	NodInfantryPricesAGN[10] = 450
	NodInfantryPricesAGN[11] = 1000
	NodInfantryPricesAGN[12] = 1000
	NodInfantryPricesAGN[13] = 1000
	NodInfantryPricesAGN[14] = 350

	GDIVehiclePricesAGN[0] = 350
	GDIVehiclePricesAGN[1] = 500
	GDIVehiclePricesAGN[2] = 450
	GDIVehiclePricesAGN[3] = 800
	GDIVehiclePricesAGN[4] = 1500
	GDIVehiclePricesAGN[5] = 700
	GDIVehiclePricesAGN[6] = 900

	NodVehiclePricesAGN[0] = 300
	NodVehiclePricesAGN[1] = 500
	NodVehiclePricesAGN[2] = 450
	NodVehiclePricesAGN[3] = 800
	NodVehiclePricesAGN[4] = 600
	NodVehiclePricesAGN[5] = 900
	NodVehiclePricesAGN[6] = 700
	NodVehiclePricesAGN[7] = 900

	GDIItemPricesAGN[0] = 1000 
	GDIItemPricesAGN[1] = 800 
	GDIItemPricesAGN[2] = 0
	GDIItemPricesAGN[3] = 150 
	GDIItemPricesAGN[4] = 150 
	GDIItemPricesAGN[5] = 200 
	GDIItemPricesAGN[6] = 300 
	GDIItemPricesAGN[7] = 300 

	NodItemPricesAGN[0] = 1000 
	NodItemPricesAGN[1] = 800 
	NodItemPricesAGN[2] = 0 
	NodItemPricesAGN[3] = 150
	NodItemPricesAGN[4] = 150
	NodItemPricesAGN[5] = 200
	NodItemPricesAGN[6] = 300
	NodItemPricesAGN[7] = 300

	GDIWeaponPricesAGN[0] = 100
	GDIWeaponPricesAGN[1] = 250
	GDIWeaponPricesAGN[2] = 400
	GDIWeaponPricesAGN[3] = 400
	GDIWeaponPricesAGN[4] = 300
	GDIWeaponPricesAGN[5] = 250
	GDIWeaponPricesAGN[6] = 100

	NodWeaponPricesAGN[0] = 100
	NodWeaponPricesAGN[1] = 250
	NodWeaponPricesAGN[2] = 400
	NodWeaponPricesAGN[3] = 400
	NodWeaponPricesAGN[4] = 300
	NodWeaponPricesAGN[5] = 250
	NodWeaponPricesAGN[6] = 100
}

