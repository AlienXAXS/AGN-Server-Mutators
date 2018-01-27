/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_CrateType_Veterancy extends Rx_CrateType 
	config(AGN_Crates);

var const int VPAmount;

function string GetGameLogMessage(Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	return "GAME" `s "Crate;" `s "veterancy" `s "by" `s `PlayerLog(RecipientPRI) `s "amount" `s VPAmount;
}

function string GetPickupMessage()
{
    return "You picked up a veterancy crate!";
}

function float GetProbabilityWeight(Rx_Pawn Recipient, Rx_CratePickup CratePickup)
{
	if (Rx_PRI(Recipient.Controller.PlayerReplicationInfo).VRank >= ArrayCount(class'Rx_Game'.default.VPMilestones))
		return 0;
	else
		return super.GetProbabilityWeight(Recipient,CratePickup);
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	RecipientPRI.AddVP(VPAmount);
}

DefaultProperties
{
	VPAmount = 20
	BroadcastMessageIndex = 16
	PickupSound = SoundCue'Rx_Pickups.Sounds.SC_Crate_Refill'
}

