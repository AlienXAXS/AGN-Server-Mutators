class AGN_Chinook_Airdrop extends Rx_Chinook_Airdrop;

simulated function class<Rx_Vehicle> GetVehicleClass()
{
	if (TeamNum == TEAM_GDI)
	{
		if (VehicleID == 10)
			return class<Rx_Game>(WorldInfo.GetGameClass()).default.VehicleManagerClass.default.GDIHarvesterClass;
		else
			//return class<Rx_Game>(WorldInfo.GetGameClass()).default.PurchaseSystemClass.default.GDIVehicleClasses[VehicleID];
			return Rx_Game(WorldInfo.Game).GetPurchaseSystem().default.GDIVehicleClasses[VehicleID];
	}
	else
	{
		if (VehicleID == 11)
			return class<Rx_Game>(WorldInfo.GetGameClass()).default.VehicleManagerClass.default.NodHarvesterClass;
		else
			//return class<Rx_Game>(WorldInfo.GetGameClass()).default.PurchaseSystemClass.default.NodVehicleClasses[VehicleID];
			return Rx_Game(WorldInfo.Game).GetPurchaseSystem().default.NodVehicleClasses[VehicleID];
	}
}