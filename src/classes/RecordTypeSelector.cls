/**************************************************************************************
 Apex Class Name    : RecordTypeSelector
 Version            : 1.0
 Created Date       : Oct 10 2017
 Function           : Recordtype selector
 Modification Log   : Draft created by Manos
 -----------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Manos S                  27/10/2017              First Version
 *************************************************************************************/
public class RecordTypeSelector {


    // Build a local cache so that we don't request this multiple times
    private static Map<Schema.SObjectType, Map<String, RecordType>> rtypesCache;

    static {
        rtypesCache = new Map<Schema.SObjectType, Map<String, RecordType>>();
    }


    /********************************************************************************************************************************
    *
    * ver 1.0 2017.10.27 Manos Spanoudakis <manos.spanoudakis@ef.com>
    *
    *                    Get a map <DeveloperName, Recordtype> of ACTIVE RecordTypes for the specified SObject
    *
    * @param objectType The object type for which we require the record types
    *
    */
    public static Map<String, RecordType> getRecTypesByDevName(Schema.SObjectType objectType) {

        // Do we already have a result?
        Map<String, RecordType> mapRecordTypes = rtypesCache.get(objectType);
        // If not, build a map of RecordTypeIds keyed by DeveloperName
        if (mapRecordTypes == null) {
            mapRecordTypes = new Map<String, RecordType>();
            rtypesCache.put(objectType, mapRecordTypes);
        } else {
            // If we do, return our cached result immediately!
            return mapRecordTypes;
        }

        // Get the Describe Result
        Schema.DescribeSObjectResult obj = objectType.getDescribe();

        // Obtain ALL Active Record Types for the given SObjectType objectType
        // (We will filter out the Record Types that are unavailable
        // to the Running User using Schema information)
        String soql =
                'SELECT Id, Name, DeveloperName '
                        + 'FROM RecordType '
                        + 'WHERE SObjectType = \'' + String.escapeSingleQuotes(obj.getName()) + '\' '
                        + 'AND IsActive = TRUE';
        List<SObject> results;
        try {
            results = Database.query(soql);
        } catch (Exception ex) {
            results = new List<SObject>();
        }

        for (SObject rt : results) {
            mapRecordTypes.put(String.valueOf(rt.get('DeveloperName')), (RecordType) rt);
        }

        return mapRecordTypes;
    }

/*********************************************************************************************************************************/
}