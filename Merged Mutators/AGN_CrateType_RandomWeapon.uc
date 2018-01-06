/* 
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 * 
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 * 
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 * 
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
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
	local string wepName;
	
	if ( WeaponClass.IsA('AGN_Weapon_PersonalIonCannon') )
		wepName = "Personal Unicorn Cannon";
	else if ( WeaponClass.IsA('AGN_Weapon_TiberiumFlechetteRifle') )
		wepName = "Tiberium Flechette Rifle";
	else
		wepName = WeaponClass.default.PickupMessage;
		
    return "You were given a " $ wepName $ "!";
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
    if(InvManager.PrimaryWeapons.Find(WeaponClass) < 0)
    {
        WeaponClass = WeaponList[Rand(WeaponList.Length)];
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
    WeaponList(0)=class'Rx_Weapon_VoltAutoRifle_GDI'
    WeaponList(1)=class'AGN_Weapon_TiberiumFlechetteRifle'
    WeaponList(2)=class'Rx_Weapon_TacticalRifle'
    WeaponList(3)=class'Rx_Weapon_GrenadeLauncher'
    WeaponList(4)=class'Rx_Weapon_Shotgun'
    WeaponList(5)=class'Rx_Weapon_Railgun'
    WeaponList(6)=class'AGN_Weapon_PersonalIonCannon'
    WeaponList(7)=class'Rx_Weapon_RepairGun'
    WeaponList(8)=class'Rx_Weapon_RocketLauncher'
    WeaponList(9)=class'Rx_Weapon_FlameThrower'
    WeaponList(10)=class'Rx_Weapon_FlakCannon'
    WeaponList(11)=class'Rx_Weapon_Chaingun_Nod'
    WeaponList(12)=class'Rx_Weapon_ChemicalThrower'
    WeaponList(13)=class'Rx_Weapon_AutoRifle_Nod'
    WeaponList(14)=class'Rx_Weapon_RepairGunAdvanced'
    WeaponList(15)=class'Rx_Weapon_HeavyPistol'
    WeaponList(16)=class'AGN_Weapon_Carbine_Silencer'
    WeaponList(17)=class'Rx_Weapon_LaserChainGun'
    WeaponList(18)=class'Rx_Weapon_LaserRifle'
    BroadcastMessageIndex=1002
    PickupSound=SoundCue'Rx_Pickups.Sounds.SC_Pickup_Ammo'
}

