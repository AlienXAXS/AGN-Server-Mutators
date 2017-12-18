class AGN_Sys_Mutator extends Rx_Mutator;

var float ServerFPS;
var AGN_Mut_Controller AGNController;


function OnTick(float DeltaTime)
{
	// Keep server FPS here as well for Log file logging.
	ServerFPS = 1 / DeltaTime;
	
	if ( AGNController != None ) 
		AGNController.OnTick(DeltaTime);
}

function InitSystem()
{
	ServerFPS = 0;
	
	if(`WorldInfoObject.NetMode == NM_DedicatedServer)
	{
		`log("[AGN-System-Mutator] Server Found - Starting FPS Timer");
		setTimer(10, true, 'PrintServerFPS');
	} else {
		`log("[AGN-System-Mutator] Client Found, not logging FPS");
	}
	
	if ( Rx_Game(WorldInfo.Game) != None )
	{
		AGNController = Rx_Game(WorldInfo.Game).Spawn(class'AGN_Mut_Controller');
		AGNController.AGN_MutReplicationInfo = Rx_Game(WorldInfo.Game).Spawn(class'AGN_Mut_ReplicationInfo');
		
		`log("[AGN-SYSTEM] Spawned Controller and Replication Info classes");
	}
}

function PrintServerFPS()
{
	`log("[AGN-System-Mutator] Server FPS: " $ ServerFPS);
}