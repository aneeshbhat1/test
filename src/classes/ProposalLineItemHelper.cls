/**************************************************************************************
Apex Class Name    : ProposalLineItemHelper
Version            : 1.0
Created Date       : September 14 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arjun.Mohan                 09/14/2017              Original Version
*******************************************************************************/

public class ProposalLineItemHelper {
    //In this Method is used to update fields related to Translation record for Translation

    public static void updateProposalLineItemFieldsBeforeCreation(List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemNewList) {
        Id currentRecordId;
        try {
            List<string> localeStrings = new List<string>();
            List<String> productsList = new List<String>();
            for (Apttus_Proposal__Proposal_Line_Item__c proposalLineItemRecord : proposalLineItemNewList) {
                currentRecordId=proposalLineItemRecord.Id;
                localeStrings.add(proposalLineItemRecord.APTS_Market__c);
                if (proposalLineItemRecord.Apttus_QPConfig__LineType__c == APTS_Constants.PROPOSALLINEITEM_TYPE_PRODUCTSERVICE) {
                    productsList.add(proposalLineItemRecord.Apttus_Proposal__Product__c);
                } else if (proposalLineItemRecord.Apttus_QPConfig__LineType__c == APTS_Constants.PROPOSALLINEITEM_TYPE_OPTION) {
                    productsList.add(proposalLineItemRecord.Apttus_QPConfig__OptionId__c);
                }

            }

            if (localeStrings.size() > 0 && productsList.size() > 0) {
                String uniqueRecord = '';
                Map<string, Translation__C> translationsMap = TranslationsSelector.getTranslationRecDetails(false, localeStrings, null, productsList);

                for (Apttus_Proposal__Proposal_Line_Item__c proposalLineItemRecord : proposalLineItemNewList) {
                    currentRecordId=proposalLineItemRecord.Id;
                    //Added If and else if coz we have "Misc as Picklist value for LineType" in Proposal Line item
                        uniqueRecord = proposalLineItemRecord.APTS_Market__c + ' ' +  proposalLineItemRecord.APTS_Language__c+' '+proposalLineItemRecord.APTS_Product_Code__c;

                    if (!translationsMap.containsKey(uniqueRecord)) {
                        String[] defaultArrayString=SFLangUtil.splitString(Label.DefaultTranslation,'-');
                        if (defaultArrayString.size()>0 && defaultArrayString.size()>1) {
                            uniqueRecord=defaultArrayString[0]+' '+defaultArrayString[1]+ ' '+proposalLineItemRecord.APTS_Product_Code__c;
                        }
                    }
                    
                    system.debug('==uniqueRecord=='+uniqueRecord);
                    system.debug('==translationsMap=='+translationsMap);
                    if (translationsMap.containsKey(uniqueRecord)) {
                        system.debug('==uniqueRecord11=='+translationsMap.containsKey(uniqueRecord));
                        for (Schema.FieldSetMember f : SObjectType.Translation__c.FieldSets.ProductTranslationfieldSet.getFields()) {
                            proposalLineItemRecord.put(f.getFieldPath(), translationsMap.get(uniqueRecord).get(f.getFieldPath()));
                        }
                    }
                }
            }
        } catch (Exception ex) {
            ExceptionHandler.errorLogAsync(ex.getMessage(), ex.getStackTraceString(),
                    'ProposalLineItemHelper', 'updateProposalLineItemFieldsBeforeCreation', currentRecordId);
        }

    }
}