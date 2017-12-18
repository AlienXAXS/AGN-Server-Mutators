class AGN_Mut_Controller extends ReplicationInfo;

// Our replication info class
var AGN_Mut_ReplicationInfo AGN_MutReplicationInfo;

var repnotify float ServerFPS;
var int CurrentActors;

replication
{
	if ( bNetDirty )
		ServerFPS;
}

simulated function PostBeginPlay()
{
	setTimer(1, true, 'CollectData');
}

function CollectData()
{
	local int counter;
	local Actor c;
	foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Actor', c)
	{
		counter ++;
	}
	
	CurrentActors = counter;
}

function OnTick(float DeltaTime)
{
	// Are we a dedicated server?
	//if(`WorldInfoObject.NetMode == NM_DedicatedServer)
	//{
		// Calc servers FPS on this tick
		ServerFPS = 1 / DeltaTime;
	//}
}
