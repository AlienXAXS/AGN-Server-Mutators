/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


class AGN_Pickup extends UTItemPickupFactory;

var int PickupsRemaining;
var float DespawnTime;
var bool bWillBeActive;
var repnotify bool isHiddenCrate;

replication
{
	if(bNetDirty || bNetInitial)
		isHiddenCrate;
}

simulated function string GetHumanReadableName()
{
	return "[AGN] Mystery Crate";
}

auto state Pickup
{
   function float DetourWeight(Pawn Other,float PathWeight)
   {
      return 1.0; // TODO: add some weight logic for bots
   }

   function bool ValidTouch( Pawn Other )
   {
      return Other.IsA('Rx_Pawn') && Other.Health > 0;
   }
}

function SetRespawn()
{
	if (PickupsRemaining < 0)
		Super.SetRespawn();
	else if (PickupsRemaining == 0) // This should never happen
		Destroy();
	else if (PickupsRemaining == 1) // No uses remaining
	{
		--PickupsRemaining;
		GotoState('Disabled');
		Destroy();
	}
	else if (PickupsRemaining > 1) // Additional uses remaining
	{
		--PickupsRemaining;
		StartSleeping();
	}
}

function Expire()
{
	GotoState('Disabled');
	Destroy();
}

DefaultProperties
{
	RespawnSound=SoundCue'A_Pickups.Health.Cue.A_Pickups_Health_Respawn_Cue'
	YawRotationRate=10000
	bRotatingPickup=true
	bFloatingPickup=true
	bRandomStart=true
	BobSpeed=4.0f
	BobOffset=5.0f
	RespawnTime=10
	DespawnTime=20
	PickupsRemaining = -1
	bNoDelete = false;
}

