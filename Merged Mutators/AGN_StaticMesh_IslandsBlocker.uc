class AGN_StaticMesh_IslandsBlocker extends Rx_Building;

simulated function String GetHumanReadableName()
{
	return "Indestructible Wall Segment";
}

defaultproperties
{
	BuildingInternalsClass = AGN_StaticMesh_IslandsBlocker_Internals
	Begin Object Class=StaticMeshComponent Name=AGN_StaticMesh_IslandsRock
		StaticMesh=StaticMesh'RX_Deco_Barrier.Meshes.SM_Wall_Prison_2Point'
		LightingChannels=(bInitialized=True,BSP=False,Static=False,Dynamic=True,CompositeDynamic=True)
		Scale=2.75
	End Object
	
	bStatic=false
	bNoDelete=false
	TeamID = 255
	bMovable=true

	Components.Add(AGN_StaticMesh_IslandsRock)
}