/**************************************************************************************
Apex Class Name    : DCSearchPlugin
Version            : 1.0
Created Date       : May 29 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Suresh S                  05/29/2017              Original Version
*******************************************************************************/
global class DCSearchPlugin implements dupcheck.dc3Plugin.InterfaceSearch
{
    global static void processResults(String methodName, Id sourceId, Map <string,Object> searchResults)
    {
                                        
        if (!(methodName=='ON_SEARCH;' || 
             methodName=='ON_INSERT;' || methodName=='ON_CONVERT;')) {
            system.debug('DCSearchPlugin:processResults--sourceId='+sourceId +'-searchResults='+searchResults);
            //DCBusinessHandler.ProcessDCSearchPlugin(methodName,sourceId,searchResults);
            DCBusinessFlow.dcSearchResults(methodName,sourceId,searchResults);
            system.debug('*****DCSearch Ends****');
        }
    }
}