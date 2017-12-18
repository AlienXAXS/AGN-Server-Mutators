class AGN_Sys_Mutator extends Rx_Mutator;

var float ourServerFPS;
var AGN_Mut_Controller AGNController;
var int calcServerFPS;

function OnTick(float DeltaTime)
{
	// Keep server FPS here as well for Log file logging.
	ourServerFPS = 1 / DeltaTime;
	calcServerFPS++;
	
	if ( AGNController != None ) 
		AGNController.OnTick(DeltaTime);
}

function InitSystem()
{
	ourServerFPS = 0;
	
	if(`WorldInfoObject.NetMode == NM_DedicatedServer)
	{
		`log("[AGN-System-Mutator] Server Found - Starting FPS Timer");
		setTimer(10, true, 'PrintourServerFPS');
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

function PrintourServerFPS()
{
	`log("[AGN-System-Mutator] Server FPS: " $ ourServerFPS $ " Calc Server FPS: " $ string((calcServerFPS/10)));	
	calcServerFPS = 0;
}