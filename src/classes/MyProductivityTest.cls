/**************************************************************************************
Apex Class Name    : MyProductivityTest
Version            : 1.0
Created Date       : Dec 6 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Arkadiusz Celej             6-dec-2017              Original Version
*******************************************************************************/
@IsTest
private class MyProductivityTest {
    static testMethod void shouldRetrieveDefaultStatistics() {
        //given
        Account acc = TestDataUtil.creatPersonAccount();
        insert acc;
        Map<String, String> oppFields = new Map<String, String>();
        Opportunity opp = TestDataUtil.createOpportunityForAccount(acc.Id, 'Test Opp', oppFields, true);
        Map<String, String> taskFields = new Map<String, String>();
        TestDataUtil.createTaskForOpportunity(opp.Id, taskFields, true);
        //when
        Test.startTest();
        MyProductivity.MyStatistics stats = MyProductivity.getMyStatistics();
        Test.stopTest();
        //then
        System.assertEquals(0, stats.myReachedTasks);
        System.assertEquals(0, stats.myCompletedTasks);
        System.assertEquals(0, stats.myLeads);
        System.assertEquals(0, stats.weeksBooked);
    }

    static testMethod void shouldRetrieveStatistics() {
        //given
        Account acc = TestDataUtil.creatPersonAccount();
        insert acc;
        Map<String, String> oppFields = new Map<String, String>();
        Opportunity opp = TestDataUtil.createOpportunityForAccount(acc.Id, 'Test Opp', oppFields, true);
        Map<String, String> taskFields = new Map<String, String>();
        taskFields.put('Status','Completed');
        taskFields.put('CloseDate__c',String.valueOf(System.Now()));
        taskFields.put('ClosedBy__c',UserInfo.getUserId());
        TestDataUtil.createTaskForOpportunity(opp.Id, taskFields, true);

        taskFields.put('SalesAction__c','Call Reached');
        TestDataUtil.createTaskForOpportunity(opp.Id, taskFields, true);

        //when
        Test.startTest();
        MyProductivity.MyStatistics stats = MyProductivity.getMyStatistics();
        Test.stopTest();
        //then
        System.assertEquals(1, stats.myReachedTasks, 'Incorrect number of Reached tasks');
        System.assertEquals(2, stats.myCompletedTasks, 'Incorrect number of Completed Tasks tasks');
        System.assertEquals(0, stats.myLeads);
        System.assertEquals(0, stats.weeksBooked);
    }
}