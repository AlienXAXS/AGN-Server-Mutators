class AGN_Vehicle_FlameTank extends RX_Vehicle_FlameTank notplaceable;

simulated event PostBeginPlay()
{
	local MaterialInstanceConstant Parent;
	local MaterialInstanceConstant Temp;
	
	Super.PostBeginPlay();
	
	// Half chance to get a cool camo skin
	if ( FRand() > 0.0f )
		return; 
	
	Temp = Mesh.CreateAndSetMaterialInstanceConstant(0);
	Parent = MaterialInstanceConstant'RX_ENV_FORT.VehicleMaterials.MI_VH_FlameTank';
	Temp.SetParent(Parent);
	Temp.SetScalarParameterValue('Camo_Offset_Seed', FRand());
	Temp.SetScalarParameterValue('Camo_Scale_Seed', (FRand() % 0.4) + 0.8);
}

DefaultProperties
{
	Seats(0)={(GunClass=class'AGN_Vehicle_FlameTank_Weapon',
                GunSocket=(Fire01,Fire02),
                TurretControls=("TurretPitch","TurretRotate"),
                TurretVarPrefix="",
                GunPivotPoints=("MainTurretYaw"),
                CameraTag=CamView3P,
                CameraBaseOffset=(Z=-10),
				SeatBone=Base,
				SeatSocket=VH_Death,
                CameraOffset=-460,
                SeatIconPos=(X=0.5,Y=0.33),
                MuzzleFlashLightClass=class'Rx_Light_Tank_MuzzleFlash'
                )}
}