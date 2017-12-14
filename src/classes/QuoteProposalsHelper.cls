/**************************************************************************************
Apex Class Name    : QuoteProposalsHelper
Version            : 1.0
Created Date       : September 14 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arjun.Mohan                 09/14/2017              Original Version
*******************************************************************************/

public class QuoteProposalsHelper {

  //In this Method we will be used to update Proposal Market,program,product
    // from opportunity and also fields related to Translation record for Translation
    //we will also auto populate the price list based on market and program before inserting the proposal record
    public static void updateQuoteProposalFieldsBeforeInsert(List<Apttus_Proposal__Proposal__c> quoteProposalNewList) {
        List<string> marketStrings = new List<string>();
        List<string> uniqueStrings = new List<string>();
        List<Id> oppIdList = new List<Id>();
        Id currentRecordId;
        try {

            for (Apttus_Proposal__Proposal__c proposalRecord : quoteProposalNewList) {
                currentRecordId = proposalRecord.Id;
                marketStrings.add(proposalRecord.APTS_Market__c);
                System.debug('######################### marketStrings'+proposalRecord.APTS_Market__c);
                System.debug('######################### Apttus_Proposal__Account__c'+proposalRecord.Apttus_Proposal__Account__c);
                oppIdList.add(proposalRecord.Apttus_Proposal__Opportunity__c);
                uniqueStrings.add(proposalRecord.Market__c +proposalRecord.Program__c+proposalRecord.CurrencyIsoCode+'TRUE');
            }
            Id recordTypeId = GetRecordTypeId(System.Label.StaticTextTranslation);
            System.debug('######################### uniqueStrings'+uniqueStrings);
            System.debug('######################### recordTypeId'+recordTypeId);
            if (marketStrings.size() > 0 && (recordTypeId != NULL) && uniqueStrings.size()>0) {

                String uniqueRecord = '';
                Map<string, Translation__C> translationsMap = TranslationsSelector.getTranslationRecDetails(true, marketStrings, recordTypeId, null);
                Map<Id, Opportunity> opportunityMap = OpportunitiesSelector.getopportunityMap(oppIdList);
                Map<String,Apttus_Config2__PriceList__c> priceListMap = PriceListSelector.getPriceListForMarketProgramCurrency(uniqueStrings);
                for (Apttus_Proposal__Proposal__c proposalRecord : quoteProposalNewList) {

                    uniqueRecord = proposalRecord.APTS_Market__c + ' '+proposalRecord.APTS_Language__c;
                     System.debug('######################### uniqueRecord at first'+uniqueRecord);
                    if (opportunityMap.containsKey(proposalRecord.Apttus_Proposal__Opportunity__c)) {

                        proposalRecord.Market__c = opportunityMap.get(proposalRecord.Apttus_Proposal__Opportunity__c).Market__c;
                        proposalRecord.Program__c = opportunityMap.get(proposalRecord.Apttus_Proposal__Opportunity__c).Program__c;
                        proposalRecord.Product__c =opportunityMap.get(proposalRecord.Apttus_Proposal__Opportunity__c).Product__c;
                    }
                    if (!translationsMap.containsKey(uniqueRecord)) {
                        String[] defaultArrayString=SFLangUtil.splitString(Label.DefaultTranslation,'-');
                        if (defaultArrayString.size()>0 && defaultArrayString.size()>1) {
                            uniqueRecord=defaultArrayString[0]+' '+defaultArrayString[1];
                        }
                    }

                    System.debug('######################### uniqueRecord'+uniqueRecord);
                    if (translationsMap.containsKey(uniqueRecord)) {
                        for (Schema.FieldSetMember f : SObjectType.Translation__c.FieldSets.StaticTextTranslationFieldSet.getFields()) {
                                System.debug('######################### getFieldPath'+translationsMap.get(uniqueRecord).get(f.getFieldPath()));
                            proposalRecord.put(f.getFieldPath(), translationsMap.get(uniqueRecord).get(f.getFieldPath()));
                        }
                    }

                    if (priceListMap.size()>0 && priceListMap.containsKey(proposalRecord.Market__c+proposalRecord.Program__c+proposalRecord.CurrencyIsoCode+'TRUE')) {
                        proposalRecord.Apts_Price_List__c=priceListMap.get(proposalRecord.Market__c+proposalRecord.Program__c+proposalRecord.CurrencyIsoCode+'TRUE').Id;
                        proposalRecord.Apttus_QPConfig__PriceListId__c = proposalRecord.Apts_Price_List__c;
                    }

                }
            }
        } catch (exception ex) {
            ExceptionHandler.errorLogAsync(ex.getMessage(), ex.getStackTraceString(),
                    'QuoteProposalsHelper', 'updateQuoteProposalFieldsBeforeCreation', currentRecordId);
        }

    }


//This method will get the record Id based on record name which is stored in custom label
    Public static Id GetRecordTypeId(String recordTypeName) {
        return Schema.SObjectType.Translation__C.RecordTypeInfosByName.get(recordTypeName).RecordTypeId;
    }

    //In this Method we will be used to update Proposal Market,program,product
    // from opportunity and also fields related to Translation record for Translation
    //we will also auto populate the price list based on market and program before updating the proposal record
    public static void updateQuoteProposalFieldsBeforeUpdate(Map<Id,Apttus_Proposal__Proposal__c> oldQuoteproposalMap, List<Apttus_Proposal__Proposal__c> newQuoteproposalList) {
        Id currentRecordId;
        List<string> uniqueStrings = new List<string>();
        try {
            for (Apttus_Proposal__Proposal__c proposalRecord : newQuoteproposalList) {
                currentRecordId = proposalRecord.Id;
                uniqueStrings.add(proposalRecord.Market__c +proposalRecord.Program__c+proposalRecord.CurrencyIsoCode+'TRUE');
                proposalRecord.Apttus_QPConfig__PriceListId__c = proposalRecord.Apts_Price_List__c;
                }
            if (uniqueStrings.size()>0 ) {

                    Map<String,Apttus_Config2__PriceList__c> priceListMap = PriceListSelector.getPriceListForMarketProgramCurrency(uniqueStrings);
                    for (Apttus_Proposal__Proposal__c proposalRecord : newQuoteproposalList) {
                        currentRecordId = proposalRecord.Id;
                        if( oldQuoteproposalMap.size()>0 && oldQuoteproposalMap.containsKey(proposalRecord.Id))
                        {
                            if(oldQuoteproposalMap.get(proposalRecord.Id).Market__c!= proposalRecord.Market__c || oldQuoteproposalMap.get(proposalRecord.Id).Program__c!= proposalRecord.Program__c)
                            {
                                if (priceListMap.size()>0 && priceListMap.containsKey(proposalRecord.Market__c+proposalRecord.Program__c+proposalRecord.CurrencyIsoCode+'TRUE')) {
                                    proposalRecord.Apts_Price_List__c=priceListMap.get(proposalRecord.Market__c+proposalRecord.Program__c+proposalRecord.CurrencyIsoCode+'TRUE').Id;
                                    proposalRecord.Apttus_QPConfig__PriceListId__c = proposalRecord.Apts_Price_List__c;
                                }
                            }

                        }

                    }


            }


        } catch (Exception ex) {
            ExceptionHandler.errorLog(ex.getMessage(), ex.getStackTraceString(),
                    'QuoteProposalsHelper', 'updateQuoteProposalFieldsBeforeUpdate', currentRecordId);
        }

    }
}