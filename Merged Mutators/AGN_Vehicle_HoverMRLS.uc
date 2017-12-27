class AGN_Vehicle_HoverMRLS extends TS_Vehicle_HoverMRLS notplaceable;

simulated event PostBeginPlay()
{
	local MaterialInstanceConstant Parent;
	local MaterialInstanceConstant Temp;
	
	Super.PostBeginPlay();
	
	// Half chance to get a cool camo skin
	if ( FRand() > 0.0f )
		return; 
	
	Temp = Mesh.CreateAndSetMaterialInstanceConstant(0);
	Parent = MaterialInstanceConstant'RX_ENV_FORT.VehicleMaterials.MI_VH_HoverMRLS';
	Temp.SetParent(Parent);
	Temp.SetScalarParameterValue('Camo_Offset_Seed', FRand());
	Temp.SetScalarParameterValue('Camo_Scale_Seed', (FRand() % 0.4) + 2.8);
}

DefaultProperties
{
	Seats(0)={(GunClass=class'AGN_Vehicle_HoverMRLS_Weapon',
                GunSocket=(Fire_L,Fire_R),
                TurretControls=(TurretPitch,TurretRotate),
                GunPivotPoints=(b_Turret_Yaw,b_Turret_Pitch),
                CameraTag=CamView3P,
                CameraBaseOffset=(Z=-24),
                CameraOffset=-660,
                SeatIconPos=(X=0.5,Y=0.33),
                MuzzleFlashLightClass=class'Rx_Light_Tank_MuzzleFlash'
                )}
}