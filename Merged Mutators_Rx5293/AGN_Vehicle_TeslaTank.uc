/*
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 *
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 *
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 *
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_Vehicle_TeslaTank extends APB_Vehicle_TeslaTank notplaceable;

DefaultProperties
{
	Seats(0)={(GunClass=class'AGN_Vehicle_TeslaTank_Weapon',
                GunSocket=(Fire01),
                TurretControls=(TurretPitch,TurretRotate),
                GunPivotPoints=(MainTurretYaw,MainTurretPitch),
                CameraTag=CamView3P,
                CameraBaseOffset=(Z=-50),
                CameraOffset=-600,
                SeatIconPos=(X=0.5,Y=0.33),
                MuzzleFlashLightClass=class'APB_Light_TeslaTank_MuzzleFlash'
                )}

	Vet_HealthMod(0)=1 //600
	Vet_HealthMod(1)=1.1 //660
	Vet_HealthMod(2)=1.2 //720
	Vet_HealthMod(3)=1.3 //780

	Vet_SprintSpeedMod(0)=1
	Vet_SprintSpeedMod(1)=1
	Vet_SprintSpeedMod(2)=1.05
	Vet_SprintSpeedMod(3)=1.10
}
