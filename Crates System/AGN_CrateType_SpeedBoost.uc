class AGN_CrateType_SpeedBoost extends AGN_CrateType
    config(AGN_Crates);

var int SpeedBoostPercent;
//var Actor thisActor;

function string GetGameLogMessage(Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
	return "GAME" `s "Crate;" `s "speed boost" `s "by" `s `PlayerLog(RecipientPRI);
}

function string GetPickupMessage()
{
	return Repl(PickupMessage, "`increasepct`", SpeedBoostPercent, false);
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{

	Recipient.SpeedUpgradeMultiplier += SpeedBoostPercent / 100.0;
	Recipient.UpdateRunSpeedNode();
	Recipient.SetGroundSpeed();

	`log("Increasing speed by" @ SpeedBoostPercent / 100.0 @ "percent to " @Recipient.SpeedUpgradeMultiplier);
  SetTimer(60, false, 'RestoreNormalSpeed');
}



final function RestoreNormalSpeed(Rx_Pawn Recipient, Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
  Recipient.SpeedUpgradeMultiplier -= SpeedBoostPercent / 100.0;
  Recipient.UpdateRunSpeedNode();
  Recipient.SetGroundSpeed();
}




DefaultProperties
{
	BroadcastMessageIndex = 1005
	PickupSound = SoundCue'Rx_Pickups.Sounds.SC_Crate_Refill'
	SpeedBoostPercent = 100 //Double speed
}
