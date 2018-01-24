class AGN_Rebuildable_Defence_Controller extends Rx_Defence_Controller;

var bool bDefenseIsActive;

function SetDefenceActive(bool isActive)
{
	bDefenseIsActive = isActive;
}

function bool IsTargetRelevant( Pawn thisTarget )
{
	if ( bDefenseIsActive )
		return Super.IsTargetRelevant(thisTarget);
	else
		return false;
}