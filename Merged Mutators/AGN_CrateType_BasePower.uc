/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_CrateType_BasePower extends Rx_CrateType 
	config(AGN_Crates);
	
var int LastPickupTeamID,RestorePowerInSeconds;
var repnotify bool isActive;
var array<Rx_Building_Team_Internals> BuildingsPoweredDown;

function string GetGameLogMessage(Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	return "GAME" `s "Crate;" `s "base-power" `s "by" `s `PlayerLog(RecipientPRI);
}

function float GetProbabilityWeight(Rx_Pawn Recipient, Rx_CratePickup CratePickup)
{
	local Rx_Building building;
	local bool hasDefences;
	local Rx_Building_PowerFactory building;
	local bool foundPowerPlant;
	
	//Check for Powerplants
	foreach AllActors(class'Rx_Building_PowerFactory', building) {
		if(TeamID == building.TeamID)
		{	
			foundPowerPlant = true;
			break;
		}
	}
	
	// If we have no PP, do not turn off the defences on this map (bug in RenX 5.333)
	if ( foundPowerPlant == false )
		return 0;
	
	// If the map has no ob/agt - dont get this crate
	foreach CratePickup.AllActors(class'Rx_Building', building) {
		if ( Rx_Building_Defense(building) != None ) 
			hasDefences = true;
	}
	
	if ( !hasDefences )
		return 0;

	// If this crate is active, then do not allow for it to picked up once again.
	if ( isActive == false )
		return super.GetProbabilityWeight(Recipient,CratePickup);
	else
		return 0;
}

// RX_EVA_VoiceClips.Nod_EVA.S_EVA_Nod_NodPowerPlant_PowerOffline_Cue - Nod Self Power Offline
// RX_EVA_VoiceClips.Nod_EVA.S_EVA_Nod_GDIPowerPlant_PowerOffline_Cue - Nod GDI Power Offline

// RX_EVA_VoiceClips.gdi_EVA.S_EVA_GDI_GDIPowerPlant_PowerOffline_Cue - GDI Self Power Offline
// RX_EVA_VoiceClips.gdi_EVA.S_EVA_GDI_NodPowerPlant_PowerOffline_Cue - GDI Nod Power Offline

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	local Rx_Building building;
	local Rx_Building_Team_Internals buildingTeamInternals;

	if ( Recipient.GetTeamNum() == TEAM_GDI )
	{
		`log("[AGN_CrateType_BasePower] ExecuteCrateBehaviour | Init");
		foreach CratePickup.AllActors(class'Rx_Building', building) {
			if ( Rx_Building_Defense(building) != None ) 
			{
				buildingTeamInternals = Rx_Building_Team_Internals(building.BuildingInternals);
				if(buildingTeamInternals.TeamID == TEAM_NOD)
					if ( buildingTeamInternals.bNoPower == false )
					{
						BuildingsPoweredDown.AddItem(buildingTeamInternals);
						buildingTeamInternals.PowerLost();
						buildingTeamInternals.SetTimer(RestorePowerInSeconds, false, 'PowerRestore');
						`log("[AGN_CrateType_BasePower] ExecuteCrateBehaviour | BUILDING POWER OFFLINE " $ building.Name);
					}
			}
        }
		`log("[AGN_CrateType_BasePower] ExecuteCrateBehaviour | SendMessages");
		
		// NOD POWER OFFLINE HERE
		
		class'AGN_UtilitiesX'.Static.SendMessageToPlayersInTeam(TEAM_GDI, "INFORMATION: NOD BASE POWER DISABLED BY CRATE PICKUP (" $ string(RestorePowerInSeconds) $ " Seconds)", 'LightGreen', 250);
		class'AGN_UtilitiesX'.Static.SendMessageToPlayersInTeam(TEAM_NOD, "WARNING: BASE POWER DISABLED BY CRATE PICKUP (" $ string(RestorePowerInSeconds) $ " Seconds)!", 'Red', 250);
		
		
		/* SEND AUDIO
			RX_EVA_VoiceClips.Nod_EVA.S_EVA_Nod_NodPowerPlant_PowerOffline_Cue
			RX_EVA_VoiceClips.gdi_EVA.S_EVA_GDI_NodPowerPlant_PowerOffline_Cue
		*/
		//class'AGN_UtilitiesX'.Static.PlayAudioForTeam(TEAM_GDI, SoundCue'RX_EVA_VoiceClips.gdi_EVA.S_EVA_GDI_NodPowerPlant_PowerOffline_Cue');
		//class'AGN_UtilitiesX'.Static.PlayAudioForTeam(TEAM_NOD, SoundCue'RX_EVA_VoiceClips.Nod_EVA.S_EVA_Nod_NodPowerPlant_PowerOffline_Cue');
		//class'AGN_UtilitiesX'.Static.SetCratePickupMessageForTeam(TEAM_NOD, "Base Defences Offline", RestorePowerInSeconds);
		//class'AGN_UtilitiesX'.Static.SetCratePickupMessageForTeam(TEAM_GDI, "Nod Defences Offline", RestorePowerInSeconds);
	} else {
		foreach CratePickup.AllActors(class'Rx_Building', building) {
			if ( Rx_Building_Defense(building) != None ) 
			{
				buildingTeamInternals = Rx_Building_Team_Internals(building.BuildingInternals);
				if(buildingTeamInternals.TeamID == TEAM_GDI)
					if ( buildingTeamInternals.bNoPower == false )
					{
						BuildingsPoweredDown.AddItem(buildingTeamInternals);
						buildingTeamInternals.PowerLost();
						Rx_Building_AdvancedGuardTower_Internals(buildingTeamInternals).SetTimer(RestorePowerInSeconds, false, 'PowerRestore');
						`log("[AGN_CrateType_BasePower] ExecuteCrateBehaviour | BUILDING POWER OFFLINE " $ building.Name);
					}
			}
        }
		
		// GDI POWER OFFLINE
		
		class'AGN_UtilitiesX'.Static.SendMessageToPlayersInTeam(TEAM_GDI, "WARNING: GDI BASE POWER DISABLED BY CRATE PICKUP (" $ string(RestorePowerInSeconds) $ " Seconds)!", 'Red', 250);
		class'AGN_UtilitiesX'.Static.SendMessageToPlayersInTeam(TEAM_NOD, "INFORMATION: NOD BASE POWER DISABLED BY CRATE PICKUP (" $ string(RestorePowerInSeconds) $ " Seconds)", 'LightGreen', 250);
		
		/* SEND AUDIO
			RX_EVA_VoiceClips.gdi_EVA.S_EVA_GDI_GDIPowerPlant_PowerOffline_Cue
			RX_EVA_VoiceClips.Nod_EVA.S_EVA_Nod_GDIPowerPlant_PowerOffline_Cue
		*/
		//class'AGN_UtilitiesX'.Static.PlayAudioForTeam(TEAM_GDI, SoundCue'RX_EVA_VoiceClips.gdi_EVA.S_EVA_GDI_GDIPowerPlant_PowerOffline_Cue');
		//class'AGN_UtilitiesX'.Static.PlayAudioForTeam(TEAM_NOD, SoundCue'RX_EVA_VoiceClips.Nod_EVA.S_EVA_Nod_GDIPowerPlant_PowerOffline_Cue');
		//class'AGN_UtilitiesX'.Static.SetCratePickupMessageForTeam(TEAM_GDI, "Base Defences Offline", RestorePowerInSeconds);
		//class'AGN_UtilitiesX'.Static.SetCratePickupMessageForTeam(TEAM_NOD, "GDI Defences Offline", RestorePowerInSeconds);
	}
	
	LastPickupTeamID = Recipient.GetTeamNum();
	isActive = true;
	//SetTimer(RestorePowerInSeconds, false, 'RestorePower');
	`log("[AGN_CrateType_BasePower] ExecuteCrateBehaviour | Timer Started... Waiting " $ RestorePowerInSeconds $ " seconds");
}

/*
function RestorePower()
{
	local Rx_Building_Team_Internals building;
	
	`log("[AGN_CrateType_BasePower] RESTORE_POWER | Init");
	
	foreach BuildingsPoweredDown(building) {
		`log("[AGN_CrateType_BasePower] RestorePower | Restoring Power To Building " $ building.Name);
		if ( building.isDestroyed() == false ) // Do not re-enable power to buildings that were killed in the 10s interval
		{
			building.PowerRestore();
			`log("[AGN_CrateType_BasePower] RestorePower | Restored Power To Building " $ building.Name);
		}
	}
	
	`log("[AGN_CrateType_BasePower] RestorePower | SendMessages");
	if ( LastPickupTeamID == TEAM_GDI )
	{
		//GDI
		class'AGN_UtilitiesX'.Static.SendMessageToPlayersInTeam(TEAM_GDI, "WARNING: NOD DEFENSE POWER RESTORED", 'Red', 150);
		class'AGN_UtilitiesX'.Static.SendMessageToPlayersInTeam(TEAM_NOD, "INFORMATION: BASE POWER RESTORED!", 'Green', 150);
	} else {
		//Nod
		class'AGN_UtilitiesX'.Static.SendMessageToPlayersInTeam(TEAM_GDI, "INFORMATION: BASE POWER RESTORED!", 'Green', 150);
		class'AGN_UtilitiesX'.Static.SendMessageToPlayersInTeam(TEAM_NOD, "WARNING: GDI DEFENCES POWER RESTORED", 'Red', 150);
	}
	
	`log("[AGN_CrateType_BasePower] RestorePower | Done");
}
*/

DefaultProperties
{
	//PickupSound = SoundCue'RX_EVA_VoiceClips.Nod_EVA.S_EVA_Nod_Beacon_NuclearStrikeImminent_Cue'
	BroadcastMessageIndex = 1005
	RestorePowerInSeconds = 60
}

