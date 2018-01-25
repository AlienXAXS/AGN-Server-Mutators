/*
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 *
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 *
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 *
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_RepairPad_GDI extends AGN_RepairPad implements (Rx_ObjectTooltipInterface)
	placeable;

	var string ToolTip;

simulated function String GetHumanReadableName()
{
	return "[AGN] GDI Repair Facility";
}

// Don't trigger Building Alarm if hitting the Repair Pad.
simulated function bool IsEffectedByEMP()
{
	return false;
}

simulated function string GetTooltip(Rx_Controller PC)
{
	if (PC.GetTeamNum() == GetTeamNum() && !isDestroyed())
		return ToolTip;
	else
		return "";
}

simulated function bool IsBasicOnly()
{
	return true;
}

simulated function bool IsTouchingOnly()
{
	return false;
}

// ParticleSystem'AGN_FX_Package.Particles.Explosions.P_RepairField'

defaultproperties
{
	ToolTip = "Driving on top of the Repair Facility will repair your vehicle for <font color='#ff0000' size='20'>1 credit/25 HP</font>";
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
