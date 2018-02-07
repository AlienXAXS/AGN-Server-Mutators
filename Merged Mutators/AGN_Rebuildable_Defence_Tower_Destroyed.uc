class AGN_Rebuildable_Defence_Tower_Destroyed extends AGN_Rebuildable_Defence_DestroyedTowerHandler
	placeable;

DefaultProperties
{
	TeamID=0;

//========================================================\\
//************** Vehicle Physics Properties **************\\
//========================================================\\


    Health=1000
    bLightArmor=false
    bCollideWorld = false
    Physics=PHYS_None
    
    CameraLag=0.1 //0.2
    LookForwardDist=200
    HornIndex=1
    COMOffset=(x=0.0,y=0.0,z=-55.0)
    
    bUsesBullets = true
    bIgnoreEncroachers=True
    bSeparateTurretFocus=false
    bCanCarryFlag=false
    bCanStrafe=false
    bFollowLookDir=true
    bTurnInPlace=true
    bCanFlip=False
    bHardAttach=true
    
    MaxDesireability=0.8
    MomentumMult=0.7
    
    AIPurpose=AIP_Defensive
	

//========================================================\\
//*************** Vehicle Visual Properties **************\\
//========================================================\\


    Begin Object Name=CollisionCylinder
        CollisionHeight=60.0
        CollisionRadius=260.0
        Translation=(X=0.0,Y=0.0,Z=0.0)
    End Object
    CylinderComponent=CollisionCylinder    

    Begin Object name=SVehicleMesh
        SkeletalMesh=SkeletalMesh'RX_DEF_GuardTower.Mesh.SK_DEF_GuardTower'
        AnimTreeTemplate=AnimTree'RX_DEF_GuardTower.Anims.AT_DEF_GuardTower'
        PhysicsAsset=PhysicsAsset'RX_DEF_GuardTower.Mesh.SK_DEF_GuardTower_Physics'
		MorphSets[0]=MorphTargetSet'RX_DEF_GuardTower.Mesh.MT_DEF_GuardTower'
		Scale=0.35f
    End Object

    DrawScale=1.0

	VehicleIconTexture=Texture2D'RX_DEF_GuardTower.UI.T_VehicleIcon_GuardTower'
	MinimapIconTexture=Texture2D'RX_DEF_GuardTower.UI.T_MinimapIcon_GuardTower'
	

//========================================================\\
//********* Vehicle Material & Effect Properties *********\\
//========================================================\\

    BurnOutMaterial[0]=MaterialInstanceConstant'RX_DEF_GuardTower.Materials.MI_VH_GuardTower_BO'
    BurnOutMaterial[1]=MaterialInstanceConstant'RX_DEF_GuardTower.Materials.MI_VH_GuardTower_BO'

    DrivingPhysicalMaterial=PhysicalMaterial'RX_VH_Humvee.Materials.PhysMat_HumveeDriving'
    DefaultPhysicalMaterial=PhysicalMaterial'RX_VH_Humvee.Materials.PhysMat_Humvee'

    RecoilTriggerTag = "MainGun"
    VehicleEffects(0)=(EffectStartTag="MainGun",EffectEndTag="STOP_MainGun",bRestartRunning=false,EffectTemplate=ParticleSystem'RX_VH_Humvee.Effects.P_MuzzleFlash_50Cal_Looping',EffectSocket="MuzzleFlashSocket")
    VehicleEffects(1)=(EffectStartTag="MainGun",EffectEndTag="STOP_MainGun",bRestartRunning=false,EffectTemplate=ParticleSystem'RX_DEF_GuardTower.Effects.P_ShellCasing_Looping',EffectSocket="ShellCasingSocket")
    VehicleEffects(2)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_EngineFire_Thick',EffectSocket=DamageSmoke01)

    WheelParticleEffects[0]=(MaterialType=Generic,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Dirt')
    WheelParticleEffects[1]=(MaterialType=Dirt,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Dirt')
    WheelParticleEffects[2]=(MaterialType=Water,ParticleTemplate=ParticleSystem'Envy_Level_Effects_2.Vehicle_Water_Effects.P_Scorpion_Water_Splash')
    WheelParticleEffects[3]=(MaterialType=Snow,ParticleTemplate=ParticleSystem'Envy_Level_Effects_2.Vehicle_Snow_Effects.P_Scorpion_Wheel_Snow')

    BigExplosionTemplates[0]=(Template=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Vehicle_Huge')
    BigExplosionSocket=VH_Death
	
	DamageMorphTargets(0)=(InfluenceBone=MT_FL,MorphNodeName=MorphNodeW_FL,LinkedMorphNodeName=none,Health=300,DamagePropNames=(Damage1))
    DamageMorphTargets(1)=(InfluenceBone=MT_FR,MorphNodeName=MorphNodeW_FR,LinkedMorphNodeName=none,Health=300,DamagePropNames=(Damage2))
    DamageMorphTargets(2)=(InfluenceBone=MT_BL,MorphNodeName=MorphNodeW_BL,LinkedMorphNodeName=none,Health=300,DamagePropNames=(Damage3))
    DamageMorphTargets(3)=(InfluenceBone=MT_BR,MorphNodeName=MorphNodeW_BR,LinkedMorphNodeName=none,Health=300,DamagePropNames=(Damage4))

    DamageParamScaleLevels(0)=(DamageParamName=Damage1,Scale=2.0)
    DamageParamScaleLevels(1)=(DamageParamName=Damage2,Scale=2.0)
    DamageParamScaleLevels(2)=(DamageParamName=Damage3,Scale=2.0)
    DamageParamScaleLevels(3)=(DamageParamName=Damage4,Scale=0.2)
}