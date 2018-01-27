class AGN_CrateType_MegaSpeed_Helper extends Actor;

var int RestoreSpeedAfterSeconds;
var Rx_Pawn ActivePawn;

function RestoreNormalSpeed(Rx_Pawn player)
{
	ActivePawn = player;
	SetTimer(RestoreSpeedAfterSeconds, false, 'RestorePlayerSpeed');
}

function RestorePlayerSpeed()
{
	// Maybe the player died since - check that the previous pawn no longer exists
	if ( ActivePawn == None )
	{
		self.Destroy();
		return;
	}
	
	ActivePawn.SpeedUpgradeMultiplier = 1;
	ActivePawn.UpdateRunSpeedNode();
	ActivePawn.SetGroundSpeed();
	
	if ( Rx_Controller(ActivePawn.Controller) != None )
		Rx_Controller(ActivePawn.Controller).CTextMessage("You're legs feel weak again, you return to normal speed",'Red',90,1.0);
	
	self.Destroy();
}

DefaultProperties
{
	RestoreSpeedAfterSeconds = 60;
}