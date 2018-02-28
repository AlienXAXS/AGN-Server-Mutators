/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_RepairPad_GDI_Internals extends Rx_Building_Team_Internals
	notplaceable;

DefaultProperties
{

	FriendlyBuildingSounds(BuildingDestroyed)           = SoundNodeWave'RX_EVA_VoiceClips.nod_EVA.S_EVA_Nod_GDIRepairFacility_Destroyed'
    //FriendlyBuildingSounds(BuildingUnderAttack)         = SoundNodeWave'RX_EVA_VoiceClips.nod_eva.S_EVA_Nod_AirStrip_UnderAttack'
    //FriendlyBuildingSounds(BuildingRepaired)            = SoundNodeWave'RX_EVA_VoiceClips.nod_eva.S_EVA_Nod_AirStrip_Repaired'
    //FriendlyBuildingSounds(BuildingDestructionImminent) = SoundNodeWave'RX_EVA_VoiceClips.nod_eva.S_EVA_Nod_AirStrip_DestructionImminent'
    EnemyBuildingSounds(BuildingDestroyed)              = SoundNodeWave'RX_EVA_VoiceClips.nod_eva.S_EVA_Nod_GDIRepairFacility_Destroyed'
    EnemyBuildingSounds(BuildingUnderAttack)            = SoundNodeWave'RX_EVA_VoiceClips.nod_eva.S_EVA_Nod_GDIRepairFacility_UnderAttack'

	HDamagePointsScale		= 0.50f
	ADamagePointsScale		= 0.05f

	HealPointsScale         = 0.04f
	Destroyed_Score			= 1000 // Total number of points divided out when  
	
	HealthMax               = 4600
	BA_HealthMax			= 4600
	DestructionAnimName     = "BuildingDeath"
	LowHPWarnLevel          = 200 // critical Health level
	RepairedHPLevel         = 3400
	RepairedArmorLevel		= 1200 
	bBuildingRecoverable    = false
	TeamID                  = TEAM_GDI
	MessageClass            = class'Rx_Message_Buildings'
	MessageWaitTime         = 15.0f

	DamageLodLevel          = 1
	bInitialDamageLod       = true
	
	ArmorResetTime			= 300 //5 Minute time between being able to be rewarded for breaking armor (Seconds)
	bCanArmorBreak 			= true
	HealthLocked			= false 
}

