echo '##### CREATING SCRATCH ORG #####'
SCRATCH_ALIAS=$1
PROJECT_NAME=${PWD##*/}
SCRATCH_ALIAS="${SCRATCH_ALIAS:-$PROJECT_NAME-`git branch | grep \* | cut -d ' ' -f2`}" 
sfdx force:org:create --definitionfile config/project-scratch-def.json --setalias $SCRATCH_ALIAS --setdefaultusername
echo '##### PUSHING METADATA #####'
sfdx force:source:push --targetusername $SCRATCH_ALIAS
echo '##### ASSIGNING PERMISSIONS #####'
sfdx force:user:permset:assign --permsetname MyPermissionSet --targetusername $SCRATCH_ALIAS
echo '##### IMPORTING DUMMY DATA #####'
sfdx texei:data:import --inputdir ./data --targetusername $SCRATCH_ALIAS
echo '##### CLEANING STANDARD LAYOUTS #####'
sfdx texei:source:layouts:cleanorg --targetusername $SCRATCH_ALIAS
echo '##### OPENING SCRATCH ORG #####'
sfdx force:org:open --urlonly --targetusername $SCRATCH_ALIAS