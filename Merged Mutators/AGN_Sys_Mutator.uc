/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


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
		
		`log("[AGN-SYSTEM] Spawned Controller and Replication Info classes");
	}
}

function PrintourServerFPS()
{
	`log("[AGN-System-Mutator] Server FPS: " $ ourServerFPS $ " Calc Server FPS: " $ string((calcServerFPS/10)));	
	calcServerFPS = 0;
}

