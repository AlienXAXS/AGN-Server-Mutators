/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_CrateType_SuperMoney extends AGN_CrateType
	config(AGN_Crates);

var config float MinutesToGiveSmallSum;
var config float ProbabilityIncreaseWhenPowerPlantDestroyed;
var config float ProbabilityIncreaseWhenRefineryDestroyed;

var transient int credits;

function string GetGameLogMessage(Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	return "GAME" `s "Crate;" `s "super-money" `s credits `s "by" `s `PlayerLog(RecipientPRI);
}

function string GetPickupMessage()
{
	return Repl("You found a Super Money crate and have shared `credsum` credits with your team!", "`credsum`", credits, false);
}

function float GetProbabilityWeight(Rx_Pawn Recipient, AGN_CratePickup CratePickup)
{
	local Rx_Building building;
	local float Probability;
	Probability = Super.GetProbabilityWeight(Recipient,CratePickup);
	
	ForEach CratePickup.AllActors(class'Rx_Building',building)
	{
		if((Recipient.GetTeamNum() == TEAM_GDI && Rx_Building_GDI_PowerFactory(building) != none  && Rx_Building_GDI_PowerFactory(building).IsDestroyed()) || 
			(Recipient.GetTeamNum() == TEAM_NOD && Rx_Building_Nod_PowerFactory(building) != none  && Rx_Building_Nod_PowerFactory(building).IsDestroyed()))
		{
			Probability += ProbabilityIncreaseWhenPowerPlantDestroyed;
		}
		if((Recipient.GetTeamNum() == TEAM_GDI && Rx_Building_GDI_MoneyFactory(building) != none  && Rx_Building_GDI_MoneyFactory(building).IsDestroyed()) || 
			(Recipient.GetTeamNum() == TEAM_NOD && Rx_Building_Nod_MoneyFactory(building) != none  && Rx_Building_Nod_MoneyFactory(building).IsDestroyed()))
		{
			Probability += ProbabilityIncreaseWhenRefineryDestroyed;
		}
	}

	LogInternal("SuperMoney GetProbabilityWeight returning " @ Probability);
	return Probability;
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	credits = 100;
	RecipientPRI.AddCredits(credits);
	Recipient.ClientMessage("You found a Super Money crate, and have shared it's worth with your team!");
	GiveCreditsToAll(Recipient);
}

reliable server function GiveCreditsToAll(Rx_Pawn Sender)
{
	local byte teamNum;
	local Controller plyrController;
	local Controller c;
	
	// How many credits to give to each player on the team
	credits = 100;
	teamNum = Sender.GetTeamNum();
	plyrController = Sender.Controller;
	
	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
	{
		if (c.GetTeamNum() == teamNum && Rx_PRI(c.PlayerReplicationInfo) != None && c != plyrController )
		{
			if (PlayerController(c) != None)
			{
				//Recipient.CTextMessage(GetPickupMessage(),'LightGreen',90);
				Rx_Controller(c).CTextMessage(Rx_PRI(Sender.PlayerReplicationInfo).PlayerName $ " found a super-money crate and has shared with you " $ credits $" credits.",'LightGreen',90);
				Rx_PRI(c.PlayerReplicationInfo).AddCredits(credits);
				PlayAudio(Rx_PRI(c.PlayerReplicationInfo));
			}
		}
	}
}

simulated function PlayAudio(Rx_PRI pri)
{
	pri.PlaySound(PickupSound);
}

DefaultProperties
{
	BroadcastMessageIndex = 1001
	PickupSound = SoundCue'Rx_Pickups.Sounds.SC_Crate_Money'
}

