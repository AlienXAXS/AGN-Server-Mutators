class AGN_ReservedSlotsController extends Actor;
var PlayerController plrController;
var int CountDown;

function StartPlayerKickProcess(PlayerController thisPlayerController)
{
	plrController = thisPlayerController;
	CountDown = 10;
	SetTimer(1, true, 'TickPlayerKickProcess');
}

function TickPlayerKickProcess()
{
	if ( CountDown == 0 )
	{
		KickPlayerAndKillSelf();
	} else {
		Rx_Controller(plrController).CTextMessage("[AGN System Message]\nYou have joined a reserved slot and will be kicked in " $ string(CountDown) $ " second(s)",'LightGreen',100);
		CountDown--;
	}
}

function KickPlayerAndKillSelf()
{
	`WorldInfoObject.Game.AccessControl.KickPlayer(plrController, "Sorry, this player slot is reserved.  Try again later.");
	self.Destroy();
}