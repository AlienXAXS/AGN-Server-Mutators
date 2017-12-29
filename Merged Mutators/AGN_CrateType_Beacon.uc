/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


/*
 *
 * --- Beacon Crate ---
 *
 *
 * Thanks to uKill for all of his help on this - he's amazing!
 *	-- Sarah & AlienX
 */
class AGN_CrateType_Beacon extends AGN_CrateType
    transient
    config(AGN_Crates);

var class<Rx_Weapon> WeaponClass;
var array< class<Rx_Weapon> > BeaconType;

function string GetGameLogMessage(Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
    return ((((((("GAME" $ Chr(2)) $ "Crate;") $ Chr(2)) $ "`beacon`") $ Chr(2)) $ "by") $ Chr(2)) $ class'Rx_Game'.static.GetPRILogName(RecipientPRI);
}

function string GetPickupMessage()
{
    if(WeaponClass == class'Rx_Weapon_NukeBeacon')
    {
        return Repl("You got a `beacon`!", "`beacon`", "Nuclear Strike Beacon", false);
    }
    else
    {
        return Repl("You got an `beacon`!", "`beacon`", "Ion Cannon Beacon", false);
    }
}

function float GetProbabilityWeight(Rx_Pawn Recipient, AGN_CratePickup CratePickup)
{
    local Rx_Building Building;
    local float probability;

    probability = super.GetProbabilityWeight(Recipient, CratePickup);
    foreach CratePickup.AllActors(class'Rx_Building', Building)
    {
        if((((Recipient.GetTeamNum() == 0) && Rx_Building_GDI_InfantryFactory(Building) != none) && Rx_Building_GDI_InfantryFactory(Building).IsDestroyed()) || ((Recipient.GetTeamNum() == 1) && Rx_Building_Nod_InfantryFactory(Building) != none) && Rx_Building_Nod_InfantryFactory(Building).IsDestroyed())
        {
        }
    }
    return Probability;
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
    local Rx_InventoryManager InvManager;

    WeaponClass = BeaconType[Rand(BeaconType.Length)];
    InvManager = Rx_InventoryManager(Recipient.InvManager);
    if(InvManager.PrimaryWeapons.Find(WeaponClass) < 0)
    {
        WeaponClass = BeaconType[Rand(BeaconType.Length)];
    }
    InvManager.PrimaryWeapons.AddItem(WeaponClass);
    if(InvManager.FindInventoryType(WeaponClass) != none)
    {
        InvManager.SetCurrentWeapon(Rx_Weapon(InvManager.FindInventoryType(WeaponClass)));
    }
    else
    {
        InvManager.SetCurrentWeapon(Rx_Weapon(InvManager.CreateInventory(WeaponClass, false)));
    }
}

defaultproperties
{
    BroadcastMessageIndex=1004
    BeaconType.Add(class'Rx_Weapon_NukeBeacon')
    BeaconType.Add(class'Rx_Weapon_IonCannonBeacon')
    PickupSound=SoundCue'Rx_Pickups.Sounds.SC_Pickup_Ammo'
}

