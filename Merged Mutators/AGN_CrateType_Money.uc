/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_CrateType_Money extends AGN_CrateType
	config(AGN_Crates);

var config float MinutesToGiveSmallSum;
var config float ProbabilityIncreaseWhenPowerPlantDestroyed;
var config float ProbabilityIncreaseWhenRefineryDestroyed;

var transient int credits;

function string GetGameLogMessage(Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	return "GAME" `s "Crate;" `s "money" `s credits `s "by" `s `PlayerLog(RecipientPRI);
}

function string GetPickupMessage()
{
	return "You found a money crate and got " $ credits $ " credits!";
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

	return Probability;
}


function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	if(CratePickup.WorldInfo.GRI.ElapsedTime < MinutesToGiveSmallSum * 60.0f) // 100 to 200 credits in 25 intervals
		credits = 100 + (Rand(5) * 25);
	else // 100 to 500 credits in 50 interval
		credits = ((Rand(2)+1) * 100) + (Rand(2) * 50) + (Rand(2) * 50);

	RecipientPRI.AddCredits(credits);
}

DefaultProperties
{
	BroadcastMessageIndex = 4
	PickupSound = SoundCue'Rx_Pickups.Sounds.SC_Crate_Money'
}

