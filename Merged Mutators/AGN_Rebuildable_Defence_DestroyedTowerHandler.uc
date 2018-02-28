class AGN_Rebuildable_Defence_DestroyedTowerHandler extends Rx_Vehicle
	implements (Rx_ObjectTooltipInterface); 

var repnotify int CreditsNeededToActivate;
var int DefencePurchasePrice;

var AGN_Rebuildable_Defence_Handler Handler;
var int HandlerIdentifier;

var const byte TeamID;

replication
{
	if (bNetDirty && Role<=Role_Authority)
		CreditsNeededToActivate;
}

function InitializeDefence(AGN_Rebuildable_Defence_Handler ourHandler, int OurHandlerIdentifier) {
	Handler = ourHandler;
	HandlerIdentifier = OurHandlerIdentifier;
	SetTeamNum(TeamID);
	
	Health = 1;
}

function SetPurchasePrice(int price)
{
	CreditsNeededToActivate = price;
	DefencePurchasePrice = price;
}

simulated event Tick (float DeltaTime)
{
    Local Rotator NewRotation;
    
    NewRotation = self.Rotation;
    NewRotation.Yaw += DeltaTime * 12768;
    self.SetRotation(NewRotation);
	
	Super.Tick(DeltaTime);
}

simulated function bool IsBasicOnly() { return true; }
simulated function bool IsTouchingOnly() { return false; }
simulated function String GetHumanReadableName() { return "[AGN] Rebuildable Defense Building"; }

simulated function string GetTooltip(Rx_Controller PC)
{
	if ( PC.GetTeamNum() != TeamID )
		return "";

	return "Offline: Use repair gun to purchase, needs <font color='#ff0000' size='20'>" $ CreditsNeededToActivate $ "</font> more credits";
}

simulated function bool CanEnterVehicle(Pawn P)
{
	return false;
}

simulated event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	// This building cannot be damaged
}

// Deals with repairing this structure once it's dead.
function bool HealDamage(int Amount, Controller Healer, class<DamageType> DamageType)
{
	local Rx_PRI playerRepInfo;
	local float captureProgress;
	
	// Our tower is dead, let's activate it.
	if ( Rx_Controller(Healer).PlayerReplicationInfo != None )
	{
		playerRepInfo = Rx_PRI(Rx_Controller(Healer).PlayerReplicationInfo);
		// Can the reparing player afford this?
		if ( playerRepInfo.GetCredits() > 0 )
		{
			playerRepInfo.RemoveCredits(Amount);
			CreditsNeededToActivate = CreditsNeededToActivate - Amount;
			captureProgress = (((float(DefencePurchasePrice - CreditsNeededToActivate) / DefencePurchasePrice) * 100) * 10);
			Health = int(captureProgress) == 0 ? 1 : int(captureProgress);
			// Update the health of the tower to show progress of purchase
			if ( CreditsNeededToActivate < 1 )
			{
				// Activate the tower
				ActivateStructure();
			}
		}
	}
	
	return Super(UTVehicle).HealDamage(0, Healer, DamageType);
}

function ActivateStructure()
{
	if ( Handler != None )
		Handler.CallInTowerAirDropFromTowerID(TeamID, HandlerIdentifier);
		
	self.Destroy();
}

defaultproperties
{	
	Seats(0)={(GunClass=class'Rx_Defence_GuardTower_Weapon',
			GunSocket=(MuzzleFlashSocket),
			TurretControls=(TurretPitch,TurretRotate),
			GunPivotPoints=(GunYaw,GunPitch),
			CameraTag=CamView3P,
			CameraBaseOffset=(Z=-50),
			CameraOffset=-600,
			SeatIconPos=(X=0.5,Y=0.33),
			MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'
			)}
			
	bReplicateMovement=false
}