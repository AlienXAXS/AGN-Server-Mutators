class AGN_RepairPad_Emitter extends Rx_ParticleField;

var float InitialDamage; //initial damage done to proximity mines
var byte VRank; 

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	if (WorldInfo.NetMode == NM_Client)
		return;

	if (RxIfc_EMPable(Other) != None)
	{
		RxIfc_EMPable(Other).EnteredEMPField(self);
	}	
}

event UnTouch( Actor Other )
{
	if (WorldInfo.NetMode == NM_Client)
		return;

	if (RxIfc_EMPable(Other) != None)
		RxIfc_EMPable(Other).LeftEMPField(self);
}

event Destroyed()
{
	local Actor A;
	foreach TouchingActors(class'Actor', A)
	{
		if (RxIfc_EMPable(A) != None)
			RxIfc_EMPable(A).LeftEMPField(self);
	}
	super.Destroyed();
}

DefaultProperties
{
	ParticlesTemplate=ParticleSystem'AGN_FX_Package.Particles.Explosions.P_RepairField'

	InitialDamage=0
	
	StopParticlesTime=0.25
	LifeSpan=+12.0
}
