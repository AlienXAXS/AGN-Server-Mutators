/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_CrateType_Abduction extends AGN_CrateType
	config(AGN_Crates);

function string GetGameLogMessage(Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	return "GAME" `s "Crate;" `s "abduction" `s "by" `s `PlayerLog(RecipientPRI);
}

function string GetPickupMessage()
{
    return "You're getting abducted!";
}

function float GetProbabilityWeight(Rx_Pawn Recipient, AGN_CratePickup CratePickup)
{
	// 0 Probability if the area directly above us isn't clear
	if (CratePickup.FastTrace(CratePickup.Location + vect(0,0,1000),CratePickup.Location + vect(0,0,256)))
		return super.GetProbabilityWeight(Recipient,CratePickup);
	else
		return 0;
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	local Rx_AlienAbductionBeam Beam;

	Beam = CratePickup.Spawn(class'Rx_AlienAbductionBeam',,,Recipient.Location);
	Beam.SetTarget(Recipient);
}

DefaultProperties
{
	//PickupSound = SoundCue'RX_EVA_VoiceClips.Nod_EVA.S_EVA_Nod_Beacon_NuclearStrikeImminent_Cue'
	BroadcastMessageIndex = 12
}

