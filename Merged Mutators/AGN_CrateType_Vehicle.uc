/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_CrateType_Vehicle extends Rx_CrateType 
	config(AGN_Crates);

var transient Rx_Vehicle GivenVehicle;
var config float ProbabilityIncreaseWhenVehicleProductionDestroyed;

function string GetPickupMessage()
{
	return Repl(PickupMessage, "`vehname`", GivenVehicle.GetHumanReadableName(), false);
}

function string GetGameLogMessage(Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	return "GAME" `s "Crate;" `s "vehicle" `s GivenVehicle.class.name `s "by" `s `PlayerLog(RecipientPRI);
}

function float GetProbabilityWeight(Rx_Pawn Recipient, Rx_CratePickup CratePickup)
{			
	local Rx_Building building;
	local float Probability;

	if (CratePickup.bNoVehicleSpawn)
		return 0;
	else
	{
		Probability = Super.GetProbabilityWeight(Recipient,CratePickup);

		ForEach CratePickup.AllActors(class'Rx_Building',building)
		{
			if((Recipient.GetTeamNum() == TEAM_GDI && Rx_Building_GDI_VehicleFactory(building) != none  && Rx_Building_GDI_VehicleFactory(building).IsDestroyed()) || 
				(Recipient.GetTeamNum() == TEAM_NOD && Rx_Building_Nod_VehicleFactory(building) != none  && Rx_Building_Nod_VehicleFactory(building).IsDestroyed()))
			{
				Probability += ProbabilityIncreaseWhenVehicleProductionDestroyed;
			}
		}

		return Probability;
	}
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	local int randomTeam, tmpInt2;
	local Vector tmpSpawnPoint;
	local bool isVehicleOkay;
	local Class selectedRandomVehicle;

	tmpSpawnPoint = CratePickup.Location + vector(CratePickup.Rotation)*450;
	tmpSpawnPoint.Z += 200;
	randomTeam = Rand(2);

	while (!isVehicleOkay)
	{
		if ( randomTeam == TEAM_GDI )
		{
			tmpInt2 = Rand(class'Rx_PurchaseSystem'.default.GDIVehicleClasses.Length);
			selectedRandomVehicle = class'Rx_PurchaseSystem'.default.GDIVehicleClasses[tmpInt2];
		}
		else
		{
			tmpInt2 = Rand(class'Rx_PurchaseSystem'.default.NodVehicleClasses.Length);
			selectedRandomVehicle = class'Rx_PurchaseSystem'.default.NodVehicleClasses[tmpInt2];
		}
		
		if (!Rx_MapInfo(CratePickup.WorldInfo.GetMapInfo()).bAircraftDisabled)
			isVehicleOkay = true; // If aircraft are not disabled, then the vehicle is going to be okay
		else
			if ( !ClassIsChildOf(selectedRandomVehicle, Class'Rx_Vehicle_Air') )
				isVehicleOkay = true;
	}
	
	GivenVehicle = CratePickup.Spawn((randomTeam == TEAM_GDI ?
		class'Rx_PurchaseSystem'.default.GDIVehicleClasses[tmpInt2] : 
		class'Rx_PurchaseSystem'.default.NodVehicleClasses[tmpInt2]),,, tmpSpawnPoint, CratePickup.Rotation,,true);
	
	GivenVehicle.DropToGround();
	if (GivenVehicle.Mesh != none)
		GivenVehicle.Mesh.WakeRigidBody();

	RecipientPRI.SetVehicleIsFromCrate(true);
}

DefaultProperties
{
	BroadcastMessageIndex = 6
	PickupSound = SoundCue'Rx_Pickups.Sounds.SC_Crate_VehicleDrop'
}

