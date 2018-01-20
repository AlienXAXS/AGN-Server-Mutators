/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_CrateType_RAVehicle extends AGN_CrateType
	config(AGN_Crates);

var transient Rx_Vehicle GivenVehicle;
var config float ProbabilityIncreaseWhenVehicleProductionDestroyed;
var array<class<Rx_Vehicle> > Vehicles;

function string GetPickupMessage()
{
	return Repl(PickupMessage, "`vehname`", GivenVehicle.GetHumanReadableName(), false);
}

function string GetGameLogMessage(Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	return "GAME" `s "Crate;" `s "ravehicle" `s GivenVehicle.class.name `s "by" `s `PlayerLog(RecipientPRI);
}

function float GetProbabilityWeight(Rx_Pawn Recipient, AGN_CratePickup CratePickup)
{			
	local Rx_Building building;
	local float Probability;

	if (CratePickup.bNoVehicleSpawn || Vehicles.Length == 0)
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
		LogInternal("RAVehicle GetProbabilityWeight returning " $ Probability);
		return Probability;
	}
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	local Vector tmpSpawnPoint;

	tmpSpawnPoint = CratePickup.Location + vector(CratePickup.Rotation)*450;
	tmpSpawnPoint.Z += 200;

	GivenVehicle = CratePickup.Spawn(Vehicles[Rand(Vehicles.Length)],,, tmpSpawnPoint, CratePickup.Rotation,,true);

	GivenVehicle.DropToGround();
	if (GivenVehicle.Mesh != none)
		GivenVehicle.Mesh.WakeRigidBody();
}

DefaultProperties
{
	BroadcastMessageIndex = 15 
	PickupSound = SoundCue'Rx_Pickups.Sounds.SC_Crate_VehicleDrop'

	Vehicles.Add(class'AGN_Vehicle_TeslaTank');
}

