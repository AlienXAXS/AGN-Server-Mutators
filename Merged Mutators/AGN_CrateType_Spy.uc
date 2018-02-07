/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_CrateType_Spy extends Rx_CrateType
	config(AGN_Crates);

var int BroadcastMessageAltIndex;
var config float MinutesUntilProbabiltyIncreaseStart;
var config float ProbabilityIncreasePerMinute;
var config float MaxProbabilityIncrease;


function string GetGameLogMessage(Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	return "GAME" `s "Crate;" `s "spy" `s RecipientPRI.CharClassInfo.name `s "by" `s `PlayerLog(RecipientPRI);
}

function string GetPickupMessage()
{
    return "You picked up a spy crate! You're now invisible to base defenses.";
}

function float GetProbabilityWeight(Rx_Pawn Recipient, Rx_CratePickup CratePickup)
{
	local float Probability, ProbabilityIncrease;
	Probability = Super.GetProbabilityWeight(Recipient,CratePickup);

	ProbabilityIncrease = ProbabilityIncreasePerMinute * ((CratePickup.WorldInfo.GRI.ElapsedTime / 60.0f) - MinutesUntilProbabiltyIncreaseStart);
	Probability += fclamp(ProbabilityIncrease,0,MaxProbabilityIncrease);
	
	return Probability;
}

function BroadcastMessage(Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	if (RecipientPRI.GetTeamNum() == TEAM_NOD)
	{
		CratePickup.BroadcastLocalizedTeamMessage(TEAM_GDI, CratePickup.MessageClass, BroadcastMessageAltIndex, RecipientPRI);
		CratePickup.BroadcastLocalizedTeamMessage(TEAM_NOD, CratePickup.MessageClass, BroadcastMessageIndex, RecipientPRI);
	}
	else
	{
		CratePickup.BroadcastLocalizedTeamMessage(TEAM_NOD, CratePickup.MessageClass, BroadcastMessageAltIndex, RecipientPRI);
		CratePickup.BroadcastLocalizedTeamMessage(TEAM_GDI, CratePickup.MessageClass, BroadcastMessageIndex, RecipientPRI);
	}
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	RecipientPRI.SetChar(
		(Recipient.GetTeamNum() == TEAM_NOD ?
		class'AGN_Veh_PurchaseSystem'.default.GDIInfantryClasses[Rand(14)] : 
		class'AGN_Veh_PurchaseSystem'.default.NodInfantryClasses[Rand(14)]),
		Recipient);
	RecipientPRI.SetIsSpy(true);	
}

DefaultProperties
{
	BroadcastMessageIndex = 8
	BroadcastMessageAltIndex = 7
	PickupSound = SoundCue'Rx_Pickups.Sounds.SC_Crate_Spy'
}

