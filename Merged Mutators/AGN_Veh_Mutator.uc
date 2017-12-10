class AGN_Veh_Mutator extends Rx_Mutator;

function OnInitMutator(string options, out string errorMessage)
{

	if (Rx_Game(WorldInfo.Game) != None)
	{
		LogInternal ( "~~~~~~~~ [AGN] Rx_Game PlayerControllerClass OVERWRITE" );
		Rx_Game(WorldInfo.Game).PlayerControllerClass = class'AGN_Veh_Controller';
	}
	
	if ( AGN_Game(WorldInfo.Game) != None)
	{
		LogInternal ( "~~~~~~~~ [AGN] AGN_Game PlayerControllerClass OVERWRITE" );
		AGN_Game(WorldInfo.Game).PlayerControllerClass = class'AGN_Veh_Controller';
	}

	// Updates the Purchase System and VehicleManager
	setTimer(0.5f, false, 'ChangePurchaseSystem');
}

function OnClassReplacement(Actor Other)
{
	if (other.isA('Rx_VehicleManager') && !other.isA('nBab_VehicleManager')) {
		other.destroy();
	}
}

function OnMutate(string MutateString, PlayerController sender)
{
	
}


simulated function bool ChangePurchaseSystem()
{
	Rx_Game(WorldInfo.Game).PurchaseSystem.Destroy();
	Rx_Game(WorldInfo.Game).PurchaseSystem = spawn(class'AGN_Veh_PurchaseSystem',self,'PurchaseSystem',Location,Rotation);
	Rx_Game(WorldInfo.Game).VehicleManager = spawn(class'AGN_Veh_VehicleManager',self,'VehicleManager',Location,Rotation);
	Rx_Game(WorldInfo.Game).VehicleManager.Initialize(Rx_Game(WorldInfo.Game), Rx_Game(WorldInfo.Game).Teams[TEAM_GDI], Rx_Game(WorldInfo.Game).Teams[TEAM_NOD]);
	Rx_Game(WorldInfo.Game).VehicleManager.MessageClass = class'AGN_Veh_Message_VehicleProduced';
	//Rx_Game(WorldInfo.Game).VehicleManager.SpawnInitialHarvesters();
	Rx_Game(WorldInfo.Game).PurchaseSystem.SetVehicleManager(Rx_Game(WorldInfo.Game).VehicleManager);
	
	return true;
}