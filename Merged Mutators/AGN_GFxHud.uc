class AGN_GFxHud extends Rx_GFxHud;

var() AGN_GFxMinimap AGNMinimap;

exec function UpdateHUDVars() 
{
	// Grease:	When you have two frames, and an object in each frame with the same name,
	//			the variables HAVE to be updated, otherwise it will only change the object
	//			from frame 1, even if you're in frame 2.

	// Shahman: in UT (GFxMinimapHud), what epic did is to call the GFxMoviePlayer's gotoandstop function and reupdate.



	//Health
	HealthBar       = GetVariableObject("_root.HealthBlock.Health");
	HealthN         = GetVariableObject("_root.HealthBlock.HealthText.HealthN");
	HealthMaxN      = GetVariableObject("_root.HealthBlock.HealthText.HealthMaxN");
	HealthBlock     = GetVariableObject("_root.HealthBlock");
	HealthText      = GetVariableObject("_root.HealthBlock.HealthText");
	HealthIcon      = GetVariableObject("_root.HealthBlock.HealthIcon");

	//Armor
	ArmorBar        = GetVariableObject("_root.HealthBlock.Armor");
	ArmorN          = GetVariableObject("_root.HealthBlock.ArmorN");
	ArmorMaxN       = GetVariableObject("_root.HealthBlock.ArmorMaxN");
	VArmorMaxN      = GetVariableObject("_root.HealthBlock.VehicleMaxN");
	//nBab
	VHealthN         = GetVariableObject("_root.HealthBlock.HealthN");

	//Vehicle
	VArmorN         = GetVariableObject("_root.HealthBlock.VehicleN");
	VArmorBar       = GetVariableObject("_root.HealthBlock.HealthVehicle");
	VehicleMC       = GetVariableObject("_root.WeaponBlock.VehicleIcon");
	VAltWeaponBlock = GetVariableObject("_root.WeaponBlock.AltWeaponBlock");
	VBackdrop       = GetVariableObject("_root.WeaponBlock.VehicleBackdrop");

	//Stamina
	StaminaBar      = GetVariableObject("_root.HealthBlock.Stamina");

	//Weapon and Ammo
	WeaponBlock     = GetVariableObject("_root.WeaponBlock");
	WeaponName      = GetVariableObject("_root.WeaponBlock.WeaponName");
	AmmoInClipN     = GetVariableObject("_root.WeaponBlock.AmmoInClipN");
	AmmoReserveN    = GetVariableObject("_root.WeaponBlock.AmmoReserveN");
	InfinitAmmo     = GetVariableObject("_root.WeaponBlock.Infinity");
	AmmoBar         = GetVariableObject("_root.WeaponBlock.Ammo");
	WeaponMC        = GetVariableObject("_root.WeaponBlock.Weapon");
	WeaponPrevMC    = GetVariableObject("_root.WeaponBlock.WeaponPrev");
	WeaponNextMC    = GetVariableObject("_root.WeaponBlock.WeaponNext");


	AltWeaponName   = GetVariableObject("_root.WeaponBlock.AltWeaponBlock.AltWeaponName");
	AltAmmoInClipN  = GetVariableObject("_root.WeaponBlock.AltWeaponBlock.AltAmmoInClipN");
	AltInfinitAmmo  = GetVariableObject("_root.WeaponBlock.AltWeaponBlock.AltInfinity");
	AltAmmoBar      = GetVariableObject("_root.WeaponBlock.AltWeaponBlock.AltAmmo");

	//Abilities
	AbilityMC       = GetVariableObject("_root.WeaponBlock.Ability");
	AbilityMeterMC  = GetVariableObject("_root.WeaponBlock.Ability.Meter");
	AbilityIconMC   = GetVariableObject("_root.WeaponBlock.Ability.Icon");

	//Items
	GrenadeMC       = GetVariableObject("_root.WeaponBlock.Grenade");
	GrenadeN        = GetVariableObject("_root.WeaponBlock.Grenade.Icon.TextField");
	TimedC4MC       = GetVariableObject("_root.WeaponBlock.TimedC4");
	RemoteC4MC      = GetVariableObject("_root.WeaponBlock.RemoteC4");
	ProxyC4MC       = GetVariableObject("_root.WeaponBlock.ProxyC4");
	BeaconMC        = GetVariableObject("_root.WeaponBlock.Beacon");

	//Gameplay Info
	BottomInfo      = GetVariableObject("_root.BottomInfo");
	Credits         = GetVariableObject("_root.BottomInfo.Stats.Credits");
	MatchTimer      = GetVariableObject("_root.BottomInfo.Stats.Time");
	VehicleCount    = GetVariableObject("_root.BottomInfo.Stats.Vehicles");
	MineCount    	= GetVariableObject("_root.BottomInfo.Stats.Mines");

	//Progress Bar
	
		LoadingMeterMC[0] = GetVariableObject("_root.loadingMeterGDI");
		LoadingText[0] = GetVariableObject("_root.loadingMeterGDI.loadingText");
		LoadingBarWidget[0] = GFxClikWidget(GetVariableObject("_root.loadingMeterGDI.bar", class'GFxClikWidget'));
		LoadingMeterMC[1] = GetVariableObject("_root.loadingMeterNod");
		LoadingText[1] = GetVariableObject("_root.loadingMeterNod.loadingText");
		LoadingBarWidget[1] = GFxClikWidget(GetVariableObject("_root.loadingMeterNod.bar", class'GFxClikWidget'));

	HideLoadingBar();
//---------------------------------------------------
	//Radar implementation
	if (AGNMinimap == none)
	{
		AGNMinimap = AGN_GFxMinimap(GetVariableObject("_root.minimap", class'AGN_GFxMinimap'));
		AGNMinimap.init(self);
	}

	if (Marker == none) {
		Marker = Rx_GFxMarker(GetVariableObject("_root.MarkerContainer", class'Rx_GFxMarker'));
		Marker.init(self);
	}
	if(GrenadeN != None)
		GrenadeN.SetText("0X");
	if(GrenadeMC != None)
		GrenadeMC.GotoAndStopI(2);
	if(TimedC4MC != None)
		TimedC4MC.GotoAndStopI(2);
	if(RemoteC4MC != None)
		RemoteC4MC.GotoAndStopI(2);
	if(ProxyC4MC != None)
		ProxyC4MC.GotoAndStopI(2);
	HideBuildingIcons();
}

exec function SetLivingHUDVisible(bool visible)
{
	//ObjectiveMC.SetVisible(visible);
	AGNMinimap.SetVisible(visible);
	Marker.SetVisible(visible);
	HealthBlock.SetVisible(visible);
	BottomInfo.SetVisible(visible);
	WeaponBlock.SetVisible(visible);
}

function TickHUD() 
{
	local Rx_Pawn RxP;
	local Pawn TempPawn;
	local Rx_Weapon RxWeap;
	local Rx_WeaponAbility RxAbility; //Always updated on the HUD as opposed to a regular weapon 
	local Rx_Vehicle RxV;
	local Rx_Vehicle_Weapon RxVWeap;
	local UTPlayerController RxPC;
	local Rx_GRI RxGRI;
	local byte i;
	local string FullVPString; 
	
	if (!bMovieIsOpen) {
		return;
	}
	
	RxPC = UTPlayerController(GetPC());
	
	if(RxPC == None) {
		return;
	}
	
	/**
	Tick Cycle 
	0: Vehicles/Vehicle Weapons
	1: Infantry Health/Ammo/Weapons
	2: Update Map
	*/
	
	if(bUseTickCycle && Tick_Cycler >= SkipNum)
	{
		Tick_Cycler=0;
		return;
	}
	else
	if(bUseTickCycle) Tick_Cycler+=1;
	
	if(RxPC.Pawn != None)
		TempPawn = RxPC.Pawn;
	else if(Pawn(RxPC.viewtarget) != None)
		TempPawn = Pawn(RxPC.viewtarget);		

	//assign all 4 var here. RxP RxV, RxWeap, RxVehicleWeap
	
		if (Rx_Pawn(TempPawn) != none) {
			RxP = Rx_Pawn(TempPawn);
			RxWeap = Rx_Weapon(RxP.Weapon);
			if(RxP.InvManager != none) RxAbility = Rx_InventoryManager(RxP.InvManager).GetIndexedAbility(0);
			RxV = none;
			RxVWeap = none;
		} else if (Rx_Vehicle(TempPawn) != none) {
			RxV = Rx_Vehicle(TempPawn);
			if (RxV.Weapon != none) {
				RxVWeap = Rx_Vehicle_Weapon(RxV.Weapon);
			} else {
				for (i = 0; i < RxV.Seats.Length; i++) {
					if (RxV.Seats[i].Gun == none) {
						continue;
					}
					RxVWeap = Rx_Vehicle_Weapon(RxV.Seats[i].Gun);
					break;
				}
			}
			RxP = none;
			RxWeap = none;
		} else if (Rx_VehicleSeatPawn(TempPawn) != None) {
			RxV = Rx_Vehicle(Rx_VehicleSeatPawn(TempPawn).MyVehicle);
			
			if (Rx_VehicleSeatPawn(TempPawn).MyVehicleWeapon != none) {
				RxVWeap = Rx_Vehicle_Weapon(Rx_VehicleSeatPawn(TempPawn).MyVehicleWeapon);
			} else if (RxV.Weapon != none) {
				RxVWeap = Rx_Vehicle_Weapon(RxV.Weapon);
			} else {
				for (i = 0; i < RxV.Seats.Length; i++) {
					if (RxV.Seats[i].Gun == none) {
						lastWeaponHeld = none; 
						continue;
					}
					RxVWeap = Rx_Vehicle_Weapon(RxV.Seats[i].Gun);
					break;
				}
			}
			RxP = none;
			RxWeap = none;
		}
	
				
// 		//UTWeaponPawn
// 	if(Rx_Pawn(RxPC.Pawn) != None) {
// 		RxP = Rx_Pawn(RxPC.Pawn);
// 	} else if(Rx_VehicleSeatPawn(RxPC.Pawn) != None) {
// 		RxV = Rx_Vehicle(Rx_VehicleSeatPawn(RxPC.Pawn).MyVehicle);
// 	} 
// // 	else if (UTWeaponPawn(RxPC.Pawn) != None) { //TODO: for Chinook who happens not have 
// // 		RxV = Rx_Vehicle(UTWeaponPawn(RxPC.Pawn).MyVehicle);
// // 	}
// 	else {
// 		RxV = Rx_Vehicle(RxPC.Pawn);
// 	}
	
	if((bUseTickCycle && Tick_Cycler == 1) || !bUseTickCycle)
	{
		SetLivingHUDVisible(true);
		if(RxP != none && RxP.Health > 0) {
			if (VehicleDeathMsgTime >= 0)
			{
				if (RenxHud.WorldInfo.TimeSeconds < VehicleDeathMsgTime)
				{
					FadeScreenMC.SetVisible(true);
					SubtitlesText.SetVisible(true);
				}
				else
				{
					VehicleDeathMsgTime = -1;
					SubtitlesText.SetText("");
					SubtitlesText.SetVisible(false);
					FadeScreenMC.SetVisible(false);
				}
			}
			else
			{
				SubtitlesText.SetText("");
				SubtitlesText.SetVisible(false);
				FadeScreenMC.SetVisible(false);
			}
			if(isInVehicle) //they were in a vehicle
			{

				HealthBlock.GotoAndStopI(2);
				WeaponBlock.GotoAndStopI(2);
				VArmorN.SetVisible(false);
				VArmorMaxN.SetVisible(false);
				isInVehicle = false;
			}
			
			UpdateHealth(RxP.Health , RxP.HealthMax);
			UpdateArmor(RxP.Armor , RxP.ArmorMax);
			//UpdateAbility(); 
			//updates that only happen on foot
			UpdateStamina(RxP.Stamina);
			//UpdateItems();
			if(RxWeap != None) 
			{
				UpdateWeapon(RxWeap);
			}
			
			if (RxAbility != none) {
				ShowAbility(true); //Make sure it's visible 
				UpdateAbility(RxAbility);
				}
				else
				ShowAbility(false); 

			//hide respawn hud (nBab)
			hideRespawnHud();
		} else if(RxV != none) {
			if (VehicleDeathMsgTime >= 0)
			{ 
				if (RenxHud.WorldInfo.TimeSeconds < VehicleDeathMsgTime)
				{
					FadeScreenMC.SetVisible(true);
					SubtitlesText.SetVisible(true);
				}
				else
				{
					VehicleDeathMsgTime = -1;
					SubtitlesText.SetText("");
					SubtitlesText.SetVisible(false);
					FadeScreenMC.SetVisible(false);
				}
			}
			else
			{
				SubtitlesText.SetText("");
				SubtitlesText.SetVisible(false);
				FadeScreenMC.SetVisible(false);
			}
			if(!isInVehicle) //they were on foot
			{
				HealthBlock.GotoAndStopI(3);
				WeaponBlock.GotoAndStopI(3);
				UpdateHUDVars();
				VArmorN.SetVisible(true);
				VArmorMaxN.SetVisible(true);
				VArmorMaxN.SetText(RxV.HealthMax);

				//show last pawn health when in vehicle (nBab)
				VHealthN.SetText(LastHealthpc);
				ArmorN.SetText(LastArmorpc);
				
				isInVehicle = true;
			}
				
	// 		if(Rx_VehicleSeatPawn(RxPC.Pawn) != None)
	// 			RxP = Rx_Pawn(Rx_VehicleSeatPawn(RxPC.Pawn).Driver);
	// 		else
	// 			RxP = Rx_Pawn(RxV.Driver);

			//updates that only happen in vehicle
			//`log(vehiclePawn.Health);
			UpdateVehicleArmor(RxV.Health, RxV.HealthMax);
			UpdateVehicleWeapon(RxVWeap);
			if ((Rx_Vehicle_Chinook_GDI(RxV) != none || Rx_Vehicle_Chinook_Nod(RxV) != none) && RxV.Seats[RxV.GetSeatIndexForController(RxPC)].Gun == none) {
				AmmoInClipN.SetText("0");
				AmmoBar.GotoAndStopI(0);
				lastWeaponHeld = none; //And somehow this not being here screwed up the entire HUD... Eh, whatever. -Yosh
			}
			
			
	// 		if (Rx_VehicleSeatPawn(RxPC.Pawn) != none) {
	// 			//if the passenger has its own weapon system (like chinook), then use it
	// 			//else just use the passenger's vehicle default weapon system
	// 			if (Rx_Vehicle_Weapon(Rx_VehicleSeatPawn(RxPC.Pawn).MyVehicleWeapon) != none) {
	// 				UpdateVehicleWeapon(Rx_Vehicle_Weapon(Rx_VehicleSeatPawn(RxPC.Pawn).MyVehicleWeapon));
	// 			} else {
	// 				UpdateVehicleWeapon(Rx_Vehicle_Weapon(Rx_VehicleSeatPawn(RxPC.Pawn).MyVehicle.Weapon));
	// 			}
	// 		} else if (Rx_Vehicle_Chinook_GDI(RxPC.Pawn) != none || Rx_Vehicle_Chinook_Nod(RxPC.Pawn) != none) {
	// 			//VehicleIcon
	// 			VehicleMC.GotoAndStopI(6);
	// 			VBackdrop.GotoAndStopI(1);
	// 			//AmmoBar.SetVisible(false);
	// 			//InfinitAmmo.SetVisible(true);
	// 			AmmoInClipN.SetText("0");
	// 			WeaponName.SetText(RxV.GetHumanReadableName());
	// 			//WeaponBlock.GetObject("AltWeaponBlock").SetVisible(false);
	// 			//UpdateHUDVars();
	// 			lastWeaponHeld = none;
	// 
	// 		} else {
	// 			UpdateVehicleWeapon(Rx_Vehicle_Weapon(RxV.Weapon));
	// 		}
			//hide respawn hud (nBab)
			hideRespawnHud();
		} else {
			SetLivingHUDVisible(false);
			FadeScreenMC.SetVisible(true);
			SubtitlesText.SetVisible(true);
			UpdateHealth(0 , 100);
			UpdateArmor(0 , 100);
			VehicleDeathMsgTime = -1;
			//show respawn hud (nBab)
			showRespawnhud(GetPC().GetTeamNum(),lastFreeClass);
		}
	}

// 	UpdateHealth((RxP == none || RxP.Health <= 0) ? 0 : RxP.Health, RxP.HealthMax);
// 	UpdateArmor((RxP == none || RxP.Armor <= 0) ? 0 : RxP.Health, RxP.ArmorMax);
	if((bUseTickCycle && Tick_Cycler == 2) || !bUseTickCycle)
	{
		if ( AGNMinimap != None )
		{
			RxPC = UTPlayerController(GetPC());
			RxGRI = Rx_GRI(RxPC.WorldInfo.GRI);

			if(RxGRI != None && !RxGRI.bMatchIsOver)
				AGNMinimap.Update();
		}

		if (Marker != none) {
			RxGRI = Rx_GRI(RxPC.WorldInfo.GRI);

			if(RxGRI != None && !RxGRI.bMatchIsOver) {
				Marker.Update();	
			}
		}
	}
	if (RxPC.WorldInfo != none && RxPC.WorldInfo.GRI !=none)
	{
		if (RxPC.WorldInfo.GRI.TimeLimit > 0)
			UpdateMatchTimer(RxPC.WorldInfo.GRI.RemainingTime);
		else
			UpdateMatchTimer(RxPC.WorldInfo.GRI.ElapsedTime);

	}

	if (Rx_PRI(RxPC.PlayerReplicationInfo) != none)
	{
		UpdateCredits(Rx_PRI(RxPC.PlayerReplicationInfo).GetCredits());
		if(RxPC.PlayerReplicationInfo.Team != None) 
		{
			UpdateVehicleCount(Rx_TeamInfo(RxPC.PlayerReplicationInfo.Team).GetVehicleCount(),Rx_TeamInfo(RxPC.PlayerReplicationInfo.Team).VehicleLimit);
			UpdateMineCount(Rx_TeamInfo(RxPC.PlayerReplicationInfo.Team).MineCount,Rx_TeamInfo(RxPC.PlayerReplicationInfo.Team).mineLimit);
		}
	}

		if (AGNMinimap != none)
		{
			RxGRI = Rx_GRI(RxPC.WorldInfo.GRI);

			if(RxGRI != None && !RxGRI.bMatchIsOver) {
				AGNMinimap.UpdateMap();	
				
			}
		}
	
	//Bug fix for 16:10 resolution: The below code wasn't run at the start of the match because
	//there was no TempPawn thus the hud was not resized properly.
	//fixed it by calling "ResizedScreenCheck()" from rx_controller during the start of the match. (nBab)

	/** Code that was found to be expensive and doesent need to be updated every Tick was moved here */
	if(TempPawn != None && TempPawn.WorldInfo.TimeSeconds - LastTipsUpdateTime > 0.15)
	{
		ResizedScreenCheck();
		UpdateBuildings();
		UpdateTips();
		LastTipsUpdateTime = TempPawn.WorldInfo.TimeSeconds;
		//UpdateScoreboard();
	} else if(GameplayTipsText.GetString("htmlText") != "")
	{
		FadeScreenMC.SetVisible(true);
		GameplayTipsText.SetVisible(true);
	}	
	
	//Expirimental VP Stuff 
	if(Subtitle_Messages.Length > 0 && RxPC != none) 
		{
			for(i=0;i<Min(Subtitle_Messages.Length,6);i++)
			{
			if(i>0) FullVPString = FullVPString$"<br>"$Subtitle_Messages[i];
			else
			FullVPString = Subtitle_Messages[0]; 
			}
				SubtitlesText.SetString("htmlText", FullVPString);
				SubtitlesText.SetVisible(true);
				FadeScreenMC.SetVisible(true);
		}
		
		if(Subtitle_Messages.Length > 0) 
		{
			VPMsg_Cycler-=0.5 ; 
			
			if(VPMsg_Cycler <= 0.0) 
			{
				Subtitle_Messages.Remove(0,1); 
				VPMsg_Cycler=default.VPMsg_Cycler;
			}
		}
	//End Expirement 

	//set up tech building icons (nBab)
	if (SetupTechIcons)
	{
		setupTechBuildingIcons();
		SetupTechIcons = false;
	}
	
	if((bUseTickCycle && Tick_Cycler == 2) || !bUseTickCycle ) //Things that don't need to be updated that regularly
	{
	//update tech building icons (nBab)
	updateTechBuildingIcons();

	//update veterancy (nBab)
	updateVeterancy();
	}
	//update respawn ui
	if (GetPC().GetTeamNum() != lastTeam)
	{
		updateRespawnUI(GetPC().GetTeamNum());
		lastTeam = GetPC().GetTeamNum();
	}
}

function UpdateWeapon(UTWeapon Weapon)
{
    local Rx_Controller rxPC;

    // End:0x4A1
    if(Weapon != lastWeaponHeld)
    {
        AmmoInClipValue = -1;
        AmmoInReserveValue = -1;
        UpdateHUDVars();
        WeaponName.SetText(class'AGN_UtilitiesX'.static.GetWeaponNameIncludingCustomWeapons(Weapon));
        if(Rx_Weapon(Weapon).HasInfiniteAmmo())
        {
            AmmoReserveN.SetVisible(false);
            InfinitAmmo.SetVisible(true);
        }
        else
        {
            AmmoReserveN.SetVisible(true);
            InfinitAmmo.SetVisible(false);
        }
        rxPC = Rx_Controller(GetPC());
        PrevWeapon = rxPC.GetPrevWeapon(Weapon);
        NextWeapon = rxPC.GetNextWeapon(Weapon);
        if(lastWeaponHeld == PrevWeapon)
        {
            ChangedWeapon("switchedToNextWeapon");
        }
        else
        {
            ChangedWeapon("switchedToPrevWeapon");
        }
        lastWeaponHeld = Weapon;
        LoadTexture(((Rx_Weapon(Weapon).WeaponIconTexture != none) ? "img://" $ PathName(Rx_Weapon(Weapon).WeaponIconTexture) : PathName(texture2d'T_WeaponIcon_MissingCameo')), WeaponMC);
        if((PrevWeapon != none) && Rx_Weapon(PrevWeapon) != none)
        {
            WeaponPrevMC.SetVisible(true);
            LoadTexture(((Rx_Weapon(PrevWeapon).WeaponIconTexture != none) ? "img://" $ PathName(Rx_Weapon(PrevWeapon).WeaponIconTexture) : PathName(texture2d'T_WeaponIcon_MissingCameo')), WeaponPrevMC);
        }
        else
        {
            WeaponPrevMC.SetVisible(false);
        }
        if((NextWeapon != none) && Rx_Weapon(PrevWeapon) != none)
        {
            WeaponNextMC.SetVisible(true);
            LoadTexture(((Rx_Weapon(NextWeapon).WeaponIconTexture != none) ? "img://" $ PathName(Rx_Weapon(NextWeapon).WeaponIconTexture) : PathName(texture2d'T_WeaponIcon_MissingCameo')), WeaponNextMC);
        }
        else
        {
            WeaponNextMC.SetVisible(false);
        }
    }
    if(Rx_Weapon_Reloadable(Weapon) != none)
    {
        if(AmmoInClipValue != Rx_Weapon_Reloadable(Weapon).GetUseableAmmo())
        {
            AmmoInClipValue = Rx_Weapon_Reloadable(Weapon).GetUseableAmmo();
            AmmoInClipN.SetText(string(AmmoInClipValue));
            AmmoBar.GotoAndStopI(int((float(AmmoInClipValue) / float(Rx_Weapon_Reloadable(Weapon).GetMaxAmmoInClip())) * float(100)));
        }
        if(AmmoInReserveValue != Rx_Weapon_Reloadable(Weapon).GetReserveAmmo())
        {
            AmmoInReserveValue = Rx_Weapon_Reloadable(Weapon).GetReserveAmmo();
            AmmoReserveN.SetText(string(AmmoInReserveValue));
        }
        if(((Rx_Weapon_Reloadable(Weapon) != none) && Rx_Weapon_Reloadable(Weapon).CurrentlyReloading) && !Rx_Weapon_Reloadable(Weapon).PerBulletReload)
        {
            AnimateReload(Weapon.WorldInfo.TimeSeconds - Rx_Weapon_Reloadable(Weapon).reloadBeginTime, Rx_Weapon_Reloadable(Weapon).currentReloadTime, AmmoBar);
        }
    }
}