/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_HUD_AdminComponent extends Rx_Hud_Component;

var AGN_Mut_Controller AGN_MutController;

function Update(float DeltaTime, Rx_HUD HUD) 
{
	local AGN_Mut_Controller thisClass;
	super.Update(DeltaTime, HUD);
	
	if ( AGN_MutController == None )
	{
		// Find our controller.
		foreach RenxHud.PlayerOwner.AllActors(class'AGN_Mut_Controller', thisClass)
		{
			AGN_MutController = thisClass;
			break;
		}
	}
	
	// If we're still none, then oops?
	if ( AGN_MutController == None )
		return;
}

function Draw()
{
	DrawServerFPS();
}

simulated function DrawServerFPS()
{
	local float X,Y;
	local string hudMessage;
	local string fpsMessage;
	
	if ( RenxHud.PlayerOwner == None || RenxHud.PlayerOwner.PlayerReplicationInfo == None || !RenxHud.PlayerOwner.PlayerReplicationInfo.bAdmin )
		return;
	
	X = RenxHud.Canvas.SizeX*0.005;
	Y = RenxHud.Canvas.SizeY*0.60;
	Canvas.SetPos(X,Y);
	Canvas.SetDrawColor(0,255,0,255);
	Canvas.Font = Font'RenXHud.Font.RadioCommand_Medium';
	
	if ( AGN_MutController == None )
	{
		Canvas.DrawText("AGN-Admin-HUD Loading...");
	} else {
		//ServerFPS,CurrentActors,CurrentVehiclesNod,CurrentVehiclesGDI,CurrentVehiclesUnoccupied,ServerDeltaTime
		
		hudMessage = "[AGN-Admin-Stats]\n";
		fpsMessage = AGN_MutController.ServerFPS == 0 ? "Running As Client Or No Data!" : string(AGN_MutController.ServerFPS);
		hudMessage $= "  SFPS: " $ fpsMessage $ " | DT: " $ AGN_MutController.ServerDeltaTime $ " | AA: " $ string(AGN_MutController.CurrentActors) $ "\n";
		hudMessage $= "  NodVeh: " $ string(AGN_MutController.CurrentVehiclesNod) $ " | GDIVeh: " $ string(AGN_MutController.CurrentVehiclesGDI) $ " | UnOcVeh: " $ string(AGN_MutController.CurrentVehiclesUnoccupied) $ " | Tot: " $ string((AGN_MutController.CurrentVehiclesNod+AGN_MutController.CurrentVehiclesGDI+AGN_MutController.CurrentVehiclesUnoccupied)) $ "\n";
		hudMessage $= "  NodCredits: " $ string(AGN_MutController.ServerNodCredits) $ " | GDICredits: " $ string(AGN_MutController.ServerGDICredits) $ "\n";
		Canvas.DrawText(hudMessage);
	}
}

