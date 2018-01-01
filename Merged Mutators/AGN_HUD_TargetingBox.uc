/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_HUD_TargetingBox extends Rx_HUD_TargetingBox;

function Update(float DeltaTime, Rx_HUD HUD)
{
	super.Update(DeltaTime, HUD);

	TimeSinceNewTarget += DeltaTime;

	UpdateTargetedObject(DeltaTime);

	if (TargetedActor != none)
	{
		UpdateTargetName();
		UpdateTargetHealthPercent();
		UpdateTargetDescription();
		UpdateBoundingBox();
		//UpdateTargetStance(TargetedActor);
	}
}

function bool IsValidTarget (actor potentialTarget)
{
	if (Rx_Building(potentialTarget) != none ||
		(Rx_BuildingAttachment(potentialTarget) != none && Rx_BuildingAttachment_Door(potentialTarget) == none) ||
		Rx_Building_Internals(potentialTarget) != none ||
		(Rx_Vehicle(potentialTarget) != none && Rx_Vehicle(potentialTarget).Health > 0) ||
		(Rx_Weapon_DeployedActor(potentialTarget) != none && Rx_Weapon_DeployedActor(potentialTarget).GetHealth() > 0) ||
		(Rx_Pawn(potentialTarget) != none && Rx_Pawn(potentialTarget).Health > 0)||
		(Rx_DestroyableObstaclePlus(potentialTarget) !=none && Rx_DestroyableObstaclePlus(potentialTarget).bShowHealth && Rx_DestroyableObstaclePlus(potentialTarget).GetHealth() > 0) /* ||
		(AGN_Pickup(potentialTarget) != none && !AGN_Pickup(potentialTarget).isHiddenCrate) */
		)
	{
		if (IsStealthedEnemyUnit(Pawn(potentialTarget)) ||
			potentialTarget == RenxHud.PlayerOwner.ViewTarget ||
			(Rx_VehicleSeatPawn(RenxHud.PlayerOwner.ViewTarget) != none && potentialTarget == Rx_VehicleSeatPawn(RenxHud.PlayerOwner.ViewTarget).MyVehicle))
		return false;
		else return true;
	}
	else return false;
}

function UpdateTargetedObject (float DeltaTime)
{
	local Actor potentialTarget;
	
	// Our potential target is the actor we're looking at.
	potentialTarget = GetActorAtScreenCentre();
	// If that's a valid target, then it becomes our target.
	if (IsValidTarget(potentialTarget) && IsTargetInRange(potentialTarget)) {
		SetTarget(potentialTarget);
	}
	// If we're not looking at the targetted building anymore, automatically untarget it.
	else if (TargetedActor != none && IsBuildingComponent(TargetedActor) && !IsPTorMCT(TargetedActor)) {
		TargetedActor = none;
	}
	// If the targeted actor is out of view, or out of range we should untarget it.
	else if (TargetedActor != none && (!IsValidTarget(TargetedActor) || !IsActorInView(TargetedActor,true) || !IsTargetInRange(TargetedActor)) ) {
		if (Rx_Pawn(TargetedActor) != none) {
			Rx_Pawn(TargetedActor).bTargetted = false;
		} else if (Rx_Vehicle(TargetedActor) != none) {
			Rx_Vehicle(TargetedActor).bTargetted = false;
		}
		TargetedActor = none;
	}		
	// If we're here, that means we're not looking at it, but it's still on screen and in range, so start countdown to untarget it
	else {
		TimeSinceTargetLost += DeltaTime;
	}
		

	// If our target has expired, clear it.
	if (TimeSinceTargetLost > TargetStickTime){
		if (Rx_Pawn(TargetedActor) != none) {
			Rx_Pawn(TargetedActor).bTargetted = false;
		} else if (Rx_Vehicle(TargetedActor) != none) {
			Rx_Vehicle(TargetedActor).bTargetted = false;
		}
		TargetedActor = none;	
	}
}

function bool IsTargetInRange(actor a)
{
	local float TargetDistance, WeaponTargetRange;

	if (IsBuildingComponent(a))
		return true;

	TargetDistance = GetTargetDistance(a);
	WeaponTargetRange = GetWeaponTargetingRange();
	if (TargetDistance >= WeaponTargetRange)
			return false;
	else return true;
}

function UpdateTargetHealthPercent ()
{
	TargetArmorPercent = 0;
	bHasArmor = false;
	
	if (IsTechBuildingComponent(TargetedActor) && !IsPTorMCT(TargetedActor))
	{
		TargetHealthPercent = -1;
		return;
	}
	
	if (Rx_Pawn(TargetedActor) != none)
	{
		TargetHealthPercent =  (float(Rx_Pawn(TargetedActor).Health) + float(Rx_Pawn(TargetedActor).Armor)) / max(1,float(Rx_Pawn(TargetedActor).HealthMax) + float(Rx_Pawn(TargetedActor).ArmorMax));
	}
	else if (Pawn(TargetedActor) != none)
	{
		TargetHealthPercent =  float(Pawn(TargetedActor).Health) / max(1, float(Pawn(TargetedActor).HealthMax));
	}
	else if (Rx_Weapon_DeployedActor(TargetedActor) != none && !Rx_Weapon_DeployedActor(TargetedActor).bCanNotBeDisarmedAnymore)
	{
		TargetHealthPercent = float(Rx_Weapon_DeployedActor(TargetedActor).GetHealth()) / max(1, float(Rx_Weapon_DeployedActor(TargetedActor).GetMaxHealth()));
	}
	else if (Rx_DestroyableObstaclePlus(TargetedActor) != none)
	{
		TargetHealthPercent = float(Rx_DestroyableObstaclePlus(TargetedActor).GetHealth()) / max(1, float(Rx_DestroyableObstaclePlus(TargetedActor).GetMaxHealth()));
	}
	else if (Rx_BuildingAttachment(TargetedActor) != none && Rx_BuildingAttachment_PT(TargetedActor) == none)
	{
		TargetHealthPercent = Rx_BuildingAttachment(TargetedActor).getBuildingHealthPct();
		TargetHealthMaxPercent = Rx_BuildingAttachment(TargetedActor).getBuildingHealthMaxPct();		
		TargetArmorPercent = Rx_BuildingAttachment(TargetedActor).getBuildingArmorPct();
		bHasArmor = true;
	}
	else if (Rx_Building(TargetedActor) != none)
	{
		TargetArmorPercent = float(Rx_Building(TargetedActor).GetArmor()) / max(1,float(Rx_Building(TargetedActor).GetMaxArmor()));
		TargetHealthPercent = float(Rx_Building(TargetedActor).GetHealth()) / max(1,float(Rx_Building(TargetedActor).GetTrueMaxHealth()));		
		TargetHealthMaxPercent = 1.0f; //This may need to look at TrueMaxHealth somewhere.. we'll see after testing. 
		
		bHasArmor = true;
	}
	else
		TargetHealthPercent = -1;
		
	if(Rx_Building_Techbuilding(TargetedActor) != None || Rx_CapturableMCT(TargetedActor) != None
		|| (Rx_BuildingAttachment(TargetedActor) != none 
			&& Rx_BuildingAttachment(TargetedActor).OwnerBuilding != None && (Rx_Building_Techbuilding(Rx_BuildingAttachment(TargetedActor).OwnerBuilding.BuildingVisuals) != None || Rx_CapturableMCT(Rx_BuildingAttachment(TargetedActor).OwnerBuilding.BuildingVisuals) != None)) )
	{
		bHasArmor = false;
	}
}

