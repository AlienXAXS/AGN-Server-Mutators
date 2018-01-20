/*
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 *
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 *
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 *
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


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

static function SendMessageToOnlineAdministrators(string message)
{
	local Controller c;
	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
	{
		if ( c != None )
			if ( Rx_Controller(c) != none && Rx_PRI(Rx_Controller(c).PlayerReplicationInfo) != None && Rx_PRI(Rx_Controller(c).PlayerReplicationInfo).bAdmin )
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

/*
static function SetCratePickupMessageForTeam(int TeamID, string message, int counter)
{
	local Controller c;

	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
	{
		if ( c != None && c.GetTeamNum() == TeamID )
			if ( Rx_Controller(c) != none )
				AGN_Rx_Controller(c).ServerAddNewCrateStatus(message, counter);
	}
}
*/

static function PlayAudioForTeam(int TeamID, SoundCue mySoundCue )
{
	local Controller c;

	// Only do this on the server, otherwise we get lots and lots of sounds at once.
	if(`WorldInfoObject.NetMode != NM_DedicatedServer)
		return;

	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
	{
		if ( c != None && c.GetTeamNum() == TeamID )
			if ( Rx_Controller(c) != none )
					Rx_Controller(c).PlaySound(mySoundCue);
	}
}

static function string GetWeaponNameIncludingCustomWeapons(UTWeapon WeaponClass)
{
	if ( WeaponClass.IsA('AGN_Weapon_PersonalIonCannon') )
		return "Personal Unicorn Cannon";
	else if ( WeaponClass.IsA('AGN_Weapon_TiberiumFlechetteRifle') )
		return "Tiberium Flechette Rifle";
	else if ( WeaponClass.IsA('AGN_Weapon_PersonalObeliskCannon') )
		return "Personal Obelisk Cannon";
	else if ( WeaponClass.IsA('AGN_Weapon_NukeBeacon') )
		return "Nuclear Strike Beacon";
	else if ( WeaponClass.IsA('AGN_Weapon_IonCannonBeacon') )
		return "Ion Cannon Beacon";
	else if (WeaponClass.IsA('AGN_Weapon_Carbine_Silencer') )
		return "Silenced Carbine";
	else if (WeaponClass.IsA('AGN_Weapon_Shotgun') )
		return "Shotgun";
	else
		return WeaponClass.ItemName;
}

static function DumpAllActors(PlayerController sender)
{
      local Actor thisActor;
      local int aCount;
			`log("-------------- STARTING DUMP -------------------");
    	foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Actor', thisActor)
    {
         aCount++;
        `log("[AGN-Dump] " $ string(thisActor));
    }
		`log("----------- DUMP FINISHED " $ string(aCount) $ " actors dumped! --------------");
		Sender.ClientMessage("[AGN-Dump] " $ string(aCount) $ " actors dumped!");
}

static function bool IsPlayerSpecial(PlayerReplicationInfo pri, string SpecialHow)
{
	local string PlayerUUID;
	PlayerUUID = Rx_PRI(pri).PlayerName;
	
	if ( SpecialHow == "OWNER" && pri.bAdmin )
		if ( PlayerUUID ~= "[AGN] AlienX" )
			return true;
			
	if ( SpecialHow == "ADMIN" && pri.bAdmin )
		if ( PlayerUUID ~= "[AGN] Sarah" || PlayerUUID ~= "[AGN] Bubbles" )
			return true;
			
	if ( SpecialHow == "MOD" && Rx_PRI(pri).bModeratorOnly )
		// Shogun
		if (PlayerUUID ~= "[AGN] Shogun Kitsune" || PlayerUUID ~= "[AGN] Shogun" )
			return true;

		// Commander (this might fuck up because of unicode)
		if ( PlayerUUID ~= "✠☢commander☢✠" )
			return true;

	if ( SpecialHow == "DONOR" )
		if ( PlayerUUID ~= "Hackerham" ) //Hackerham
			return true;
	
		if ( PlayerUUID ~= "TRRDroid" ) //TRRDroid
			return true;

	return false;
}
