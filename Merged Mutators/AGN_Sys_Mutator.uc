class AGN_Sys_Mutator extends Rx_Mutator;

var repnotify float ServerFPS;

function OnTick(float DeltaTime)
{
	ServerFPS = 1 / DeltaTime;
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
}

function PrintServerFPS()
{
	`log("[AGN-System-Mutator] Server FPS: " $ ServerFPS);
}