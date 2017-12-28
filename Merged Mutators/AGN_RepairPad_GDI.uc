class AGN_RepairPad_GDI extends AGN_RepairPad
	placeable;
	
simulated function String GetHumanReadableName()
{
	return "[AGN] GDI Repair Facility"; 
}

// Don't trigger Building Alarm if hitting the Repair Pad.
simulated function bool IsEffectedByEMP()
{
	return false;
}

// ParticleSystem'AGN_FX_Package.Particles.Explosions.P_RepairField'

defaultproperties
{
	BuildingInternalsClass = AGN_RepairPad_GDI_Internals
	
	Begin Object Class=StaticMeshComponent Name=AGN_RepairPad_GDI
		StaticMesh = StaticMesh'AGN_BU_RepairFacility.Meshes.SM_RepFacility_GDI'
		Scale = 8.709648
		//LightingChannels=(bInitialized=True,Static=True)
		LightingChannels=(bInitialized=True,BSP=False,Static=False,Dynamic=True,CompositeDynamic=True,Skybox=False,Unnamed_1=False,Unnamed_2=False,Unnamed_3=False,Unnamed_4=False,Unnamed_5=False,Unnamed_6=False,Cinematic_1=False,Cinematic_2=False,Cinematic_3=False,Cinematic_4=False,Cinematic_5=False,Cinematic_6=False,Cinematic_7=False,Cinematic_8=False,Cinematic_9=False,Cinematic_10=False,Gameplay_1=False,Gameplay_2=False,Gameplay_3=False,Gameplay_4=False,Crowd=False)
	End Object
		
    Begin Object Name=Static_Interior
        StaticMesh = None
		LightingChannels=(bInitialized=False,Static=True)
    End Object

    Begin Object Name=PT_Screens
        StaticMesh = None
    End Object
	
	bStatic=false
	bNoDelete=false
	TeamID = TEAM_GDI
	bMovable=true

	Components.Add(AGN_RepairPad_GDI)
	Components.Add(Static_Interior);
	Components.Add(PT_Screens);
	
}