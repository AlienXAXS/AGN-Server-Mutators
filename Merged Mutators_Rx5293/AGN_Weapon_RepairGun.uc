/*
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 *
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 *
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 *
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */


 AGN_Weapon_RepairGun extends Rx_Weapon_RepairGun;

class AGN_Weapon_RepairGun extends RX_Weapon_RepairGun;

simulated function RepairDeployedActor(Rx_Weapon_DeployedActor deployedActor, float DeltaTime)
{

    if (!deployedActor.bCanNotBeDisarmedAnymore
            && (IsEnemy(deployedActor) || (Rx_Weapon_DeployedProxyC4(deployedActor) != None
                                                && CurrentFireMode == 0
                                                && (Rx_Weapon_DeployedProxyC4(deployedActor).OwnerPRI == Instigator.PlayerReplicationInfo || Rx_PRI(Rx_Weapon_DeployedProxyC4(deployedActor).OwnerPRI).GetMineStatus() == false ||  Instigator.PlayerReplicationInfo.bAdmin ) // Checks who can disarm this mine. Owner, minebanned, mod/admin
                                                && deployedActor.HP > 0
                                                && deployedActor.HP <= deployedActor.MaxHP)))
    {
        Repair(deployedActor,DeltaTime,true);
    }
    else if (deployedActor.HP > 0 &&
            deployedActor.HP <= deployedActor.MaxHP)
    {
        Repair(deployedActor,DeltaTime,false);
    }
    else
    {
        bHealing = false;
    }
}

DefaultProperties
{}
  
