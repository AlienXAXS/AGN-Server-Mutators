/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_BaseDefenceMCT_Internals extends Rx_CapturableMCT_Internals;

var Rx_Building myDefenceStructure;

simulated function SoundNodeWave GetAnnouncment(int alarm, int teamNum )
{
	// Play no audio samples for this
}

function bool HealDamage(int Amount, Controller Healer, class<DamageType> DamageType)
{
	local int RealAmount;
	local float Scr;
	
	class'AGN_UtilitiesX'.static.SendMessageToAllPlayers("HEALING: " $ Amount $ " healer: " $ string(Healer) $ " DamageType: " $ DamageType);
	
	if ((Health < HealthMax || Healer.GetTeamNum() != GetTeamNum()) && Amount > 0 && Healer != None ) {
		RealAmount = Min(Amount, HealthMax - Health);

		if (RealAmount > 0) {

			if (Health >= HealthMax && SavedDmg > 0.0f) {
				SavedDmg = FMax(0.0f, SavedDmg - Amount);
				Scr = SavedDmg * HealPointsScale;
				Rx_PRI(Healer.PlayerReplicationInfo).AddScoreToPlayerAndTeam(Scr);
			}

			Scr = RealAmount * HealPointsScale;
			Rx_PRI(Healer.PlayerReplicationInfo).AddScoreToPlayerAndTeam(Scr);
		}

		if(Healer.GetTeamNum() != GetTeamNum()) {
			Amount = -1 * Amount;
		}
		
		Health = Min(HealthMax, Health + Amount);
		
		if(Health <= 1) {
			Health = 1;	
			if(GetTeamNum() != TEAM_NOD && GetTeamNum() != TEAM_GDI) {
				if(Healer.GetTeamNum() == TEAM_NOD) {	
					`LogRx("GAME"`s "Captured;"`s class'Rx_Game'.static.GetTeamName(TeamID)$","$self.class `s "id" `s GetRightMost(self) `s "by" `s `PlayerLog(Healer.PlayerReplicationInfo) );
					BroadcastLocalizedMessage(MessageClass,NOD_CAPTURED,Healer.PlayerReplicationInfo,,self);
					if(LastCaptureTime == 0 || (WorldInfo.TimeSeconds - LastCaptureTime) >= 30) 
					{
						LastCaptureTime = WorldInfo.TimeSeconds;
						Rx_Controller(Healer).DisseminateVPString("[Tech-Building Captured]&" $ class'Rx_VeterancyModifiers'.default.Ev_CaptureTechBuilding $ "&");
						Rx_PRI(Healer.PlayerReplicationInfo).AddTechBuildingCapture(); 
					}
					ChangeTeamReplicate(TEAM_NOD,true);
				} else {
					`LogRx("GAME"`s "Captured;"`s class'Rx_Game'.static.GetTeamName(TeamID)$","$self.class `s "id" `s GetRightMost(self) `s "by" `s `PlayerLog(Healer.PlayerReplicationInfo) );
					BroadcastLocalizedMessage(MessageClass,GDI_CAPTURED,Healer.PlayerReplicationInfo,,self);
					if(LastCaptureTime == 0 || (WorldInfo.TimeSeconds - LastCaptureTime) >= 30) 
					{
						LastCaptureTime = WorldInfo.TimeSeconds;
						Rx_Controller(Healer).DisseminateVPString("[Tech-Building Captured]&" $ class'Rx_VeterancyModifiers'.default.Ev_CaptureTechBuilding $ "&");
						Rx_PRI(Healer.PlayerReplicationInfo).AddTechBuildingCapture(); 
					}
					ChangeTeamReplicate(TEAM_GDI,true);
				}
			} else {
				if (TeamID == TEAM_NOD)
					BroadcastLocalizedMessage(MessageClass,NOD_LOST,Healer.PlayerReplicationInfo,,self);
				else if (TeamID == TEAM_GDI)
					BroadcastLocalizedMessage(MessageClass,GDI_LOST,Healer.PlayerReplicationInfo,,self);
				`LogRx("GAME"`s "Neutralized;"`s class'Rx_Game'.static.GetTeamName(TeamID)$","$self.class `s "id" `s GetRightMost(self) `s "by" `s `PlayerLog(Healer.PlayerReplicationInfo) );
				ChangeTeamReplicate(255,true);
				//Health = BuildingVisuals.HealthMax;
			}
		}
		else if (Amount < 0)
			TriggerUnderAttack();
		return True;
	}
	
	return false;
}

