/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_Weapon_IonCannonBeacon extends AGN_Weapon_Beacon;

DefaultProperties
{
	ArmsAnimSet=AnimSet'RX_WP_IonCannon.Anims.AS_IonCannonBeacon_Arms'

	DeployedActorClass=class'Rx_Weapon_DeployedIonCannonBeacon'

   	PanelWidth  = 0.25f
   	PanelHeight = 0.033f
   	PanelColor  = (B=128, G=255, R=0, A=255)
   	
   	AttachmentClass = class'Rx_Attachment_IonCannonBeacon'

   	PlayerViewOffset=(X=10.0,Y=0.0,Z=-2.5)
	ChargeCue = SoundCue'RX_WP_Nuke.Sounds.Nuke_DeployingCue'
	
	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'RX_WP_IonCannon.Mesh.SK_IonCannonBeacon_1P'
		AnimSets(0)=AnimSet'RX_WP_IonCannon.Anims.AS_IonCannonBeacon_1P'
		Animations=MeshSequenceA
		FOV=55.0
		Scale=2.0
	End Object
	
	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'RX_WP_IonCannon.Mesh.SK_ICBeacon_3P'
		Scale=1.0
	End Object

	InventoryMovieGroup=17

	WeaponIconTexture=Texture2D'RX_WP_IonCannon.UI.T_WeaponIcon_IonCannonBeacon'

	BackWeaponAttachmentClass = class'Rx_BackWeaponAttachment_IonCannonBeacon'
}

