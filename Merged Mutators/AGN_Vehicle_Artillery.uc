class AGN_Vehicle_Artillery extends RX_Vehicle_Artillery notplaceable;

simulated event PostBeginPlay()
{
	local MaterialInstanceConstant Parent;
	local MaterialInstanceConstant Temp;
	
	Super.PostBeginPlay();
	
	// Half chance to get a cool camo skin
	if ( FRand() < 0.5f )
		return; 
	
	Temp = Mesh.CreateAndSetMaterialInstanceConstant(0);
	Parent = MaterialInstanceConstant'RX_ENV_FORT.VehicleMaterials.MI_VH_Artillery';
	Temp.SetParent(Parent);
	Temp.SetScalarParameterValue('Camo_Offset_Seed', FRand());
	Temp.SetScalarParameterValue('Camo_Scale_Seed', (FRand() % 0.4) + 0.8);
}