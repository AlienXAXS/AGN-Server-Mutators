/*
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 *
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 *
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 *
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_HUD extends Rx_HUD;

var AGN_HUD_AdminComponent AGN_HUDAdminComponent;
var AGN_HUD_CrateStatus AGN_HUDCrateStatus;
var int DefaultTargettingRangex;

function CreateHUDMovie()
{
    HudMovie = new class'AGN_GfxHud';
    HudMovie.SetTimingMode(1);
    HudMovie.Initialize();
    HudMovie.SetTimingMode(1);
    HudMovie.SetViewScaleMode(3);
    HudMovie.SetAlignment(5);
    HudMovie.RenxHud = self;
}

function CreateHudCompoenents()
{
	super.CreateHudCompoenents();

	`log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	`log("~ Creating AGN HUD Components ~");
	`log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");

	AGN_HUDAdminComponent = new class'AGN_HUD_AdminComponent';
}

function OpenOverviewMap()
{
	bToggleOverviewMap = true;

	OverviewMapMovie = new class'AGN_Rx_GFxOverviewMap';
	OverviewMapMovie.LocalPlayerOwnerIndex = GetLocalPlayerOwnerIndex();
	
	if ( Canvas != None )
		OverviewMapMovie.SetViewport(0,0,Canvas.ClipX, Canvas.ClipY);
		
	OverviewMapMovie.SetViewScaleMode(SM_ExactFit);
	OverviewMapMovie.SetTimingMode(TM_Real);

	OverviewMapMovie.Start();

	//Hide our hud
	SetVisible(false);
}

function UpdateHudCompoenents(float DeltaTime, Rx_HUD HUD)
{
	super.UpdateHudCompoenents(DeltaTime, HUD);
	if ( AGN_HUDAdminComponent != None ) AGN_HUDAdminComponent.Update(DeltaTime, HUD);
}

function DrawHudCompoenents()
{
	super.DrawHudCompoenents();
	if ( AGN_HUDAdminComponent != None ) AGN_HUDAdminComponent.Draw();
}

function float GetWeaponTargetingRange()
{
    local Weapon OurWeapon;
	local float weaponRange;

    if((PlayerOwner != none) && PlayerOwner.ViewTarget != none)
    {
		if (UTVehicle(PlayerOwner.ViewTarget) != none && UTVehicle(PlayerOwner.ViewTarget).Weapon != none)
			OurWeapon = UTVehicle(PlayerOwner.ViewTarget).Weapon;
		else if (UTPawn(PlayerOwner.ViewTarget) != none && UTPawn(PlayerOwner.ViewTarget).Weapon != none)
			OurWeapon = UTPawn(PlayerOwner.ViewTarget).Weapon;

        if(((OurWeapon != none) && Rx_Weapon_Deployable(OurWeapon) == none) && Rx_Weapon_RepairGun(OurWeapon) == none)
        {
            weaponRange = GetWeaponRange();
			if ( weaponRange == 0 )
			{
				if ( OurWeapon.default.WeaponRange > 0 )
					return OurWeapon.default.WeaponRange;
				else
					return DefaultTargettingRangex;
			} else {
				return weaponRange;
			}
        }
        else
            return DefaultTargettingRangex;
    } else
		return DefaultTargettingRangex;
}

function UpdateScreenCentreActor()
{
	local Vector CameraOrigin, CameraDirection, HitLoc,HitNormal,TraceRange;
	local float ClosestHit, extendedDist, tempDist;
	local Actor HitActor, PotentialTarget;
	local float WeaponTargetingRange;

	PotentialTarget = none;
	WeaponAimingActor = none;

	//  --- AGN ---
	// If we're using a custom projectile or custom weapon
	// GetWeaponTargetingRange always returns zero
	// So, We crudly check if the current weapon is of a custom type and get the WeaponRange from default properties.
	WeaponTargetingRange = GetWeaponTargetingRange();
	
	if ( WeaponTargetingRange == 0 )
		WeaponTargetingRange = 10000;

	ClosestHit = WeaponTargetingRange;

	GetCameraOriginAndDirection(CameraOrigin,CameraDirection);

	TraceRange = CameraOrigin + CameraDirection * WeaponTargetingRange;
	extendedDist = VSize(CameraOrigin - PlayerOwner.ViewTarget.location);
	TraceRange += CameraDirection * extendedDist;

	// This trace will ignore the view target so we don't target ourselves.
	foreach TraceActors(class'actor',HitActor,HitLoc,HitNormal,TraceRange,CameraOrigin,vect(0,0,0),,1)
	{
		AimLoc = HitLoc;
		if (Landscape(HitActor) != None)
			break;
		if (StaticMeshActor(HitActor) != None)
			break;
		tempDist = VSize(CameraOrigin - HitLoc) - extendedDist;
		if (HitActor != PlayerOwner.ViewTarget && ClosestHit >= tempDist)
		{
			ClosestHit = tempDist;
			if (ClosestHit < GetWeaponRange()) // If the hit actor is also within weapon range, then weapon aiming actor is it.
				WeaponAimingActor = HitActor;
			PotentialTarget = HitActor;
			TargetingBox.TargetActorHitLoc = HitLoc;
			break;
		}
	}
	
	ScreenCentreActor = PotentialTarget;
}

function Message( PlayerReplicationInfo PRI, coerce string Msg, name MsgType, optional float LifeTime )
{
	local string cName, fMsg, rMsg;
	local bool bEVA;

	if (Len(Msg) == 0)
		return;

	if ( bMessageBeep )
		PlayerOwner.PlayBeepSound();

	// Create Raw and Formatted Chat Messages
	
	if (PRI != None)
	{	
		// We have a player, let's sort this out
		cName = CleanHTMLMessage(PRI.PlayerName);
	
		if ( class'AGN_UtilitiesX'.static.IsPlayerSpecial(PRI, 0) )
			cName = "<font color='#FF8A5D'><b>{OWNER}</b></font> " $ cName;
		else if ( class'AGN_UtilitiesX'.static.IsPlayerSpecial(PRI, 1) )
			cName = "<font color='#8AFF43'><b>{ADMIN}</b></font> " $ cName;
		else if ( class'AGN_UtilitiesX'.static.IsPlayerSpecial(PRI, 2) )
			cName = "<font color='#D24CFF'><b>{MOD}</b></font> " $ cName;
		else if ( class'AGN_UtilitiesX'.static.IsPlayerSpecial(PRI, 3) )
			cName = "<font color='#79B9F9'><b>{DONOR}</b></font> " $ cName;
	}
	else
		cName = "Host";
		
	if (MsgType == 'Say') {
		if (PRI == None)
			fMsg = "<font color='" $HostColor$"'>" $cName$"</font>: <font color='#FFFFFF'>"$CleanHTMLMessage(Msg)$"</font>";
		else if (PRI.Team.GetTeamNum() == TEAM_GDI)
			fMsg = "<font color='" $GDIColor $"'>" $cName $"</font>: ";
		else if (PRI.Team.GetTeamNum() == TEAM_NOD)
			fMsg = "<font color='" $NodColor $"'>" $cName $"</font>: ";
	
		if ( cName != "Host" ) {
			fMsg $= CleanHTMLMessage(Msg);
			PublicChatMessageLog $= "\n" $ fMsg;
			rMsg = cName $": "$ Msg;
		}
	}
	else if (MsgType == 'TeamSay') {
		if (PRI.GetTeamNum() == TEAM_GDI)
		{
			fMsg = "<font color='" $GDIColor $"'>" $ cName $": "$ CleanHTMLMessage(Msg) $"</font>";
			PublicChatMessageLog $= "\n" $ fMsg;
			rMsg = cName $": "$ Msg;
		}
		else if (PRI.GetTeamNum() == TEAM_NOD)
		{
			fMsg = "<font color='" $NodColor $"'>" $ cName $": "$ CleanHTMLMessage(Msg) $"</font>";
			PublicChatMessageLog $= "\n" $ fMsg;
			rMsg = cName $": "$ Msg;
		}
	}
	else if (MsgType == 'Radio')
	{
		if(Rx_PRI(PRI).bGetIsCommander())
			fMsg = "<font color='" $CommandTextColor $"'>" $ "[Commander]" $ cName $": "$ Msg $"</font>"; 
		else
			fMsg = "<font color='" $RadioColor $"'>" $ cName $": "$ Msg $"</font>"; 
		
		fMsg = HighlightStructureNames(fMsg); 
		//PublicChatMessageLog $= "\n" $ fMsg;
		rMsg = cName $": "$ Msg;
	}
	else if (MsgType == 'Commander') 
	{
		if(Left(Caps(msg), 2) == "/C") 
		{
			msg = Right(msg, Len(msg)-2);
			Rx_Controller(PlayerOwner).CTextMessage(msg,'Pink', 120.0,,true);
		}
		else
		if(Left(Caps(msg), 2) == "/R") 
		{
			msg = Right(msg, Len(msg)-2);
			Rx_Controller(PlayerOwner).CTextMessage(msg,'Pink', 360.0,,true);
		}
		fMsg = "<b><font color='" $CommandTextColor $"'>" $ "[Commander]"$ cName $": "$ CleanHTMLMessage(Msg) $"</font></b>";
		//PublicChatMessageLog $= "\n" $ fMsg;
		rMsg = cName $": "$ Msg;
	}
	else if (MsgType == 'System') {
		if(InStr(Msg, "entered the game") >= 0)
			return;
		fMsg = Msg;
		PublicChatMessageLog $= "\n" $ fMsg;
		rMsg = Msg;
	}
	else if (MsgType == 'PM') {
		if (PRI != None)
			fMsg = "<font color='"$PrivateFromColor$"'>Private from "$cName$": "$CleanHTMLMessage(Msg)$"</font>";
		else
			fMsg = "<font color='"$HostColor$"'>Private from "$cName$": "$CleanHTMLMessage(Msg)$"</font>";
		PrivateChatMessageLog $= "\n" $ fMsg;
		rMsg = "Private from "$ cName $": "$ Msg;
	}
	else if (MsgType == 'PM_Loopback') {
		fMsg = "<font color='"$PrivateToColor$"'>Private to "$cName$": "$CleanHTMLMessage(Msg)$"</font>";
		PrivateChatMessageLog $= "\n" $ fMsg;
		rMsg = "Private to "$ cName $": "$ Msg;
	}
	else
		bEVA = true;

	// Add to currently active GUI | Edit by Yosh : Don't bother spamming the non-HUD chat logs with radio messages... it's pretty pointless for them to be there.
	if (bEVA)
	{
		if (HudMovie != none && HudMovie.bMovieIsOpen)
			HudMovie.AddEVAMessage(Msg);
	}
	else
	{
		if (HudMovie != none && HudMovie.bMovieIsOpen)
			HudMovie.AddChatMessage(fMsg, rMsg);

		if (Scoreboard != none && MsgType != 'Radio' && Scoreboard.bMovieIsOpen) {
			if (PlayerOwner.WorldInfo.GRI.bMatchIsOver) {
				Scoreboard.AddChatMessage(fMsg, rMsg);
			}
		}

		if (RxPauseMenuMovie != none && MsgType != 'Radio' && RxPauseMenuMovie.bMovieIsOpen) {
			if (RxPauseMenuMovie.ChatView != none) {
				RxPauseMenuMovie.ChatView.AddChatMessage(fMsg, rMsg, MsgType=='PM' || MsgType=='PM_Loopback');
			}
		}

	}
}

DefaultProperties
{
	DefaultTargettingRangex = 10000;
	HudMovieClass = class'AGN_GFxHud'
}
