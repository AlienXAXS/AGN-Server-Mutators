class AGN_HUD_AdminComponent extends Rx_Hud_Component;

var AGN_Mut_Controller AGN_MutController;

function Update(float DeltaTime, Rx_HUD HUD) 
{
	local AGN_Mut_Controller thisClass;
	local Object meh;
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
	
	X = RenxHud.Canvas.SizeX*0.005;
	Y = RenxHud.Canvas.SizeY*0.60;
	Canvas.SetPos(X,Y);
	Canvas.SetDrawColor(0,255,0,255);
	Canvas.Font = Font'RenXHud.Font.RadioCommand_Medium';
	
	if ( AGN_MutController == None )
	{
		Canvas.DrawText("AGN-Admin-HUD Loading...");
	} else {
		Canvas.DrawText("[AGN-Admin-Stats]\n  Server FPS: " $ string(AGN_MutController.ServerFPS) $ "\n  Actor Count: " $ string(AGN_MutController.CurrentActors));
	}
}