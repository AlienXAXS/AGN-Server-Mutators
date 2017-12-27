class AGN_RepairPad_Nod extends AGN_RepairPad
	placeable;
	
simulated function String GetHumanReadableName()
{
	return "[AGN] Nod Repair Facility"; 
}

// Don't trigger Building Alarm if hitting the Repair Pad.
simulated function bool IsEffectedByEMP()
{
	return false;
}

defaultproperties
{
	BuildingInternalsClass = AGN_RepairPad_Nod_Internals
	
	Begin Object Class=StaticMeshComponent Name=AGN_RepairPad_Nod
		StaticMesh=StaticMesh'RX_BU_RepairFacility.Meshes.SM_RepFacility_Nod'
		Scale=8.709648
		LightingChannels=(bInitialized=True,BSP=False,Static=False,Dynamic=True,CompositeDynamic=True,Skybox=False,Unnamed_1=False,Unnamed_2=False,Unnamed_3=False,Unnamed_4=False,Unnamed_5=False,Unnamed_6=False,Cinematic_1=False,Cinematic_2=False,Cinematic_3=False,Cinematic_4=False,Cinematic_5=False,Cinematic_6=False,Cinematic_7=False,Cinematic_8=False,Cinematic_9=False,Cinematic_10=False,Gameplay_1=False,Gameplay_2=False,Gameplay_3=False,Gameplay_4=False,Crowd=False)
		Name="AGN_RepairPad_Nod"
	End Object

    Begin Object Name=PT_Screens
        StaticMesh = none
    End Object

	Begin Object name=Static_Interior_Complex
        ReplacementPrimitive=none
    End Object

	bStatic=false
	bNoDelete=false
	TeamID = TEAM_NOD
	bMovable=true

	Components.Add(AGN_RepairPad_Nod)
}