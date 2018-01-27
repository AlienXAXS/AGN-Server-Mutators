/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_CrateType_MegaSpeed extends Rx_CrateType 
    config(AGN_Crates);

var AGN_CrateType_MegaSpeed_Helper CrateHelper;

function string GetGameLogMessage(Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
    return "GAME" `s "Crate;" `s "speed boost" `s "by" `s `PlayerLog(RecipientPRI);
}

function string GetPickupMessage()
{
    return "You picked up the Mega Speed Crate (60 Seconds)";
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	if ( CrateHelper == None )
		CrateHelper = CratePickup.Spawn(class'AGN_CrateType_MegaSpeed_Helper');
	
	if ( CrateHelper != None )
	{
		CrateHelper.RestoreNormalSpeed(Recipient);
		Recipient.SpeedUpgradeMultiplier = 1.5f;
		Recipient.UpdateRunSpeedNode();
		Recipient.SetGroundSpeed();
	}
}

function float GetProbabilityWeight(Rx_Pawn Recipient, Rx_CratePickup CratePickup)
{
	return Super.GetProbabilityWeight(Recipient, CratePickup);
}

DefaultProperties
{
    BroadcastMessageIndex = 1006
    //PickupSound = SoundCue'Rx_Pickups.Sounds.SC_Crate_Refill' // This is not a refill, turn this off.
}

