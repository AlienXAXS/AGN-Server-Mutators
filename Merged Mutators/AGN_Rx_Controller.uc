/*
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 *
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 *
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 *
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


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

	`log("~~~~~~~~~~~~~~~~~ Purchase Attempt: " $ string(classname));
	if ( classname.class.Name == 'Rx_Weapon_IonCannonBeacon' )
		classname = class'AGN_Mut_AlienXSystem.AGN_Weapon_IonCannonBeacon';
	if ( classname.class.Name == 'Rx_Weapon_NukeBeacon' )
		classname = class'AGN_Mut_AlienXSystem.AGN_Weapon_NukeBeacon';

	invmngr = Rx_InventoryManager(Pawn.InvManager);
	if (invmngr == none) return;

	`log("Inventory Manager Obtained");

	if (!invmngr.IsItemAllowed(classname)) return;
	wclasses = invmngr.GetWeaponsOfClassification(CLASS_ITEM);
	if (invmngr.GetItemSlots() == wclasses.Length)
		invmngr.RemoveWeaponOfClass(wclasses[wclasses.Length - 1]);

	// add requested weapon
	`log("Adding weapon in AGN Inv Manager");
	invmngr.AddWeaponOfClass(classname, CLASS_ITEM);
}

function BroadcastEnemySpotMessages()
{
	local int i,j;
	//Adding TS Vehicles (nBab)
	//local int SpottedVehicles[15];
	local int SpottedVehicles[21];
	local int SpottedInfs[30];
	local int NumVehicles;
	local int NumInfs;
	local Actor SpotTarget;
	local Actor FirstSpotTarget;
	local string LocationInfo;
	local string SpottingMsg;
	local UTPlayerReplicationInfo PRI;
	//local Pawn P;

	SpottingMsg = "";
	foreach Rx_Hud(MyHUD).SpotTargets(SpotTarget)
	{
		if(Pawn(SpotTarget) == None)
			continue;
		if(Pawn(SpotTarget).GetTeamNum() == GetTeamNum())
			continue;
		if(Rx_Vehicle(SpotTarget) != None && Rx_Vehicle_Harvester(SpotTarget) == None)
		{
			NumVehicles++;

			//Tell the spot target to activate its controller and set its visibility
			Rx_Vehicle(SpotTarget).SetSpotted();

			if(Rx_Vehicle_Humvee(SpotTarget) != None) {
				SpottedVehicles[0]++;
			} else if(Rx_Vehicle_APC_GDI(SpotTarget) != None) {
				SpottedVehicles[1]++;
			} else if(Rx_Vehicle_MRLS(SpotTarget) != None) {
				SpottedVehicles[2]++;
			} else if(Rx_Vehicle_MediumTank(SpotTarget) != None) {
				SpottedVehicles[3]++;
			} else if(Rx_Vehicle_MammothTank(SpotTarget) != None) {
				SpottedVehicles[4]++;
			} else if(Rx_Vehicle_Chinook_GDI(SpotTarget) != None) {
				SpottedVehicles[5]++;
			} else if(Rx_Vehicle_Orca(SpotTarget) != None) {
				SpottedVehicles[6]++;
			} else if(Rx_Vehicle_Buggy(SpotTarget) != None) {
				SpottedVehicles[7]++;
			} else if(Rx_Vehicle_APC_Nod(SpotTarget) != None) {
				SpottedVehicles[8]++;
			} else if(Rx_Vehicle_Artillery(SpotTarget) != None) {
				SpottedVehicles[9]++;
			} else if(Rx_Vehicle_LightTank(SpotTarget) != None) {
				SpottedVehicles[10]++;
			} else if(Rx_Vehicle_FlameTank(SpotTarget) != None) {
				SpottedVehicles[11]++;
			} else if(Rx_Vehicle_StealthTank(SpotTarget) != None) {
				SpottedVehicles[12]++;
			} else if(Rx_Vehicle_Chinook_Nod(SpotTarget) != None) {
				SpottedVehicles[13]++;
			} else if(Rx_Vehicle_Apache(SpotTarget) != None) {
				SpottedVehicles[14]++;
			} else if(TS_Vehicle_Buggy(SpotTarget) != None) {
				SpottedVehicles[15]++;
			} else if(TS_Vehicle_ReconBike(SpotTarget) != None) {
				SpottedVehicles[16]++;
			} else if(TS_Vehicle_TickTank(SpotTarget) != None) {
				SpottedVehicles[17]++;
			} else if(TS_Vehicle_HoverMRLS(SpotTarget) != None) {
				SpottedVehicles[18]++;
			} else if(TS_Vehicle_Wolverine(SpotTarget) != None) {
				SpottedVehicles[19]++;
			} else if(TS_Vehicle_Titan(SpotTarget) != None) {
				SpottedVehicles[20]++;
			} else if(APB_Vehicle_TeslaTank(SpotTarget) != None) {
				SpottedVehicles[21]++;
			}
		}

		if(Rx_Pawn(SpotTarget) != None)
		{
			NumInfs++;
			if(UTPlayerReplicationInfo(Rx_Pawn(SpotTarget).PlayerReplicationInfo) == None)
				continue;
			PRI = UTPlayerReplicationInfo(Rx_Pawn(SpotTarget).PlayerReplicationInfo);

			Rx_PRI(Rx_Pawn(SpotTarget).PlayerReplicationInfo).SetSpotted();

			if(PRI.CharClassInfo == class'AGN_FamilyInfo_GDI_Soldier' || PRI.CharClassInfo == class'RX_FamilyInfo_GDI_Soldier') {
				SpottedInfs[0]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_GDI_Shotgunner' || PRI.CharClassInfo == class'Rx_FamilyInfo_GDI_Shotgunner') {
				SpottedInfs[1]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_GDI_Grenadier' || PRI.CharClassInfo == class'Rx_FamilyInfo_GDI_Grenadier') {
				SpottedInfs[2]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_GDI_Marksman' || PRI.CharClassInfo == class'Rx_FamilyInfo_GDI_Marksman') {
				SpottedInfs[3]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_GDI_Engineer' || PRI.CharClassInfo == class'Rx_FamilyInfo_GDI_Engineer') {
				SpottedInfs[4]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_GDI_Officer' || PRI.CharClassInfo == class'Rx_FamilyInfo_GDI_Officer') {
				SpottedInfs[5]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_GDI_RocketSoldier' || PRI.CharClassInfo == class'Rx_FamilyInfo_GDI_RocketSoldier') {
				SpottedInfs[6]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_GDI_McFarland' || PRI.CharClassInfo == class'Rx_FamilyInfo_GDI_McFarland') {
				SpottedInfs[7]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_GDI_Deadeye' || PRI.CharClassInfo == class'Rx_FamilyInfo_GDI_Deadeye') {
				SpottedInfs[8]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_GDI_Gunner' || PRI.CharClassInfo == class'Rx_FamilyInfo_GDI_Gunner') {
				SpottedInfs[9]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_GDI_Patch' || PRI.CharClassInfo == class'Rx_FamilyInfo_GDI_Patch') {
				SpottedInfs[10]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_GDI_Havoc' || PRI.CharClassInfo == class'Rx_FamilyInfo_GDI_Havoc') {
				SpottedInfs[11]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_GDI_Sydney' || PRI.CharClassInfo == class'Rx_FamilyInfo_GDI_Sydney') {
				SpottedInfs[12]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_GDI_Mobius' || PRI.CharClassInfo == class'Rx_FamilyInfo_GDI_Mobius') {
				SpottedInfs[13]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_GDI_Hotwire' || PRI.CharClassInfo == class'Rx_FamilyInfo_GDI_Hotwire') {
				SpottedInfs[14]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_Nod_Soldier' || PRI.CharClassInfo == class'Rx_FamilyInfo_Nod_Soldier') {
				SpottedInfs[15]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_Nod_Shotgunner' || PRI.CharClassInfo == class'Rx_FamilyInfo_Nod_Shotgunner') {
				SpottedInfs[16]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_Nod_FlameTrooper' || PRI.CharClassInfo == class'Rx_FamilyInfo_Nod_FlameTrooper') {
				SpottedInfs[17]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_Nod_Marksman' || PRI.CharClassInfo == class'Rx_FamilyInfo_Nod_Marksman') {
				SpottedInfs[18]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_Nod_Engineer' || PRI.CharClassInfo == class'Rx_FamilyInfo_Nod_Engineer') {
				SpottedInfs[19]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_Nod_Officer' || PRI.CharClassInfo == class'Rx_FamilyInfo_Nod_Officer') {
				SpottedInfs[20]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_Nod_RocketSoldier' || PRI.CharClassInfo == class'Rx_FamilyInfo_Nod_RocketSoldier') {
				SpottedInfs[21]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_Nod_ChemicalTrooper' || PRI.CharClassInfo == class'Rx_FamilyInfo_Nod_ChemicalTrooper') {
				SpottedInfs[22]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_Nod_blackhandsniper' || PRI.CharClassInfo == class'Rx_FamilyInfo_Nod_blackhandsniper') {
				SpottedInfs[23]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_Nod_Stealthblackhand' || PRI.CharClassInfo == class'Rx_FamilyInfo_Nod_Stealthblackhand') {
				SpottedInfs[24]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_Nod_LaserChainGunner' || PRI.CharClassInfo == class'Rx_FamilyInfo_Nod_LaserChainGunner') {
				SpottedInfs[25]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_Nod_Sakura' || PRI.CharClassInfo == class'Rx_FamilyInfo_Nod_Sakura') {
				SpottedInfs[26]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_Nod_Raveshaw' || PRI.CharClassInfo == class'Rx_FamilyInfo_Nod_Raveshaw') {
				SpottedInfs[27]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_Nod_Mendoza' || PRI.CharClassInfo == class'Rx_FamilyInfo_Nod_Mendoza') {
				SpottedInfs[28]++;
			} else if(PRI.CharClassInfo == class'AGN_FamilyInfo_Nod_Technician' || PRI.CharClassInfo == class'Rx_FamilyInfo_Nod_Technician') {
				SpottedInfs[29]++;
			}
		}

		if (Rx_Pawn(SpotTarget) != none)
		{
			SetPlayerSpotted(Rx_Pawn(SpotTarget).PlayerReplicationInfo.PlayerID);
		}
		else if (Rx_Vehicle(SpotTarget) != none && (Rx_PRI(Rx_Vehicle(SpotTarget).PlayerReplicationInfo) != none || Rx_DefencePRI(Rx_Vehicle(SpotTarget).PlayerReplicationInfo) != none))
		{
			if(Rx_PRI(Rx_Vehicle(SpotTarget).PlayerReplicationInfo) != none)
			{
				//`log("Set Vehicle Spotted");
				SetPlayerSpotted(Rx_PRI(Rx_Vehicle(SpotTarget).PlayerReplicationInfo).PlayerID );
			}
			else
			if(Rx_DefencePRI(Rx_Vehicle(SpotTarget).PlayerReplicationInfo) != none)
			{
				//`log("Set Defense Spotted");
				SetPlayerSpotted(Rx_DefencePRI(Rx_Vehicle(SpotTarget).PlayerReplicationInfo).PlayerID);
			}
			/**foreach WorldInfo.AllPawns(class'Pawn', P)
			{
				if(P.DrivenVehicle == Rx_Vehicle(SpotTarget))
					SetPlayerSpotted(P.PlayerReplicationInfo.PlayerID);
			}*/

		}
	}

	FirstSpotTarget = Rx_Hud(MyHUD).SpotTargets[0];

	LocationInfo = GetSpottargetLocationInfo(FirstSpotTarget);

	if(numberOfRadioCommandsLastXSeconds++ > 5)
	{
	spotMessagesBlocked = true;
	SetTimer(2.5, false, 'resetSpotMessageCountTimer'); //5.0 seconds is REALLY annoying and sometimes game breaking.
	}
	if(NumVehicles > 0)
	{
		for(i=20; i>=0; i--)
		{
			if(j > 5)
				break;
			if(SpottedVehicles[i] > 0)
				j++;
			if(i==0 && SpottedVehicles[0] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[0] @ "Humvee";
			else if(i==1 && SpottedVehicles[1] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[1] @ "APC";
			else if(i==2 && SpottedVehicles[2] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[2] @ "MRLS";
			else if(i==3 && SpottedVehicles[3] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[3] @ "Med.Tank";
			else if(i==4 && SpottedVehicles[4] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[4] @ "Mam.Tank";
			else if(i==5 && SpottedVehicles[5] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[5] @ "Chinook";
			else if(i==6 && SpottedVehicles[6] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[6] @ "Orca";
			else if(i==7 && SpottedVehicles[7] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[7] @ "Buggy";
			else if(i==8 && SpottedVehicles[8] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[8] @ "APC";
			else if(i==9 && SpottedVehicles[9] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[9] @ "Artillery";
			else if(i==10 && SpottedVehicles[10] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[10] @ "L.Tank";
			else if(i==11 && SpottedVehicles[11] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[11] @ "F.Tank";
			else if(i==12 && SpottedVehicles[12] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[12] @ "S.Tank";
			else if(i==13 && SpottedVehicles[13] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[13] @ "Chinook";
			else if(i==14 && SpottedVehicles[14] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[14] @ "Apache";
			else if(i==15 && SpottedVehicles[15] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[15] @ "Buggy";
			else if(i==16 && SpottedVehicles[16] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[16] @ "R.Bike";
			else if(i==17 && SpottedVehicles[17] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[17] @ "T.Tank";
			else if(i==18 && SpottedVehicles[18] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[18] @ "H.MRLS";
			else if(i==19 && SpottedVehicles[19] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[19] @ "Wolverine";
			else if(i==20 && SpottedVehicles[20] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[20] @ "Titan";
			else if(i==21 && SpottedVehicles[21] > 0)
				SpottingMsg = SpottingMsg @ SpottedVehicles[21] @ "Tesla Tank";

			if(SpottedVehicles[i] > 1)
				SpottingMsg = SpottingMsg @ "s";
			if(SpottedVehicles[i] > 0 && (NumInfs+NumVehicles) > j)
				SpottingMsg = SpottingMsg @ ",";
		}
	}

	if(NumInfs > 0)
	{
		for(i=29; i>=0; i--)
		{
			if(j > 5)
				break;
			if(SpottedInfs[i] > 0)
				j++;

			if(i==0 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Soldier";
			else if(i==1 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Shotgunner";
			else if(i==2 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Grenadier";
			else if(i==3 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Marksman";
			else if(i==4 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Engineer";
			else if(i==5 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Officer";
			else if(i==6 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "RocketSoldier";
			else if(i==7 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "McFarland";
			else if(i==8 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Deadeye";
			else if(i==9 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Gunner";
			else if(i==10 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Patch";
			else if(i==11 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Havoc";
			else if(i==12 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Sydney";
			else if(i==13 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Mobius";
			else if(i==14 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Hotwire";
			else if(i==15 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Soldier";
			else if(i==16 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Shotgunner";
			else if(i==17 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "FlameTrooper";
			else if(i==18 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Marksman";
			else if(i==19 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Engineer";
			else if(i==20 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Officer";
			else if(i==21 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Rock.Soldier";
			else if(i==22 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Chem.Trooper";
			else if(i==23 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Blackh.Sniper";
			else if(i==24 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "SBH";
			else if(i==25 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "LCG";
			else if(i==26 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Sakura";
			else if(i==27 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Raveshaw";
			else if(i==28 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Mendoza";
			else if(i==29 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg @ SpottedInfs[i] @ "Tech";

			if(SpottedInfs[i] > 1)
				SpottingMsg = SpottingMsg @ "s";
			if(SpottedInfs[i] > 0 && (NumInfs+NumVehicles) > j)
				SpottingMsg = SpottingMsg @ ",";
		}
	}

	if( (NumVehicles + NumInfs) > 6)
		SpottingMsg = SpottingMsg @ " and more";
		if(Rx_Vehicle(FirstSpotTarget) != none && bFocusSpotting && NumVehicles == 1 && NumInfs == 0)
		{
		BroadCastSpotMessage(3, "FOCUS FIRE:"@SpottingMsg@LocationInfo);
		SetPlayerFocused(Rx_PRI(Rx_Vehicle(FirstSpotTarget).PlayerReplicationInfo).PlayerID);
		}
		else
		if(Rx_Pawn(FirstSpotTarget) != none && bFocusSpotting && NumInfs == 1 && NumVehicles == 0)
		{
		BroadCastSpotMessage(19, "FOCUS FIRE:"@SpottingMsg@LocationInfo);
		SetPlayerFocused(Rx_PRI(Rx_Pawn(FirstSpotTarget).PlayerReplicationInfo).PlayerID);
		}
		else
		BroadCastSpotMessage(9, "Spotted"@SpottingMsg@LocationInfo);
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
