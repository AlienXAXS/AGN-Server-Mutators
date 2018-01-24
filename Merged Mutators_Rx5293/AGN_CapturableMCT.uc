/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_CapturableMCT extends Rx_CapturableMCT
   placeable;

simulated function String GetHumanReadableName()
{
	return ReadableName;
}

simulated function bool IsTouchingOnly()
{
	return false;
}

simulated function bool IsBasicOnly()
{
	return true;
}

simulated function string GetTooltip(Rx_Controller PC)
{
	if (class'Rx_Utils'.static.OrientationToB(self, PC.Pawn) > 0.1)
	return ToolTip;
}

defaultproperties
{
	BuildingInternalsClass  = class'AGN_BaseDefenceMCT_Internals'

    Begin Object Name=SiloScreens
        CastShadow                      = True
		AlwaysLoadOnClient              = True
		AlwaysLoadOnServer              = True
		CollideActors                   = True
		BlockActors                     = True
		BlockRigidBody                  = True
		BlockZeroExtent                 = True
		BlockNonZeroExtent              = True
		bCastDynamicShadow              = True
		bAcceptsLights                  = True
		bAcceptsDecalsDuringGameplay    = True
		bAcceptsDecals                  = True
		bAllowApproximateOcclusion      = True
		bUsePrecomputedShadows          = True
		bForceDirectLightMap            = True
		bAcceptsDynamicLights           = False
		LightingChannels                = (bInitialized=True,Static=True)
        StaticMesh                      = StaticMesh'rx_deco_terminal.Mesh.SM_BU_MCT_Visible' //StaticMesh'RX_BU_Silo.Meshes.SM_BU_MCT_Visible'
		//Translation						= (Z=-9999)
    End Object
	StaticMeshPieces.Add(SiloScreens)
	Components.Add(SiloScreens)
	
	bStatic=false
	bNoDelete=false
	bMovable=true
	
	Mesh = SiloScreens
	ReadableName = "[AGN] Base Defense System"
	ToolTip="Use the <font color='#ff0000' size='20'>Repair Gun</font> to replace this Base Defense once dead."
}

