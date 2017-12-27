class AGN_Vehicle_TickTank extends TS_Vehicle_TickTank notplaceable;

simulated event PostBeginPlay()
{
	local MaterialInstanceConstant Parent;
	local MaterialInstanceConstant Temp;
	
	Super.PostBeginPlay();
	
	// Half chance to get a cool camo skin
	if ( FRand() > 0.0f )
		return; 
	
	Temp = Mesh.CreateAndSetMaterialInstanceConstant(0);
	Parent = MaterialInstanceConstant'RX_ENV_FORT.VehicleMaterials.MI_TickTank';
	Temp.SetParent(Parent);
	Temp.SetScalarParameterValue('Camo_Offset_Seed', FRand());
	Temp.SetScalarParameterValue('Camo_Scale_Seed', (FRand() % 0.4) + 0.8);
}

DefaultProperties
{

	TakeDamageMultiplier = 0.85; //0.65 (why the hell was it ever this?)

	SkeletalMeshForPT=SkeletalMesh'TS_VH_TickTank.Mesh.SK_VH_TickTank'
}