/*
 *
 * --- Random Weapon Crate ---
 *
 *
 * Thanks to uKill for all of his help on this - he's amazing!
 *	-- Sarah & AlienX
 */
class AGN_CrateType_RandomWeapon extends AGN_CrateType
    transient
    config(AGN_Crates);

var config float ProbabilityIncreaseWhenInfantryProductionDestroyed;
var class<Rx_Weapon> WeaponClass;
var array< class<Rx_Weapon> > WeaponList;

function string GetGameLogMessage(Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
    return ((((((("GAME" $ Chr(2)) $ "Crate;") $ Chr(2)) $ "`weapon`") $ Chr(2)) $ "by") $ Chr(2)) $ class'Rx_Game'.static.GetPRILogName(RecipientPRI);
}

function string GetPickupMessage()
{
    return ("You were given a " $ WeaponClass.default.PickupMessage) $ "!";
}

function float GetProbabilityWeight(Rx_Pawn Recipient, AGN_CratePickup CratePickup)
{
    local Rx_Building building;
    local float Probability;
    Probability = Super.GetProbabilityWeight(Recipient,CratePickup);

    if (isSBH(Recipient)) // Don't give if it's an SBH.
          return 0;

		ForEach CratePickup.AllActors(class'Rx_Building',building)
		{
		  if((Recipient.GetTeamNum() == TEAM_GDI && Rx_Building_GDI_InfantryFactory(building) != none  && Rx_Building_GDI_InfantryFactory(building).IsDestroyed()) ||
			(Recipient.GetTeamNum() == TEAM_NOD && Rx_Building_Nod_InfantryFactory(building) != none  && Rx_Building_Nod_InfantryFactory(building).IsDestroyed()))
		  {
			Probability += ProbabilityIncreaseWhenInfantryProductionDestroyed;
		  }
		}

        return Probability;
    }

  function bool isSBH(Rx_Pawn Recipient)
    {
        if(Recipient.GetRxFamilyInfo() == class'Rx_FamilyInfo_Nod_StealthBlackHand')
            return true;

        return false;
    }

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, AGN_CratePickup CratePickup)
{
    local Rx_InventoryManager InvManager;

    WeaponClass = WeaponList[Rand(WeaponList.Length)];
    InvManager = Rx_InventoryManager(Recipient.InvManager);
    // End:0xA2
    if(InvManager.PrimaryWeapons.Find(WeaponClass) < 0)
    {
        WeaponClass = WeaponList[Rand(WeaponList.Length)];
    }
    InvManager.PrimaryWeapons.AddItem(WeaponClass);
    // End:0x150
    if(InvManager.FindInventoryType(WeaponClass) != none)
    {
        InvManager.SetCurrentWeapon(Rx_Weapon(InvManager.FindInventoryType(WeaponClass)));
    }
    // End:0x1A1
    else
    {
        InvManager.SetCurrentWeapon(Rx_Weapon(InvManager.CreateInventory(WeaponClass, false)));
    }
    //return;
}

defaultproperties
{
    WeaponList(0)=class'Rx_Weapon_VoltAutoRifle_GDI'
    WeaponList(1)=class'Rx_Weapon_TiberiumFlechetteRifle'
    WeaponList(2)=class'Rx_Weapon_TacticalRifle'
    WeaponList(3)=class'Rx_Weapon_GrenadeLauncher'
    WeaponList(4)=class'Rx_Weapon_Shotgun'
    WeaponList(5)=class'Rx_Weapon_Railgun'
    WeaponList(6)=class'Rx_Weapon_PersonalIonCannon'
    WeaponList(7)=class'Rx_Weapon_RepairGun'
    WeaponList(8)=class'Rx_Weapon_RocketLauncher'
    WeaponList(9)=class'Rx_Weapon_FlameThrower'
    WeaponList(10)=class'Rx_Weapon_FlakCannon'
    WeaponList(11)=class'Rx_Weapon_Chaingun_Nod'
    WeaponList(12)=class'Rx_Weapon_ChemicalThrower'
    WeaponList(13)=class'Rx_Weapon_AutoRifle_Nod'
    WeaponList(14)=class'Rx_Weapon_RepairGunAdvanced'
    WeaponList(15)=class'Rx_Weapon_HeavyPistol'
    WeaponList(16)=class'Rx_Weapon_Carbine'
    WeaponList(17)=class'Rx_Weapon_LaserChainGun'
    WeaponList(18)=class'Rx_Weapon_LaserRifle'
    BroadcastMessageIndex=1002
    PickupSound=SoundCue'Rx_Pickups.Sounds.SC_Pickup_Ammo'
}
