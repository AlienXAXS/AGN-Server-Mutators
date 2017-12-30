class AGN_DmgType_PersonalObeliskCannon extends Rx_DmgType_Electric;

defaultproperties
{
    KillStatsName=KILLS_PERSONALIONCANNON
    DeathStatsName=DEATHS_PERSONALIONCANNON
    SuicideStatsName=SUICIDES_PERSONALIONCANNON

//    DamageWeaponClass=class'Rx_Weapon_PersonalIonCannon'
    DamageWeaponFireMode=2
    VehicleDamageScaling=0.428
    NodeDamageScaling=0.5
    VehicleMomentumScaling=0.025

    CustomTauntIndex=10
    lightArmorDmgScaling=0.5
    BuildingDamageScaling=0
	MCTDamageScaling=0
	MineDamageScaling=0
	
	BleedDamageFactor=0.01
	BleedCount=8
	
	////Infantry Armour Types//////
	Inf_FLAKDamageScaling = 0.95     //FLAK infantry armour (Standard rule is splash damage does  50% less, while gun damage does 30% more)
	Inf_KevlarDamageScaling = 0.95	//Kevlar (General rule is 15% less damage from direct hits/bullets, but no penalties) - EDIT: 20% -Remotes OP 
	Inf_LazarusDamageScaling = 0.95  // Lazarus SBH armour, standard rule is +40% to Electrical damage but likely no other damage modifiers.

	
	KDamageImpulse=20000
	KDeathUpKick=100

	IconTextureName="T_WeaponIcon_PersonalIonCannon"
	IconTexture=Texture2D'RX_WP_PersonalIonCannon.UI.T_WeaponIcon_PersonalIonCannon'
}