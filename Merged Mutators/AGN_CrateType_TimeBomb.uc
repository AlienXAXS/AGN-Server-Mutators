/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_CrateType_TimeBomb extends AGN_CrateType
	config(AGN_Crates);

function string GetGameLogMessage(Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	return "GAME" `s "Crate;" `s "timebomb" `s "by" `s `PlayerLog(RecipientPRI);
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	local Rx_Weapon_DeployedTimedC4 C4;
	local Rotator spawnRotation;
	local Vector spawnLocation;

	Recipient.GetActorEyesViewPoint(spawnLocation,spawnRotation);
	spawnRotation = rotator(Normal(vector(spawnRotation) * vect(1,1,0))); // Flatten, we only care about x/y direction
	spawnLocation -= vector(spawnRotation) * 10; // Place behind the eyes to not interfere with first person firing.

	C4 = CratePickup.Spawn(class'Rx_Weapon_DeployedTimedC4',,, spawnLocation,spawnRotation + rot(16384,-16384,0));
	C4.Landed(vect(0,0,1),Recipient);
	C4.InstigatorController = Recipient.Controller;
	C4.SetDamageAll(true);
	C4.TeamNum = Recipient.GetTeamNum();
	
	/*
	if ( AGN_Rx_Controller(Recipient.Controller) != None )
	{
		AGN_Rx_Controller(Recipient.Controller).ServerAddNewCrateStatus("Time Bomb", 30);
	}
	*/
}

DefaultProperties
{
	BroadcastMessageIndex = 13
	PickupSound = none
}

