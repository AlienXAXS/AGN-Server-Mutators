/*
 *
 * --- Drop Money Crate ---
 *
 *
 * Thanks to uKill for all of his help on this - he's amazing!
 *	-- Sarah & AlienX
 */

class AGN_CrateType_DropMoney extends AGN_CrateType;

var config float MinutesToGiveSmallSum;
var config float ProbabilityIncreaseWhenPowerPlantDestroyed;
var config float ProbabilityIncreaseWhenRefineryDestroyed;

var transient int credits;

function string GetGameLogMessage(Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
    return "GAME" `s "Crate;" `s "drop money" `s credits `s "by" `s `PlayerLog(RecipientPRI);
}

function string GetPickupMessage()
{
	return "You dropped some credits!";
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

        return false;
    }

    function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
    {
    	if(CratePickup.WorldInfo.GRI.ElapsedTime < MinutesToGiveSmallSum * 60.0f) // 100 to 200 credits in 25 intervals
    		credits = 100 + (Rand(5) * 25);
    	else // 100 to 500 credits in 50 interval
    		credits = ((Rand(2)+1) * 100) + (Rand(2) * 50) + (Rand(2) * 50);

    	RecipientPRI.RemoveCredits(credits);
    }

DefaultProperties
{
    BroadcastMessageIndex = 1003
    //PickupSound = SoundCue'Rx_Pickups.Sounds.SC_Pickup_Ammo'
}
