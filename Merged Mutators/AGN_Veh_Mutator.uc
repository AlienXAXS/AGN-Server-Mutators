/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


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

