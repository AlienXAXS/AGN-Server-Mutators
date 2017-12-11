class AGN_Veh_Mutator extends Rx_Mutator;

function OnInitMutator(string options, out string errorMessage)
{
	// Updates the Purchase System and VehicleManager
	setTimer(0.5f, false, 'ChangePurchaseSystem');
}

function OnClassReplacement(Actor Other)
{
	if (Other.isA('Rx_VehicleManager') && !Other.isA('AGN_Veh_VehicleManager')) {
		Other.destroy();
		`log("[AGN] Destroying Rx_VehicleManager");
	}
}

function OnMutate(string MutateString, PlayerController sender)
{
	
}

function bool ChangePurchaseSystem()
{

	Rx_Game(WorldInfo.Game).PurchaseSystem.Destroy();
	Rx_Game(WorldInfo.Game).PurchaseSystem = spawn(class'AGN_Veh_PurchaseSystem',self,'PurchaseSystem',Location,Rotation);
	Rx_Game(WorldInfo.Game).VehicleManager = spawn(class'AGN_Veh_VehicleManager',self,'VehicleManager',Location,Rotation);
	Rx_Game(WorldInfo.Game).VehicleManager.Initialize(Rx_Game(WorldInfo.Game), Rx_Game(WorldInfo.Game).Teams[TEAM_GDI], Rx_Game(WorldInfo.Game).Teams[TEAM_NOD]);
	Rx_Game(WorldInfo.Game).VehicleManager.MessageClass = class'AGN_Veh_Message_VehicleProduced';
	Rx_Game(WorldInfo.Game).PurchaseSystem.SetVehicleManager(Rx_Game(WorldInfo.Game).VehicleManager);
	return true;
}