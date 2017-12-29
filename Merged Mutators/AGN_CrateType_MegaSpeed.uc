class AGN_CrateType_MegaSpeed extends AGN_CrateType
    config(AGN_Crates);

var int SpeedBoostPercent;
var bool isActive; // Tracks if the crate is active or not
var Rx_Pawn ActivePawn;

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
    Recipient.SpeedUpgradeMultiplier += SpeedBoostPercent * 100.0;
    Recipient.UpdateRunSpeedNode();
    Recipient.SetGroundSpeed();

    `log("Increasing speed by" @ SpeedBoostPercent * 100.0 @ " percent to " @ Recipient.SpeedUpgradeMultiplier);
	SetTimer(60, false, 'RestoreNormalSpeed');
	isActive = true;
	ActivePawn = Recipient;
}

function float GetProbabilityWeight(Rx_Pawn Recipient, AGN_CratePickup CratePickup)
{
	if ( isActive )
		return 0;
	else return Super.GetProbabilityWeight(Recipient, CratePickup);
}

function RestoreNormalSpeed()
{
	// Maybe the player died since - check that the previous pawn no longer exists
	if ( ActivePawn == None )
		return;
	
	ActivePawn.SpeedUpgradeMultiplier = 0;
	ActivePawn.UpdateRunSpeedNode();
	ActivePawn.SetGroundSpeed();
	
	isActive = false;
}

DefaultProperties
{
    BroadcastMessageIndex = 1006
    //PickupSound = SoundCue'Rx_Pickups.Sounds.SC_Crate_Refill' // This is not a refill, turn this off.
    SpeedBoostPercent = 100 //Double speed
}