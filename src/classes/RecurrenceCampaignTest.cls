/**
 * Created by savita.b on 9/12/2017.
 */

@isTest
    private class RecurrenceCampaignTest
    {
        static testmethod void getRecurrenceForCampaignTest()
        {
            Test.startTest();
            system.runAs(TestDataUtil.createUserRecord())
            {
                campaign parentCampaign=TestDataUtil.createNewCampaign();            
                insert parentCampaign;              
                datetime date1=date.Today();
                List<String> allDates=new List<String>();
                for(integer i=1;i<5;i++)
                {
                    DateTime date2 = date1.addDays(i);
                    string mydate=date2.format('MM/dd/yyyy');
                    allDates.add(mydate);
                }              
                integer numberOfRecurrenceExcepected=allDates.size();
                integer numberOfRecCreated=recurrenceCampaignController.getRecuranceDetails(allDates,parentCampaign.id);             
                System.assertEquals(numberOfRecurrenceExcepected , numberOfRecCreated);
            }
            Test.stopTest();
        }
        static testmethod void getRecurrenceForCampaignWithDupeTest()
        {
            Test.startTest();
            system.runAs(TestDataUtil.createUserRecord())
            {
                campaign parentCampaign=TestDataUtil.createNewCampaign();              
                insert parentCampaign;
                datetime date1=date.Today();
                List<String> allDates=new List<String>();
                for(integer i=0;i<5;i++)
                {
                    Datetime date2 = date1.addDays(i);
                    string mydate=date2.format('MM/dd/yyyy');
                    allDates.add(mydate);
                }
                integer numberOfRecurrenceExcepected=allDates.size();
                integer numberOfRecCreated=recurrenceCampaignController.getRecuranceDetails(allDates,parentCampaign.id);             
                System.assertEquals(numberOfRecurrenceExcepected-1 , numberOfRecCreated );
            }
            Test.stopTest();
        }
    }