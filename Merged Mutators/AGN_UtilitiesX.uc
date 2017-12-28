class AGN_UtilitiesX extends object;

static function SendMessageToAllPlayers(string message)
{
	local Controller c;
	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
	{
		if ( c != None )
			if ( Rx_Controller(c) != none )
				Rx_Controller(c).CTextMessage("[AGN] " $ message,'LightGreen',120);
	}
}

static function SendMessageToPlayersInTeam(int TeamID, string message, optional name Colorx = 'LightGreen', optional int TimeOnScreen = 120)
{
	local Controller c;
		
	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
	{
		if ( c != None && c.GetTeamNum() == TeamID )
			if ( Rx_Controller(c) != none )
					Rx_Controller(c).CTextMessage("[AGN] " $ message,Colorx,TimeOnScreen);
	}
}

static function PlayAudioForTeam(int TeamID, SoundCue mySoundCue )
{
	local Controller c;
		
	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
	{
		if ( c != None && c.GetTeamNum() == TeamID )
			if ( Rx_Controller(c) != none )
					Rx_Controller(c).PlaySound(mySoundCue);
	}
}