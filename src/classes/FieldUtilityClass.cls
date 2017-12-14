/**************************************************************************************
Apex Class Name    : FieldUtilityClass
Version            : 1.0
Created Date       : July 27 2017
Function           : Utility class for Field metadata queries
Modification Log   :
-----------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Aneesh B                  07/27/2017              Original Version
 *************************************************************************************/

public with sharing class FieldUtilityClass {
    public class PicklistDetails {
        public string active { get; set; }
        public string defaultValue { get; set; }
        public string label { get; set; }
        public string value { get; set; }
        public string validFor { get; set; }
        public PicklistDetails() {
        }
    }
    public static Boolean hasFieldAccess(SObject obj, String fieldName) {
        Schema.SObjectType type = obj.getSObjectType();
        Schema.DescribeSObjectResult dsr = type.getDescribe();
        Map<String, Schema.SObjectField> mapObj = dsr.fields.getMap();
        for (String field:mapObj.keySet()) {
            Schema.SObjectField fieldMeta = mapObj.get(field);
            Schema.DescribeFieldResult dfr = fieldMeta.getDescribe();

            if (dfr.getName() == fieldName) {
                return dfr.isAccessible();
            }
        }
        return false;
    }

    public static Map<String, String> getPickListValues(Schema.SObjectType type, String fieldName) {
        if(type == null||fieldName == null|| fieldName == ''){
            return (new Map<String,String>());
        }

        Schema.DescribeSObjectResult dsr = type.getDescribe();
        Map<String, Schema.SObjectField> mapObj = dsr.fields.getMap();
        Map<String, String> picklistValues = new Map<String, String>();
        for (String field:mapObj.keySet()) {
            Schema.SObjectField fieldMeta = mapObj.get(field);
            Schema.DescribeFieldResult dfr = fieldMeta.getDescribe();
            if (dfr.getName() == fieldName) {
                List<Schema.PicklistEntry> items = dfr.getPicklistValues();
                for (Schema.PicklistEntry entry:items) {
                    picklistValues.put(entry.label, entry.value);
                }
                break;
            }
        }
        return picklistValues;
    }

    public  static Map<String,List<String>> GetDependentOptions(String pObjName, String pControllingFieldName, String pDependentFieldName){
            Map<String,List<String>> objResults = new Map<String,List<String>>();
            //get the string to sobject global map
            Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
            //get the type being dealt with
            Schema.SObjectType pType = objGlobalMap.get(pObjName);
            Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap();
            //get the control values
            List<Schema.PicklistEntry> ctrl_ple = objFieldMap.get(pControllingFieldName).getDescribe().getPicklistValues();
            //get the dependent values
            List<Schema.PicklistEntry> dep_ple = objFieldMap.get(pDependentFieldName).getDescribe().getPicklistValues();
            //iterate through the values and get the ones valid for the controlling field name
            PicklistUtil.Bitset objBitSet = new PicklistUtil.Bitset();
            //set up the results
            for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){
                //get the pointer to the entry
                Schema.PicklistEntry ctrl_entry = ctrl_ple[pControllingIndex];
                //get the label
                String pControllingLabel = ctrl_entry.getLabel();
                //create the entry with the label
                objResults.put(pControllingLabel,new List<String>());
            }
            //check the dependent values
            for(Integer pDependentIndex=0; pDependentIndex<dep_ple.size(); pDependentIndex++){
                //get the pointer to the dependent index
                Schema.PicklistEntry dep_entry = dep_ple[pDependentIndex];
                //get the valid for
                String pEntryStructure = JSON.serialize(dep_entry);
                PicklistUtil.PicklistDetails objDepPLE = (PicklistUtil.PicklistDetails)JSON.deserialize(pEntryStructure, PicklistUtil.PicklistDetails.class);
                //iterate through the controlling values
                for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){
                    if (objBitSet.fitBit(objDepPLE.validFor,pControllingIndex)){
                        //get the label
                        String pControllingLabel = ctrl_ple[pControllingIndex].getLabel();
                        objResults.get(pControllingLabel).add(objDepPLE.label);
                    }
                }
            }
            return objResults;
        }
    public static Map<String, List<String>> getFieldDependencies(String objectName, String controllingField, String dependentField)
    {
        Map<String, List<String>> controllingInfo = new Map<String, List<String>>();

        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);

        Schema.DescribeSObjectResult describeResult = objType.getDescribe();
        Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap().get(controllingField).getDescribe();
        Schema.DescribeFieldResult dependentFieldInfo = describeResult.fields.getMap().get(dependentField).getDescribe();

        List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
        List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();

        for(Schema.PicklistEntry currControllingValue : controllingValues)
        {
            System.debug('ControllingField: Label:' + currControllingValue.getLabel());
            controllingInfo.put(currControllingValue.getLabel(), new List<String>());
        }

        for(Schema.PicklistEntry currDependentValue : dependentValues)
        {
            String jsonString = JSON.serialize(currDependentValue);

            PicklistDetails info = (PicklistDetails) JSON.deserialize(jsonString, PicklistDetails.class);

            String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();

            System.debug('DependentField: Label:' + currDependentValue.getLabel() + ' ValidForInHex:' + hexString + ' JsonString:' + jsonString);

            Integer baseCount = 0;

            for(Integer curr : hexString.getChars())
            {
                Integer val = 0;

                if(curr >= 65)
                {
                    val = curr - 65 + 10;
                }
                else
                {
                    val = curr - 48;
                }

                if((val & 8) == 8)
                {
                    System.debug('Dependent Field: ' + currDependentValue.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 0].getLabel());
                    controllingInfo.get(controllingValues[baseCount + 0].getLabel()).add(currDependentValue.getLabel());
                }
                if((val & 4) == 4)
                {
                    System.debug('Dependent Field: ' + currDependentValue.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 1].getLabel());
                    controllingInfo.get(controllingValues[baseCount + 1].getLabel()).add(currDependentValue.getLabel());
                }
                if((val & 2) == 2)
                {
                    System.debug('Dependent Field: ' + currDependentValue.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 2].getLabel());
                    controllingInfo.get(controllingValues[baseCount + 2].getLabel()).add(currDependentValue.getLabel());
                }
                if((val & 1) == 1)
                {
                    System.debug('Dependent Field: ' + currDependentValue.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 3].getLabel());
                    controllingInfo.get(controllingValues[baseCount + 3].getLabel()).add(currDependentValue.getLabel());
                }

                baseCount += 4;
            }
        }

        System.debug('ControllingInfo: ' + controllingInfo);

        return controllingInfo;
    }
    }