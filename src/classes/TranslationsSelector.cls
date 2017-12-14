/**************************************************************************************
Apex Class Name    : TranslationsSelector
Version            : 1.0
Created Date       : Sep 14 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arjun.Mohan                 09/14/2017              Original Version
*******************************************************************************/

public  class TranslationsSelector {

   Public static Map<string,Translation__C> getTranslationRecDetails(Boolean isStaticText,List<String> marketStrings,Id recordTypeId,List<String> productList){
        Map<String,Translation__C> translationRecordMap=new Map<String,Translation__C>();

      String query=returnQueryString(isStaticText,marketStrings,recordTypeId,productList);
       List<Translation__C> translationList= Database.query(query);
        if (translationList.size()==0 || isStaticText) {
           String[] defaultArrayString=SFLangUtil.splitString(Label.DefaultTranslation,'-');
           if (defaultArrayString.size()>0 && defaultArrayString.size()>1) {
               marketStrings.clear();
               marketStrings.add(defaultArrayString[0]);
           }
           query=returnQueryString(isStaticText,marketStrings,recordTypeId,productList);
            List<Translation__C> defaultList=Database.query(query);
           translationList.addAll(defaultList);
       }

      /*  List<Translation__C> translationList=(isStaticText)?
                [select Id, DescriptionTranslation__c,GeneralInfoTranslation__c,Market__C,Total_Heading__c,Insurance_Heading__c,Optional_Heading__c,
                LessonsDescriptionsTranslation__c,Product__c,ProductNameTranslation__c,Unique_Record_Identifier__c,General_heading__c
        from Translation__c where Market__C IN:marketStrings and recordtypeid=:recordTypeId]:
                [select Id, DescriptionTranslation__c,GeneralInfoTranslation__c,Market__C,
                LessonsDescriptionsTranslation__c,Product__c,ProductNameTranslation__c,Unique_Record_Identifier__c,General_heading__c
        from Translation__c where Market__C IN:marketStrings and Product__c IN:productList];*/
       System.debug('translationList count is'+translationList.size());

            for (Translation__C translationRecord:translationList) {
                 System.debug('Selector Unique '+translationRecord.Unique_Record_Identifier__c);
                translationRecordMap.put(translationRecord.Unique_Record_Identifier__c,translationRecord);
            }
       System.debug('translationRecordMap count is'+translationRecordMap.size());
             return translationRecordMap;
    }

    public static String returnQueryString(Boolean isStaticText,List<String> marketStrings,Id recordTypeId,List<String> productList)
    {
        String query = 'SELECT ';
        if (isStaticText) {
            for(Schema.FieldSetMember f : SObjectType.Translation__c.FieldSets.StaticTextTranslationFieldSet.getFields()) {
                query += f.getFieldPath() + ', ';
            }

        }
        else
        {
            for(Schema.FieldSetMember f : SObjectType.Translation__c.FieldSets.ProductTranslationfieldSet.getFields()) {
                query += f.getFieldPath() + ', ';
            }
        }
        String whereclause=(isStaticText)?' where Market__C IN:  marketStrings AND recordtypeid =: recordTypeId':' where Market__C IN: marketStrings AND Product__c IN : productList';


        query+='ID,Unique_Record_Identifier__c FROM Translation__C' ;
        query += whereclause ;
        System.debug('#######################################   '+query);
        return query;
    }
}