class AGN_RepairPad_GDI_Internals extends Rx_Building_Team_Internals
	notplaceable;

DefaultProperties
{
	Begin Object Name=BuildingSkeletalMeshComponent
		SkeletalMesh        = None
		AnimSets(0)         = None
		AnimTreeTemplate    = None
		PhysicsAsset        = None
	End Object

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
	
	HealthMax               = 4000
	BA_HealthMax			= 4800 //Slightly more health for building armour, but obviously with half of it being unrepairable. 
	DestructionAnimName     = "BuildingDeath"
	LowHPWarnLevel          = 200 // critical Health level
	RepairedHPLevel         = 3400 // 85%
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
