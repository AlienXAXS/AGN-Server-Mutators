/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_Vehicle_ReconBike_DmgType extends TS_Vehicle_ReconBike_DmgType;

defaultproperties
{
	KillStatsName=KILLS_RECONBIKE
  	DeathStatsName=DEATHS_RECONBIKE
  	SuicideStatsName=SUICIDES_RECONBIKE

  	VehicleDamageScaling=0.48
	lightArmorDmgScaling=0.48
	AircraftDamageScaling=0.60
  	BuildingDamageScaling=0.96f
	MineDamageScaling=2.0

	IconTextureName="T_DeathIcon_ReconBike"
	IconTexture=Texture2D'TS_VH_ReconBike.Materials.T_DeathIcon_ReconBike'
}
