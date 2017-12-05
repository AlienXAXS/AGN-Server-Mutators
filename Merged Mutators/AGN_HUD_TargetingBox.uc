class AGN_HUD_TargetingBox extends Rx_HUD_TargetingBox;

function bool IsValidTarget (actor potentialTarget)
{
	if (Rx_Building(potentialTarget) != none ||
		(Rx_BuildingAttachment(potentialTarget) != none && Rx_BuildingAttachment_Door(potentialTarget) == none) ||
		Rx_Building_Internals(potentialTarget) != none ||
		(Rx_Vehicle(potentialTarget) != none && Rx_Vehicle(potentialTarget).Health > 0) ||
		(Rx_Weapon_DeployedActor(potentialTarget) != none && Rx_Weapon_DeployedActor(potentialTarget).GetHealth() > 0) ||
		(Rx_Pawn(potentialTarget) != none && Rx_Pawn(potentialTarget).Health > 0)||
		(Rx_DestroyableObstaclePlus(potentialTarget) !=none && Rx_DestroyableObstaclePlus(potentialTarget).bShowHealth && Rx_DestroyableObstaclePlus(potentialTarget).GetHealth() > 0) ||
		(AGN_CratePickup(potentialTarget) != none && !AGN_CratePickup(potentialTarget).bPickupHidden)
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