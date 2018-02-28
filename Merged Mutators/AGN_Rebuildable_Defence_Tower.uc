class AGN_Rebuildable_Defence_Tower extends Rx_Defence_GuardTower;

var AGN_Rebuildable_Defence_Handler Handler;
var int HandlerIdentifier;

function InitializeDefence(AGN_Rebuildable_Defence_Handler ourHandler, int OurHandlerIdentifier) {
	Handler = ourHandler;
	HandlerIdentifier = OurHandlerIdentifier;
}

function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	// Report back to our handler that we're dead
	if ( Handler != None )
		Handler.OnDefenceDestroyed(TeamID, HandlerIdentifier);
		
	return Super.Died(Killer, DamageType, HitLocation);
}