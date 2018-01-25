/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_RepairPad_Emitter extends Rx_ParticleField;

var float InitialDamage; //initial damage done to proximity mines
var byte VRank; 
var repnotify bool bDestroyEmitter;

replication
{
	if (bNetDirty && Role<=Role_Authority)
		bDestroyEmitter;
}

simulated event ReplicatedEvent(name VarName)
{
	if ( VarName == 'bDestroyEmitter' )
	{	
		ParticlesTemplate = None;
		Destroy();
	}
	else
		Super.ReplicatedEvent(VarName);
}

DefaultProperties
{
	ParticlesTemplate=ParticleSystem'AGN_FX_Package.Particles.Explosions.P_RepairField'
	InitialDamage=0
	StopParticlesTime=0.25
	LifeSpan=1.1
}

