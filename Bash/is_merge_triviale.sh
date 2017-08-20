#!/bin/bash

# Ce script doit être appele avant d'effectuer un merge triviale
# Il vérifie que les deux branches à merger ont bien un ancêtre commum

# Il reçoit en paramètre les branches que l'on souhaite merger
# Par exemple si l'on souhaite merger la branche develop dans le branche release
# On se positionnera sur la branche release et on executera la commande git merge develop
# Pour verifier que le merge est trivaile on appelera ce script avec les arguments :
# release develop

# La branche à partir de laquelle le merge sera fait (branche initiale)
initial_branch=$1

# La branche distante avec laquelle on souhaite fusionner (branche distante)
remote_branche_to_merger=$2

echo -e "\n*********************************************** VERIFICATION DE LA POSSIBILITE DE MERGE TRIVAL **************************************\n"

# Affichage des branches à merger
echo -e "La possibilité de merge trivial sera évaluée de $remote_branche_to_merger dans $initial_branch\n"

# Calcule du commit de la branche initiale
initial_branch_sha=`git rev-parse $initial_branch`;
echo -e "SHA branche $initial_branch : $initial_branch_sha"

# Calcule du commit de la branche distante
remote_branche_to_merger_sha=`git rev-parse $remote_branche_to_merger`;
echo -e "SHA branche $remote_branche_to_merger : $remote_branche_to_merger_sha"

# calcule de la valeur de l'ancetre commum entre la branche initial 
# et la branche distante
best_common_ancestor_sha=`git merge-base $initial_branch $remote_branche_to_merger`;
echo -e "SHA ancêtre commum : $best_common_ancestor_sha\n"

# Pour que le merge soit triviale,
# L'ancestre commum doit être le HEAD de la branche initial

if test $best_common_ancestor_sha = $initial_branch_sha;
then
    # Le merge est bien triviale
    echo -e "Possibilité de merge trivial OK. "
    echo -e "Verification de l'ancetre commum validée." 
    echo -e "La possibilité de merge entre $initial_branch et $remote_branche_to_merger en mode fast forward (triviale) est OK"
    is_merge_trivial=0
 else
    # Le merge n'est pas triviale.
    echo -e "ECHEC. Impossibilité de merge trivial dans la configuration actuelle des branches." >&2
    echo -e "LES BRANCHES $initial_branch et $remote_branche_to_merger NE SONT PAS DANS LE BON ETAT." >&2
    echo -e "La branche $initial_branch doit avoir été mergé dans la branche $remote_branche_to_merger auparavant" >&2
    is_merge_trivial=1
fi

echo -e "\n*********************************************** FIN VERIFICATION DE LA POSSIBILITE DE MERGE TRIVAL **************************************\n"
exit $is_merge_trivial