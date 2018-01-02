/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */

class AGN_HUD_CrateStatus extends Rx_Hud_Component;

function Update(float DeltaTime, Rx_HUD HUD) 
{
	super.Update(DeltaTime, HUD);
}

function Draw()
{
	local float X,Y;
	local string hudMessage;
	local AGN_CrateHUDStatus thisCrateHUDStatus;
	local AGN_Rx_Controller AGNController;
			
	if ( RenxHud.PlayerOwner == None || AGN_Rx_Controller(RenxHud.PlayerOwner) == None || RenxHud.PlayerOwner.PlayerReplicationInfo == None )
		return;
		
	AGNController = AGN_Rx_Controller(RenxHud.PlayerOwner);
	foreach AGNController.CrateStatuses(thisCrateHUDStatus)
	{
		hudMessage $= thisCrateHUDStatus.Message $ thisCrateHUDStatus.CountdownTimer > 0 ? " (" $ string(thisCrateHUDStatus.CountdownTimer) $ " seconds)\n" : "\n";
	}
	
	if ( hudMessage != "" )
	{
		X = RenxHud.Canvas.SizeX*0.005;
		Y = RenxHud.Canvas.SizeY*0.40;
		Canvas.SetPos(X,Y);
		Canvas.SetDrawColor(0,255,0,255);
		Canvas.Font = Font'RenXHud.Font.RadioCommand_Medium';
		Canvas.DrawText(hudMessage);
	}
}

