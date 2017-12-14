/**************************************************************************************
Apex Class Name    : publicGroupsSelector
Version            : 1.0
Created Date       : June 09 2017
Function           : return the details of public groups here.
Modification Log   :
-----------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Suresh S                  06/09/2017              Original Version
 *************************************************************************************/
public class PublicGroupsSelector {
    
    //For getting details of public groups.
    public static Map<String,ID> getPublicGroups(List<String> groupNameList){

       // List<>
        List<Group> publicGroupList= new List<Group>();
        publicGroupList=[select id,name from group where type='Regular' and name in :groupNameList];
        Map<String,ID> publicGroupMap= new Map<String,ID>();
        
        for(Group grp:publicGroupList){
            publicGroupMap.put(grp.name,grp.ID);
        }
        return publicGroupMap;
    }
}