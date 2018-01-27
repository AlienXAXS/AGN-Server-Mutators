/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_CrateType_Refill extends Rx_CrateType 
	config(AGN_Crates);

function string GetGameLogMessage(Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	return "GAME" `s "Crate;" `s "refill" `s "by" `s `PlayerLog(RecipientPRI);
}

function string GetPickupMessage()
{
    return "You feel refreshed!";
}

function float GetProbabilityWeight(Rx_Pawn Recipient, Rx_CratePickup CratePickup)
{
	LogInternal("Refill GetProbabilityWeight returning " @ super.GetProbabilityWeight(Recipient,CratePickup));
	if (!CanUseRefill(Recipient))
		return 0;
	else return super.GetProbabilityWeight(Recipient,CratePickup);
}

function bool CanUseRefill(Rx_Pawn Recipient)
{
	local float MaxAmmoCount;
	local float AmmoCount;
	
	MaxAmmoCount = Rx_Weapon(Recipient.weapon).MaxAmmoCount;
	AmmoCount = Rx_Weapon(Recipient.weapon).AmmoCount;	
	
	if(AmmoCount/(MaxAmmoCount/100.0) < 75.0)
	{
		loginternal(AmmoCount/(MaxAmmoCount/100.0));
		return true;	
	}
	
	if(Recipient.Health/(Recipient.HealthMax/100.0) < 75.0)
	{
		return true;	
	}
	return false;
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	Recipient.Health = Recipient.HealthMax;
	Recipient.DamageRate = 0;
	Recipient.Armor  = Recipient.ArmorMax;
	Recipient.ClientSetStamina(Recipient.MaxStamina);

	if(Rx_Pawn_SBH(Recipient) != None)
			Rx_Pawn_SBH(Recipient).ChangeState('WaitForSt');
	
	if(Rx_InventoryManager(Recipient.InvManager) != none )
    {
		Rx_InventoryManager(Recipient.InvManager).PerformWeaponRefill();
    }
}

DefaultProperties
{
	BroadcastMessageIndex = 9
	PickupSound = SoundCue'Rx_Pickups.Sounds.SC_Crate_Refill'
}

