/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_CrateType_Speed extends AGN_CrateType
	config(AGN_Crates);

var int SpeedIncreasePercent;

function string GetGameLogMessage(Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	return "GAME" `s "Crate;" `s "speed" `s "by" `s `PlayerLog(RecipientPRI);
}

function string GetPickupMessage()
{
	return "You picked up a speed crate!";
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	Recipient.SpeedUpgradeMultiplier += SpeedIncreasePercent / 100.0;
	Recipient.UpdateRunSpeedNode();
	Recipient.SetGroundSpeed();

	`log("Increasing speed by" @ SpeedIncreasePercent / 100.0 @ "percent to " @Recipient.SpeedUpgradeMultiplier);
}

DefaultProperties
{
	BroadcastMessageIndex = 11
	PickupSound = SoundCue'Rx_Pickups.Sounds.SC_Crate_Refill'

	SpeedIncreasePercent = 5 //10
}

