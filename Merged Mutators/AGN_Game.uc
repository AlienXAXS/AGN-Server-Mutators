class AGN_Game extends Rx_Game;
var array<AGN_CratePickup> AllCratesArray;

/*
 * Adds crate to global array and sets one random active
 * */
function AddCrateAndActivateRnd_AGN(AGN_CratePickup InCrate)
{
   local AGN_CratePickup tmpCrate;
   local int activeCratesNum;
   activeCratesNum = 0;
   if (!SpawnCrates)
   {
      InCrate.GotoState('Disabled');
   }
   else
   {
      AllCratesArray.AddItem(InCrate);

      foreach AllCratesArray(tmpCrate)
      {
         if (tmpCrate.getIsActive())
            activeCratesNum++;
      }

      if (activeCratesNum > Rx_MapInfo(WorldInfo.GetMapInfo()).NumCratesToBeActive)
         InCrate.DeactivateCrate();
      else
         InCrate.ActivateCrate();
   }
}

/*
 * called after crate was picked up and next one should be activated
 * used with config to delay crate respawn set by user
 * */
 
//This is never called any more, now respawning crates inside AGN_CratePickup
function ActivateRandomCrate_AGN()
{
   local AGN_CratePickup tmpCrate;
   local array<AGN_CratePickup> CratesNotActive;

   // get non active crates
   foreach AllCratesArray(tmpCrate)
   {
      if(!tmpCrate.getIsActive())
      {
         CratesNotActive.AddItem(tmpCrate);
      }
   }
   // activate a rnd one
   
   CrateRespawnAfterPickup = 60.0f - Worldinfo.GRI.ElapsedTime % 60.0f;
   if(CrateRespawnAfterPickup == 0.0)
   		CrateRespawnAfterPickup = 1.0;
   
   SendMessageToAllPlayers ( "Activing a crate, it will appear in " $ CrateRespawnAfterPickup $ " seconds");
   CratesNotActive[Rand(CratesNotActive.Length)].setActiveIn(CrateRespawnAfterPickup);
}

function SendMessageToAllPlayers(string message)
{
	local Controller c;
	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
	{
		Rx_Controller(c).CTextMessage("[AGN] " $ message,'LightGreen',50);
	}
}

DefaultProperties
{
	PlayerControllerClass = class'AGN_Veh_Controller';
}