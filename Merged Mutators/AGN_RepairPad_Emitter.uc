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