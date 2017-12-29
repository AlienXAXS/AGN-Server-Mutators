class AGN_Rx_Controller extends Rx_Controller;

var class<Rx_GFxPurchaseMenu> PTMenuClassOriginal;

exec function ReportSpotted()
{
    local Rx_Building Building;
    local Rx_Bot Bot;
    local string BuildingName;
    local Actor PrimarySpot;
    local string RMSG, CMSG;
    local int nr;
    local byte UIS;

    // End:0x2B
    if(IsTimerActive('QHeldTimer'))
    {
        ClearTimer('QHeldTimer');
    }
    // End:0xE1
    if((((Com_Menu != none) && Com_Menu.MenuTab != none) && Com_Menu.MenuTab.bQCast) && !bQHeld)
    {
        Com_Menu.MenuTab.QCast(false);
        return;
    }
    bQHeld = false;
    ClearTimer('ReportSpotted');
    // End:0x161
    if(IsTimerActive('ClearFocusWaitTimer') && bCanFocusSpot)
    {
        SetTimer(GetTimerRate('ClearFocusWaitTimer') - GetTimerCount('ClearFocusWaitTimer'), false, 'ReportSpotted');
        return;
    }
    bSpotting = false;
    // End:0x188
    if(spotMessagesBlocked)
    {
        bCanFocusSpot = false;
        return;
    }
    nr = -1;
    // End:0x1372
    if((Rx_HUD(myHUD) != none) && Rx_HUD(myHUD).SpotTargets.Length > 0)
    {
        PrimarySpot = Rx_HUD(myHUD).SpotTargets[0];
        // End:0x249
        if((PrimarySpot == none) || Rx_DestroyableObstaclePlus(PrimarySpot) != none)
        {
            bCanFocusSpot = false;
            return;
        }
        // End:0x2B2
        if((AGN_CratePickup(PrimarySpot) != none) && ++ numberOfRadioCommandsLastXSeconds < 5)
        {
            BroadCastSpotMessage(11, "CRATE SPOTTED:" @ (GetSpottargetLocationInfo(AGN_CratePickup(PrimarySpot))));
        }
        // End:0x1334
        else
        {
            // End:0x34E
            if(Rx_Building(Rx_HUD(myHUD).SpotTargets[0]) != none)
            {
                // End:0x34B
                if(++ numberOfRadioCommandsLastXSeconds < 5)
                {
                    Building = Rx_Building(Rx_HUD(myHUD).SpotTargets[0]);
                    BroadcastBuildingSpotMessages(Building);
                }
            }
            // End:0x1334
            else
            {
                // End:0x478
                if(Rx_Defence(PrimarySpot) != none)
                {
                    // End:0x475
                    if(++ numberOfRadioCommandsLastXSeconds < 5)
                    {
                        BroadcastBaseDefenseSpotMessages(Rx_Defence(PrimarySpot));
                        // End:0x475
                        if(Rx_DefencePRI(Rx_Defence(PrimarySpot).PlayerReplicationInfo) != none)
                        {
                            SetPlayerSpotted(Rx_DefencePRI(Rx_Defence(PrimarySpot).PlayerReplicationInfo).Defence_ID);
                            // End:0x475
                            if(bCommandSpotting)
                            {
                                SetPlayerCommandSpotted(Rx_DefencePRI(Rx_Defence(PrimarySpot).PlayerReplicationInfo).Defence_ID);
                            }
                        }
                    }
                }
                // End:0x1334
                else
                {
                    // End:0x564
                    if(Rx_Weapon_DeployedBeacon(PrimarySpot) != none)
                    {
                        // End:0x561
                        if(++ numberOfRadioCommandsLastXSeconds < 5)
                        {
                            // End:0x517
                            if(PrimarySpot.GetTeamNum() == GetTeamNum())
                            {
                                BroadCastSpotMessage(15, ("Defend BEACON" @ (GetSpottargetLocationInfo(Rx_Weapon_DeployedBeacon(PrimarySpot)))) @ "!!!");
                            }
                            // End:0x561
                            else
                            {
                                BroadCastSpotMessage(-1, ("Spotted ENEMY BEACON" @ (GetSpottargetLocationInfo(Rx_Weapon_DeployedBeacon(PrimarySpot)))) @ "!!!");
                            }
                        }
                    }
                    // End:0x1334
                    else
                    {
                        // End:0x71C
                        if(Rx_Weapon_DeployedC4(PrimarySpot) != none)
                        {
                            // End:0x719
                            if(++ numberOfRadioCommandsLastXSeconds < 5)
                            {
                                BuildingName = Rx_Weapon_DeployedC4(PrimarySpot).ImpactedActor.GetHumanReadableName();
                                // End:0x719
                                if((BuildingName == "MCT") || Rx_Building(Rx_Weapon_DeployedC4(PrimarySpot).ImpactedActor) != none)
                                {
                                    // End:0x660
                                    if(BuildingName == "MCT")
                                    {
                                        BuildingName = "MCT" @ (GetSpottargetLocationInfo(Rx_Weapon_DeployedC4(PrimarySpot)));
                                    }
                                    // End:0x6D2
                                    if(PrimarySpot.GetTeamNum() == GetTeamNum())
                                    {
                                        BroadCastSpotMessage(15, ("Defend &gt;&gt;C4&lt;&lt; at " @ BuildingName) @ "!!!");
                                    }
                                    // End:0x719
                                    else
                                    {
                                        BroadCastSpotMessage(-1, ("Spotted ENEMY &gt;&gt;C4&lt;&lt; at " @ BuildingName) @ "!!!");
                                    }
                                }
                            }
                        }
                        // End:0x1334
                        else
                        {
                            // End:0x8ED
                            if(Rx_Vehicle_Harvester(PrimarySpot) != none)
                            {
                                // End:0x8DC
                                if(++ numberOfRadioCommandsLastXSeconds < 5)
                                {
                                    // End:0x787
                                    if(PrimarySpot.GetTeamNum() == GetTeamNum())
                                    {
                                        RadioCommand(26);
                                    }
                                    // End:0x8DC
                                    else
                                    {
                                        RadioCommand(21);
                                        // End:0x874
                                        if(Rx_DefencePRI(Rx_Vehicle_Harvester(PrimarySpot).PlayerReplicationInfo) != none)
                                        {
                                            SetPlayerSpotted(Rx_DefencePRI(Rx_Vehicle_Harvester(PrimarySpot).PlayerReplicationInfo).Defence_ID);
                                            // End:0x874
                                            if(bCommandSpotting)
                                            {
                                                SetPlayerCommandSpotted(Rx_DefencePRI(Rx_Vehicle_Harvester(PrimarySpot).PlayerReplicationInfo).Defence_ID);
                                            }
                                        }
                                        // End:0x8D0
                                        if(bFocusSpotting)
                                        {
                                            SetPlayerFocused(Rx_DefencePRI(Rx_Vehicle_Harvester(PrimarySpot).PlayerReplicationInfo).Defence_ID);
                                        }
                                        bFocusSpotting = false;
                                    }
                                }
                                bCanFocusSpot = false;
                                return;
                            }
                            // End:0x1334
                            else
                            {
                                // End:0x132A
                                if(Pawn(PrimarySpot).GetTeamNum() == GetTeamNum())
                                {
                                    Bot = Rx_Bot(Pawn(PrimarySpot).Controller);
                                    // End:0xBB0
                                    if(Bot != none)
                                    {
                                        // End:0xB03
                                        if(((Bot.Squad != none) && Rx_SquadAI(Bot.Squad).SquadLeader == self) && Bot.GetOrders() == 'Follow')
                                        {
                                            UTTeamInfo(Bot.Squad.Team).AI.SetBotOrders(Bot);
                                            BroadCastSpotMessage(17, "Stop following me" @ Pawn(PrimarySpot).Controller.GetHumanReadableName());
                                            RespondingBot = Bot;
                                            SetTimer(0.50 + FRand(), false, 'BotSayAffirmativeToplayer');
                                        }
                                        // End:0xBAD
                                        else
                                        {
                                            Bot.SetBotOrders('Follow', self, true);
                                            BroadCastSpotMessage(13, "Follow me" @ Pawn(PrimarySpot).Controller.GetHumanReadableName());
                                            RespondingBot = Bot;
                                            SetTimer(0.50 + FRand(), false, 'BotSayAffirmativeToplayer');
                                        }
                                    }
                                    // End:0x1327
                                    else
                                    {
                                        // End:0xFF5
                                        if(((++ numberOfRadioCommandsLastXSeconds < 5) && Rx_Pawn(PrimarySpot) != none) && Rx_Pawn(PrimarySpot).PlayerReplicationInfo != none)
                                        {
                                            // End:0xD23
                                            if(((Rx_Pawn(Pawn) != none) && float(Rx_Pawn(Pawn).Armor) <= (float(Rx_Pawn(Pawn).ArmorMax) / 1.50)) && Rx_Pawn(PrimarySpot).IsHealer())
                                            {
                                                nr = 10;
                                                RMSG = PlayerReplicationInfo.PlayerName @ "Needs Repairs";
                                                CMSG = "-Requested Repairs-";
                                                UIS = 1;
                                            }
                                            // End:0xFF2
                                            else
                                            {
                                                // End:0xDBF
                                                if(Rx_Weapon_Beacon(Pawn.Weapon) != none)
                                                {
                                                    nr = 15;
                                                    RMSG = PlayerReplicationInfo.PlayerName @ "Needs Cover";
                                                    CMSG = "-Requested Cover-";
                                                    UIS = 3;
                                                }
                                                // End:0xFF2
                                                else
                                                {
                                                    // End:0xED7
                                                    if(((Rx_Vehicle(Pawn) != none) && float(Rx_Vehicle(Pawn).Health) <= (float(Rx_Vehicle(Pawn).HealthMax) * 0.850)) && Rx_Pawn(PrimarySpot).IsHealer())
                                                    {
                                                        nr = 10;
                                                        RMSG = PlayerReplicationInfo.PlayerName @ "Needs Repairs";
                                                        CMSG = "-Requested Repairs-";
                                                        UIS = 1;
                                                    }
                                                    // End:0xFF2
                                                    else
                                                    {
                                                        // End:0xF85
                                                        if((Rx_Vehicle(Pawn) != none) && Rx_Pawn(PrimarySpot) != none)
                                                        {
                                                            nr = 1;
                                                            RMSG = PlayerReplicationInfo.PlayerName @ ": Requested Passenger";
                                                            CMSG = "-Requested Passenger-";
                                                            UIS = 2;
                                                        }
                                                        // End:0xFF2
                                                        else
                                                        {
                                                            nr = 13;
                                                            RMSG = PlayerReplicationInfo.PlayerName @ ": Follow Me";
                                                            CMSG = "-Requested Follow-";
                                                            UIS = 2;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        // End:0x1230
                                        else
                                        {
                                            // End:0x1230
                                            if(((++ numberOfRadioCommandsLastXSeconds < 5) && Rx_Vehicle(PrimarySpot) != none) && Rx_Vehicle(PrimarySpot).PlayerReplicationInfo != none)
                                            {
                                                // End:0x10F3
                                                if(Rx_Weapon_Beacon(Pawn.Weapon) != none)
                                                {
                                                    nr = 15;
                                                    RMSG = PlayerReplicationInfo.PlayerName @ "needs beacon cover";
                                                    CMSG = "-Requested Cover-";
                                                    UIS = 3;
                                                }
                                                // End:0x1230
                                                else
                                                {
                                                    // End:0x11AB
                                                    if((Pawn(PrimarySpot).PlayerReplicationInfo != none) && Rx_Vehicle(Pawn) == none)
                                                    {
                                                        nr = 14;
                                                        RMSG = PlayerReplicationInfo.PlayerName @ "needs a ride";
                                                        CMSG = "-Requested a Ride-";
                                                        UIS = 2;
                                                    }
                                                    // End:0x1230
                                                    else
                                                    {
                                                        // End:0x1230
                                                        if(Rx_Vehicle(Pawn) != none)
                                                        {
                                                            nr = 13;
                                                            RMSG = PlayerReplicationInfo.PlayerName @ ": Follow Me";
                                                            CMSG = "-Requested Follow-";
                                                            UIS = 2;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        // End:0x1327
                                        if((Pawn(PrimarySpot) != none) && nr > -1)
                                        {
                                            ++ numberOfRadioCommandsLastXSeconds;
                                            WhisperSpotMessage(Pawn(PrimarySpot).PlayerReplicationInfo.PlayerID, nr, RMSG, UIS);
                                            CTextMessage(CMSG, 'Green', 30.0);
                                            ClientPlaySound(RadioCommands[nr]);
                                            spotMessagesBlocked = true;
                                            SetTimer(1.50, false, 'resetSpotMessageCountTimer');
                                        }
                                    }
                                }
                                // End:0x1334
                                else
                                {
                                    BroadcastEnemySpotMessages();
                                }
                            }
                        }
                    }
                }
            }
        }
        // End:0x135F
        if(IsTimerActive('RemoveSpotTargets'))
        {
            ClearTimer('RemoveSpotTargets');
        }
        SetTimer(10.0, false, 'RemoveSpotTargets');
    }
    bCanFocusSpot = false;
    bFocusSpotting = false;
    //return;    
}

// Beacon Overwrite
reliable server function ServerSetItem(class<Rx_Weapon> classname)
{
	local Rx_InventoryManager invmngr;
	local array<class<Rx_Weapon> > wclasses;
	
	if ( classname.class.Name == 'Rx_Weapon_IonCannonBeacon' )
		classname = class'AGN_Mut_AlienXSystem.AGN_Weapon_IonCannonBeacon';
	if ( classname.class.Name == 'Rx_Weapon_NukeBeacon' )
		classname = class'AGN_Mut_AlienXSystem.AGN_Weapon_NukeBeacon';
	
	invmngr = Rx_InventoryManager(Pawn.InvManager);
	if (invmngr == none) return;

	if (!invmngr.IsItemAllowed(classname)) return;
	wclasses = invmngr.GetWeaponsOfClassification(CLASS_ITEM);
	if (invmngr.GetItemSlots() == wclasses.Length)
		invmngr.RemoveWeaponOfClass(wclasses[wclasses.Length - 1]);

	// add requested weapon
	invmngr.AddWeaponOfClass(classname, CLASS_ITEM);
}

function OpenPT(Rx_BuildingAttachment_PT PT)
{
	local string mapName;

	if( PTMenu == none || !PTMenu.bMovieIsOpen)
	{
		Rx_HUD(myHUD).CloseOverviewMap();

		// AlienX
		// Use original PT on Flying maps!
		mapname=WorldInfo.GetmapName();		
		`log ( "[AGN-MAP-FINDER] Found map " $ mapname);
		if(right(mapname, 6) ~= "_NIGHT") mapname = Left(mapname, Len(mapname)-6);   	
		if(right(mapname, 4) ~= "_DAY") mapname = Left(mapname, Len(mapname)-4);

		if ( mapname ~= "Walls" || mapname ~= "Lakeside" || mapname ~= "Whiteout" )
		{
			`log("[AGN-PT] LOADING ORIGINAL PURCHASE TERMINAL");
			Rx_HUD(myHUD).PTMovie = new PTMenuClassOriginal;
		} else {
			`log("[AGN-PT] LOADING FORT PURCHASE TERMINAL");
			Rx_HUD(myHUD).PTMovie = new PTMenuClass;
		}

		PTMenu = Rx_HUD(myHUD).PTMovie;
		PTMenu.SetPurchaseSystem( (WorldInfo.NetMode == NM_StandAlone || (WorldInfo.NetMode == NM_ListenServer && RemoteRole == ROLE_SimulatedProxy) ) 
			? Rx_Game(WorldInfo.Game).PurchaseSystem 
			: Rx_GRI(WorldInfo.GRI).PurchaseSystem );

		PTMenu.SetTeam(PT.GetTeamNum());
		PTMenu.SetTimingMode(TM_Real);
		PTMenu.Initialize(LocalPlayer(Player), PT);
	}
	PTUsed = PT;
}

DefaultProperties
{
	PTMenuClass = class'AGN_Veh_GFxPurchaseMenu'
	PTMenuClassOriginal	= class'Rx_GFxPurchaseMenu'
}