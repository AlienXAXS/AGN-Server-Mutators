/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_CrateType_Character extends Rx_CrateType 
	config(AGN_Crates);

var config float ProbabilityIncreaseWhenInfantryProductionDestroyed;

function string GetGameLogMessage(Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	return "GAME" `s "Crate;" `s "character" `s RecipientPRI.CharClassInfo.name `s "by" `s `PlayerLog(RecipientPRI);
}

function string GetPickupMessage()
{
    return "You picked up a character crate!";
}

function float GetProbabilityWeight(Rx_Pawn Recipient, Rx_CratePickup CratePickup)
{
	local Rx_Building building;
	local float Probability;
	Probability = Super.GetProbabilityWeight(Recipient,CratePickup);

	if (!HasFreeUnit(Recipient)) // Don't swap character if we have paid for a unit 
		return 0;

	ForEach CratePickup.AllActors(class'Rx_Building',building)
	{
		if((Recipient.GetTeamNum() == TEAM_GDI && Rx_Building_GDI_InfantryFactory(building) != none  && Rx_Building_GDI_InfantryFactory(building).IsDestroyed()) || 
			(Recipient.GetTeamNum() == TEAM_NOD && Rx_Building_Nod_InfantryFactory(building) != none  && Rx_Building_Nod_InfantryFactory(building).IsDestroyed()))
		{
			Probability += ProbabilityIncreaseWhenInfantryProductionDestroyed;
		}
	}

	return Probability;
}

function bool HasFreeUnit(Rx_Pawn Recipient)
{
	if(Recipient.GetRxFamilyInfo() == class'AGN_FamilyInfo_GDI_Soldier')
		return true;
	if(Recipient.GetRxFamilyInfo() == class'AGN_FamilyInfo_GDI_Shotgunner')
		return true;
	if(Recipient.GetRxFamilyInfo() == class'AGN_FamilyInfo_GDI_Grenadier')
		return true;
	if(Recipient.GetRxFamilyInfo() == class'AGN_FamilyInfo_GDI_Marksman')
		return true;
	if(Recipient.GetRxFamilyInfo() == class'AGN_FamilyInfo_GDI_Engineer')
		return true;
		
	if(Recipient.GetRxFamilyInfo() == class'AGN_FamilyInfo_Nod_Soldier')
	 	return true;
	if(Recipient.GetRxFamilyInfo() == class'AGN_FamilyInfo_Nod_Shotgunner')
		return true;
	if(Recipient.GetRxFamilyInfo() == class'AGN_FamilyInfo_Nod_FlameTrooper')
		return true;
	if(Recipient.GetRxFamilyInfo() == class'AGN_FamilyInfo_Nod_Marksman')
		return true;
	if(Recipient.GetRxFamilyInfo() == class'AGN_FamilyInfo_Nod_Engineer')
		return true;		
		
	return false;	
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	RecipientPRI.SetChar(
		(Recipient.GetTeamNum() == TEAM_GDI ?
		class'AGN_Veh_PurchaseSystem'.default.GDIInfantryClasses[RandRange(5,class'AGN_Veh_PurchaseSystem'.default.GDIInfantryClasses.Length-1)] : 
		class'AGN_Veh_PurchaseSystem'.default.NodInfantryClasses[RandRange(5,class'AGN_Veh_PurchaseSystem'.default.NodInfantryClasses.Length-1)]),
		Recipient);
}

DefaultProperties
{
	BroadcastMessageIndex = 5
	PickupSound = SoundCue'Rx_Pickups.Sounds.SC_Crate_CharacterChange'
}

