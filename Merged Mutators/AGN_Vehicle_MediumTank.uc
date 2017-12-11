class AGN_Vehicle_MediumTank extends RX_Vehicle_MediumTank notplaceable;

simulated event PostBeginPlay()
{
	local MaterialInstanceConstant Parent;
	local MaterialInstanceConstant Temp;
	
	Super.PostBeginPlay();
	
	// Half chance to get a cool camo skin
	if ( FRand() < 0.5f )
		return; 
	
	Temp = Mesh.CreateAndSetMaterialInstanceConstant(0);
	Parent = MaterialInstanceConstant'RX_ENV_FORT.VehicleMaterials.MI_VH_MediumTank';
	Temp.SetParent(Parent);
	Temp.SetScalarParameterValue('Camo_Offset_Seed', FRand());
	Temp.SetScalarParameterValue('Camo_Scale_Seed', (FRand() % 0.4) + 2.8);
}