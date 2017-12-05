class AGN_GRI extends Rx_GRI;

simulated event PreBeginPlay(){
	LogInternal("[AGN] FunctionCall: PreBeginPlay");
}

simulated function PostBeginPlay(){
	Super.PostBeginPlay();
}

defaultproperties
{
	GameClass   = class'AGN_Game'
}