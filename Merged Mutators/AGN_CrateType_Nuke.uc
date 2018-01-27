/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_CrateType_Nuke extends Rx_CrateType 
	config(AGN_Crates);

function string GetGameLogMessage(Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	return "GAME" `s "Crate;" `s "nuke" `s "by" `s `PlayerLog(RecipientPRI);
}

function string GetPickupMessage()
{
    return "Incoming nuclear strike!";
}

function float GetProbabilityWeight(Rx_Pawn Recipient, Rx_CratePickup CratePickup)
{
	if (CratePickup.bNoNukeDeath)
		return 0;
	else return super.GetProbabilityWeight(Recipient,CratePickup);
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	local Rx_Weapon_CrateNuke Beacon;
	local Rotator spawnRotation;
	local Vector spawnLocation;

	Recipient.GetActorEyesViewPoint(spawnLocation,spawnRotation);

	Beacon = CratePickup.Spawn(class'Rx_Weapon_CrateNuke',,, CratePickup.Location,CratePickup.Rotation);
	Beacon.TeamNum = TEAM_UNOWNED;
}

DefaultProperties
{
	PickupSound = SoundCue'RX_EVA_VoiceClips.Nod_EVA.S_EVA_Nod_Beacon_NuclearStrikeImminent_Cue'
	BroadcastMessageIndex = 3
}

