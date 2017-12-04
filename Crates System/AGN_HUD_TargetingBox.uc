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