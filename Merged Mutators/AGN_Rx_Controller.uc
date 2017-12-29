class AGN_Rx_Controller extends Rx_Controller;

var class<Rx_GFxPurchaseMenu> PTMenuClassOriginal;

exec function ReportSpotted()
{
	local Rx_Building Building;
	local Rx_Bot bot;
	local string BuildingName;
	local Actor PrimarySpot; 
	local string RMSG, CMSG; //Remote message, and Client Message  
	local int	nr; 
	local byte UIS; 
	
	ClearTimer('ReportSpotted'); 
	if(bCommandSpotting) 
	{
	ProcessCommandSpot(); 
	ClearCommandSpotWaitTime();
	return;
	}
	
	if(isTimerActive('ClearFocusWaitTimer') && bCanFocusSpot) 
	{
	SetTimer((GetTimerRate('ClearFocusWaitTimer') - GetTimerCount('ClearFocusWaitTimer')), false, 'ReportSpotted');	
	return; 	
	}
	
	bSpotting = false;  
	if(spotMessagesBlocked) // && !bFocusSpotting)
	{
	bCanFocusSpot=false;
	return;		
	}
		
		
	nr = -1; 
	if ( Rx_Hud(MyHUD) != None && Rx_Hud(MyHUD).SpotTargets.Length > 0) {
	
		PrimarySpot = Rx_Hud(MyHUD).SpotTargets[0] ;//Eliminate spamming the hell out of this line. 
		
		if(PrimarySpot == none || Rx_DestroyableObstaclePlus(PrimarySpot) != none) 
		{
			bCanFocusSpot=false;
			return; 
		}
		
		if(AGN_CratePickup(PrimarySpot) != none && numberOfRadioCommandsLastXSeconds++ < 5)
		{
			BroadCastSpotMessage(11, "CRATE SPOTTED:" @ GetSpottargetLocationInfo(Rx_CratePickup(PrimarySpot)));	
		}
		else
		if(Rx_Building(Rx_Hud(MyHUD).SpotTargets[0]) != None) {
			
			if (numberOfRadioCommandsLastXSeconds++ < 5) {
				Building = Rx_Building(Rx_Hud(MyHUD).SpotTargets[0]);
				BroadcastBuildingSpotMessages(Building);
			}
		} else if(Rx_Defence(PrimarySpot) != none) {
			if (numberOfRadioCommandsLastXSeconds++ < 5) {
				BroadcastBaseDefenseSpotMessages(Rx_Defence(PrimarySpot));
				if(Rx_DefencePRI(Rx_Defence(PrimarySpot).PlayerReplicationInfo) != none) SetPlayerSpotted(Rx_DefencePRI(Rx_Defence(PrimarySpot).PlayerReplicationInfo).PlayerID) ;
			}
		} else if(Rx_Weapon_DeployedBeacon(PrimarySpot) != None) {
			if (numberOfRadioCommandsLastXSeconds++ < 5) {
				if(PrimarySpot.GetTeamNum() == GetTeamNum())
					BroadCastSpotMessage(15, "Defend BEACON"@GetSpottargetLocationInfo(Rx_Weapon_DeployedBeacon(PrimarySpot))@"!!!");
				else
					BroadCastSpotMessage(-1, "Spotted ENEMY BEACON"@GetSpottargetLocationInfo(Rx_Weapon_DeployedBeacon(PrimarySpot))@"!!!");	
			}
		}  else if(Rx_Weapon_DeployedC4(PrimarySpot) != None) {
			if (numberOfRadioCommandsLastXSeconds++ < 5) {
				BuildingName = Rx_Weapon_DeployedC4(PrimarySpot).ImpactedActor.GetHumanReadableName();
				if(BuildingName == "MCT" || Rx_Building(Rx_Weapon_DeployedC4(PrimarySpot).ImpactedActor) != None)
				{	
					if(BuildingName == "MCT")
						BuildingName = "MCT"@GetSpottargetLocationInfo(Rx_Weapon_DeployedC4(PrimarySpot));			
					if(PrimarySpot.GetTeamNum() == GetTeamNum())
						BroadCastSpotMessage(15, "Defend >>C4<< at "@BuildingName@"!!!");
					else
						BroadCastSpotMessage(-1, "Spotted ENEMY >>C4<< at "@BuildingName@"!!!");
				}	
			}
		} else if(Rx_Vehicle_Harvester(PrimarySpot) != None) {
			if (numberOfRadioCommandsLastXSeconds++ < 5) {
				if(PrimarySpot.GetTeamNum() == GetTeamNum())
					RadioCommand(26);
				else
				{
				RadioCommand(21);
				if(Rx_DefencePRI(Rx_Vehicle_Harvester(PrimarySpot).PlayerReplicationInfo) != none) SetPlayerSpotted(Rx_DefencePRI(Rx_Vehicle_Harvester(PrimarySpot).PlayerReplicationInfo).PlayerID) ;
				if(bFocusSpotting) SetPlayerFocused(Rx_DefencePRI(Rx_Vehicle_Harvester(PrimarySpot).PlayerReplicationInfo).PlayerID) ;
				bFocusSpotting = false; 
				}
					
			}
			bCanFocusSpot=false;
			return;
		} else if(Pawn(PrimarySpot).GetTeamNum() == GetTeamNum()) {
			bot = Rx_Bot(Pawn(PrimarySpot).Controller);
			if(bot != None) {
				if(bot.Squad != None && Rx_SquadAI(bot.squad).SquadLeader == Self && bot.GetOrders() == 'Follow') {
					UTTeamInfo(bot.Squad.Team).AI.SetBotOrders(bot);
					BroadCastSpotMessage(17, "Stop following me"@Pawn(PrimarySpot).Controller.GetHumanReadableName());
					RespondingBot = bot;
					SetTimer(0.5 + FRand(), false, 'BotSayAffirmativeToplayer');
				} else {
					bot.SetBotOrders('Follow', self, true);
					BroadCastSpotMessage(13, "Follow me"@Pawn(PrimarySpot).Controller.GetHumanReadableName());
					RespondingBot = bot;
					SetTimer(0.5 + FRand(), false, 'BotSayAffirmativeToplayer');
				}
			} else {
				
				/*Spotting Friendly Pawn*/
				
				if(numberOfRadioCommandsLastXSeconds++ < 5 && Rx_Pawn(PrimarySpot) != none && Rx_Pawn(PrimarySpot).PlayerReplicationInfo !=none) 
				{
					/*Infantry To Infantry*/
					if(Rx_Pawn(Pawn) != none && Rx_Pawn(Pawn).Armor <= Rx_Pawn(Pawn).ArmorMax/1.5 && Rx_Pawn(PrimarySpot).IsHealer() ) //Send "I need repairs"
					{
					nr=10; 
					RMSG=PlayerReplicationInfo.PlayerName @ "Needs Repairs" ;
					CMSG="-Requested Repairs-"; 
					UIS=1; 
					}
					else
					if (Rx_Weapon_Beacon(Pawn.Weapon) != none) //Send "Cover Me" 
					{
					nr=15; 
					RMSG=PlayerReplicationInfo.PlayerName @ "Needs Cover" ;
					CMSG="-Requested Cover-"; 
					UIS=3; 
					}
					else /*Vehicle to Infantry*/
					if(Rx_Vehicle(Pawn) != none && Rx_Vehicle(Pawn).Health <= Rx_Vehicle(Pawn).HealthMax*0.85 && Rx_Pawn(PrimarySpot).IsHealer() ) //Send "I need repairs"
					{
					nr=10; 
					RMSG=PlayerReplicationInfo.PlayerName @ "Needs Repairs" ;
					CMSG="-Requested Repairs-"; 
					UIS=1; 
					}
					else //Send "Get in the vehicle"
					if(Rx_Vehicle(Pawn) != none && Rx_Pawn(PrimarySpot) != none)
					{
					nr=1; 
					RMSG=PlayerReplicationInfo.PlayerName @ ": Requested Passenger" ;
					CMSG="-Requested Passenger-"; 
					UIS=2; 
					}
					else
					{
					nr=13; 
					RMSG=PlayerReplicationInfo.PlayerName @ ": Follow Me" ;
					CMSG="-Requested Follow-"; 
					UIS=2; 
					}
					
					
				}
				else
				if(numberOfRadioCommandsLastXSeconds++ < 5 && Rx_Vehicle(PrimarySpot) != none && Rx_Vehicle(PrimarySpot).PlayerReplicationInfo !=none)
				{
					//Bacon
					if (Rx_Weapon_Beacon(Pawn.Weapon) != none) //Send "Cover Me" 
					{
					nr=15; 
					RMSG=PlayerReplicationInfo.PlayerName @ "needs beacon cover" ;
					CMSG="-Requested Cover-"; 
					UIS=3; 
					}
					else
					if(Pawn(PrimarySpot).PlayerReplicationInfo != none && Rx_Vehicle(Pawn) == none) 
					{
					nr=14; 
					RMSG=PlayerReplicationInfo.PlayerName @ "needs a ride" ;
					CMSG="-Requested a Ride-"; 
					UIS=2; 
					}
					else
					if(Rx_Vehicle(Pawn) != none)
					{
					//Send "Follow Me"
					nr=13; 
					RMSG=PlayerReplicationInfo.PlayerName @ ": Follow Me" ;
					CMSG="-Requested Follow-"; 
					UIS=2; 
					}
					
					
					
				}
					if(Pawn(PrimarySpot) != none && nr > -1 )
					{
					numberOfRadioCommandsLastXSeconds++; 
					WhisperSpotMessage(Pawn(PrimarySpot).PlayerReplicationInfo.PlayerID, nr, RMSG, UIS);
					CTextMessage(CMSG,'Green',30);
					ClientPlaySound(RadioCommands[nr]);
					
					spotMessagesBlocked = true;
					SetTimer(1.5, false, 'resetSpotMessageCountTimer');
					}
				//BroadCastSpotMessage(13, "Follow me"@Pawn(Rx_Hud(MyHUD).SpotTargets[0]).Controller.GetHumanReadableName());
			}
		} else {
			BroadcastEnemySpotMessages();
		}
		//@Shahman: SpotTargets Will be removed after 10 seconds.
		//TODO: editor controllers
		if(IsTimerActive('RemoveSpotTargets'))	{
			ClearTimer('RemoveSpotTargets');
		}
		SetTimer (10.0, false, 'RemoveSpotTargets'); 
	}
	bCanFocusSpot=false; 
	bFocusSpotting= false; 
}

// Beacon Overwrite
reliable server function ServerSetItem(class<Rx_Weapon> classname)
{
	local Rx_InventoryManager invmngr;
	local array<class<Rx_Weapon> > wclasses;
	
	if ( classname.class.Name == "Rx_Weapon_IonCannonBeacon" )
		classname = class'AGN_Mut_AlienXSystem.AGN_Weapon_IonCannonBeacon';
	if ( classname.class.Name == "Rx_Weapon_NukeBeacon" )
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