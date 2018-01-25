class AGN_Rebuildable_Defence_Controller extends Rx_Defence_Controller;

var repnotify bool bDefenseIsActive;

replication
{
	if (bNetDirty && Role<=Role_Authority)
		bDefenseIsActive;
}

function SetDefenceActive(bool isActive)
{
	bDefenseIsActive = isActive;
	`log("[AGN-Defence-System] Setting tower/turret active state for its AI to " $ bDefenseIsActive);
}

function bool IsTargetRelevant( Pawn thisTarget )
{
	if ( bDefenseIsActive )
		return Super.IsTargetRelevant(thisTarget);
	else
		return false;
}

DefaultProperties
{
	bDefenseIsActive = true;
}