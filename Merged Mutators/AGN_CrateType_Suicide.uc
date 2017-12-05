class AGN_CrateType_Suicide extends AGN_CrateType
	config(AGN_Crates);

function string GetGameLogMessage(Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	return "GAME" `s "Crate;" `s "suicide" `s "by" `s `PlayerLog(RecipientPRI);
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	Recipient.Suicide();
}

DefaultProperties
{
	BroadcastMessageIndex = 10
	PickupSound = none
}
