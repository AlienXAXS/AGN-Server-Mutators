class AGN_RepairPad_Emitter extends Rx_ParticleField;

var float InitialDamage; //initial damage done to proximity mines
var byte VRank; 

DefaultProperties
{
	ParticlesTemplate=ParticleSystem'AGN_FX_Package.Particles.Explosions.P_RepairField'

	InitialDamage=0
	
	StopParticlesTime=0.25
	LifeSpan=999999
}