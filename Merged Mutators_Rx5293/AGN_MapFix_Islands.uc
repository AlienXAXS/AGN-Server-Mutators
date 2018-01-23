class AGN_MapFix_Islands extends RX_Mutator;

// This class spawns in the HMRLS fix for CNC-Islands
function InitSystem()
{
	//AGN_StaticMesh_IslandsRock
	Spawn(class'AGN_Mut_AlienXSystem.AGN_StaticMesh_IslandsBlocker',,, vect(15439.682617,8099.820313,-511.060059), rot(0,-4960,0));
	Spawn(class'AGN_Mut_AlienXSystem.AGN_StaticMesh_IslandsBlocker',,, vect(15565.526367,8407.881836,-511.060730), rot(0,-3136,0));
	Spawn(class'AGN_Mut_AlienXSystem.AGN_StaticMesh_IslandsBlocker',,, vect(15685.598633,8707.724609,-511.061401), rot(0,-4672,0));
	Spawn(class'AGN_Mut_AlienXSystem.AGN_StaticMesh_IslandsBlocker',,, vect(15822.235352,9006.488281,-511.061829), rot(0,-4096,0));
	Spawn(class'AGN_Mut_AlienXSystem.AGN_StaticMesh_IslandsBlocker',,, vect(15927.442383,9319.110352,-511.061829), rot(0,-2688,0));
	Spawn(class'AGN_Mut_AlienXSystem.AGN_StaticMesh_IslandsBlocker',,, vect(15995.394531,9638.127930,-511.064575), rot(0,-1568,0));
	Spawn(class'AGN_Mut_AlienXSystem.AGN_StaticMesh_IslandsBlocker',,, vect(16043.063477,9963.666016,-511.064331), rot(0,-1568,0));
	Spawn(class'AGN_Mut_AlienXSystem.AGN_StaticMesh_IslandsBlocker',,, vect(16077.267578,10291.986328,-511.064331), rot(0,-704,0));
	Spawn(class'AGN_Mut_AlienXSystem.AGN_StaticMesh_IslandsBlocker',,, vect(16100.307617,10619.399414,-511.064331), rot(0,-704,0));
	Spawn(class'AGN_Mut_AlienXSystem.AGN_StaticMesh_IslandsBlocker',,, vect(16122.279297,10945.486328,-511.064636), rot(0,-704,0));
}