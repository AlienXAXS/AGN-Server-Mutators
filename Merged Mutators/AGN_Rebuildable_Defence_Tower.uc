class AGN_Rebuildable_Defence_Tower extends Rx_Defence_GuardTower
	implements (Rx_ObjectTooltipInterface); 

var class<AGN_Rebuildable_Defence_Controller> AGN_DefenceControllerClass;

var repnotify bool bDefenseIsActive;
var repnotify int CreditsNeededToActivate;
var int DefencePurchasePrice;
var UTPawn Px;

replication
{
	if (bNetDirty && Role<=Role_Authority)
		bDefenseIsActive, CreditsNeededToActivate;
}

simulated function String GetHumanReadableName()
{
	return "[AGN] Rebuildable Gun Tower";
}

simulated function string GetTargetedDescription(PlayerController PlayerPerspective)
{
	if ( bDefenseIsActive )
		return "TOWER ONLINE";
	else
		return "TOWER OFFLINE";
}

simulated function string GetTooltip(Rx_Controller PC)
{
	if ( PC.GetTeamNum() != TeamID )
		return "";

	if ( !bDefenseIsActive )
		return "Tower Offline <font color='#ff0000' size='20'>repair gun</font> to purchase, needs " $ CreditsNeededToActivate $ " more credits";
	else
		return "<font color='#00ff00' size='20'>Tower is Online</font>";
}

simulated function bool IsBasicOnly()
{
	return true;
}

simulated function bool IsTouchingOnly()
{
	return false;
}

function SetPurchasePrice(int PurchasePrice)
{
	DefencePurchasePrice = PurchasePrice;
}

// Only set team here.
function Initialize() { SetTeamNum(TeamID); }

function InitializeDefence() {
	SetTimer(3, false, 'RealInit');
}

function RealInit()
{
	local vector tv;
	
	`log("Init Defence Turret");
	SetTeamNum(TeamID);
	ai = Spawn(AGN_DefenceControllerClass,self);
	ai.SetOwner(None);  // Must set ai owner back to None, because when the ai possesses this actor, it calls SetOwner - and it would fail due to Onwer loop if we still owned it.

	ai.Possess(self, true);
	bAIControl = true;
	
	/*    Spawning a UTPawn with a UTVehicle_Nod_Turret_Controller
	*     to make it the 'Driver' of the Turret.
	*     Spawning and entering had to be delayed a bit to make it work.
	*/
	tv = Location;
	tv.z += 50;
	tv.x += 50;
	Px = Spawn(class'UTPawn',,,tv,,,true);
	Px.bIsInvisible=true;
	ai.Possess(Px, true);
	setTimer(0.1,false,'enter');
}

function enter(){
    if(Driver == None)
        DriverEnter(Px);
    ai.Pawn.PeripheralVision = -1.0;
}

simulated event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	if ( bDefenseIsActive )
	{
		if ( Health - Damage < 1 )
		{
			// Ensures the building never actually dies
			DeactivateStructure();
		} else
			Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	} else {
		Super.TakeDamage(0, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	}
}

// Deals with repairing this structure once it's dead.
function bool HealDamage(int Amount, Controller Healer, class<DamageType> DamageType)
{
	local Rx_PRI playerRepInfo;
	local float captureProgress;
	
	if ( bDefenseIsActive && CreditsNeededToActivate == 0 )
		return Super(Rx_Vehicle).HealDamage(Amount, Healer, DamageType);
	else
	{	
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
}

reliable server function ServerActivateStructure()
{
	bDefenseIsActive = true;
}

function ActivateStructure()
{
	if(`WorldInfoObject.NetMode == NM_DedicatedServer)
	{
		`log("Activating Defense Tower - Server Side");
		ServerActivateStructure();
		AGN_Rebuildable_Defence_Controller(ai).SetDefenceActive(true);
		Health = HealthMax;
	} else {
		`log("Activating Defense Tower - Client Side");
		bDefenseIsActive = true;
	}
}

reliable server function ServerDeactivateStructure()
{
	bDefenseIsActive = false;
}

function DeactivateStructure()
{
	if(`WorldInfoObject.NetMode == NM_DedicatedServer)
	{
		`log("Deactivating Defense Tower - Server Side");
		ServerDeactivateStructure();
		AGN_Rebuildable_Defence_Controller(ai).SetDefenceActive(false);
		Health = 1;
		CreditsNeededToActivate = DefencePurchasePrice;
	} else {
		`log("Deactivating Defense Tower - Client Side");
		bDefenseIsActive = false;
	}
}

defaultproperties
{
	bDefenseIsActive = true;
	CreditsNeededToActivate = 0;
	AGN_DefenceControllerClass = class'AGN_Rebuildable_Defence_Controller';
	TeamID = 0;
}