/**
 * Created by savita.b on 9/7/2017.
 */

public with sharing class RecurrenceCampaignController {

    @AuraEnabled
    public static integer getRecuranceDetails(List<String> startEndDate,id campaignId)
    {
        integer insertedCamRecords=0;
        try
        {
            Campaign oldCampainRecord=CampaignsSelector.getCampaigns(campaignId);
            List<Campaign> clonedCampaignInsertList=new List<Campaign>();

            for(string dateList : startEndDate)
            {
                String[] splitDate = dateList.split('/');
                Date formattedInputDate =date.newinstance(Integer.valueOf(splitDate[2]),
                                        Integer.valueOf(splitDate[0]), Integer.valueOf(splitDate[1]));

                String[] timeStr = oldCampainRecord.DateFrom__c.format('HH:mm:ss').split(' ');
                String[] onlyTime = timeStr[0].split(':');
                Time myTime =Time.newInstance( Integer.valueof(onlyTime[0].trim()) ,Integer.valueof(onlyTime[1].trim()), Integer.valueof(onlyTime[2].trim()), 0);
                DateTime dateFrom = DateTime.newInstance(formattedInputDate, myTime );

                String[] timeStr1 = oldCampainRecord.DateTo__c.format('HH:mm:ss').split(' ');
                String[] onlyTime1 = timeStr1[0].split(':');
                Time myTime1 =Time.newInstance( Integer.valueof(onlyTime1 [0].trim()) ,Integer.valueof(onlyTime1 [1].trim()), Integer.valueof(onlyTime1 [2].trim()), 0);
                DateTime dateTo = DateTime.newInstance(formattedInputDate, myTime1 );

                Campaign newCampaign=oldCampainRecord.clone(false);
                newCampaign.id=null;
                newCampaign.DateFrom__c=dateFrom;
                newCampaign.DateTo__c=dateTo;
                clonedCampaignInsertList.add(newCampaign);
            }

            Database.SaveResult[] srList = Database.insert(clonedCampaignInsertList, false);
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    insertedCamRecords++;
                }

            }
        }
         catch (Exception ex)
                 {
                     System.debug('The following exception has occurred: ' + ex.getMessage());
                     String errMessage = ex.getMessage();
                     String trace = ex.getStackTraceString();
                     String className = 'recurrenceCampaignController';
                     String methodName = 'getRecuranceDetails';
                     Id id = '';
                     ExceptionHandler.errorLog(errMessage, trace, className, methodName, id);
                 }
        return insertedCamRecords;
    }
}