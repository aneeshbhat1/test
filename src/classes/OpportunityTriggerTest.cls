@isTest
private class OpportunityTriggerTest {
    static testMethod void opportunitySharingTest1() {
    
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()){
            List<Account> accList=TestDataUtil.createAccountRecords(3);
            System.assertNotEquals(NULL, accList , 'null Account List');
            List<Opportunity> oppList = TestDataUtil.createOpportunityRecords(accList,3);
            System.assertNotEquals(NULL, oppList , 'null Opportunity List');
        }
        Test.stopTest();
            
    }
    static testMethod void opportunitySharingTest2() {
    
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()){
            List<Account> accList=TestDataUtil.createAccountRecords(3);
            List<Opportunity> oppList = TestDataUtil.createOpportunityRecords(accList,3);
            System.assertNotEquals(NULL, oppList , 'null Opportunity List');
            
            List<Opportunity> updatedOppList=TestDataUtil.updateOpportunityRecords(oppList);
            System.assertNotEquals(NULL, updatedOppList, 'null updated Opportunity List');
        }
        Test.stopTest();
            
    }
    static testMethod void opportunityTriggerCodeCoverageTest() {
    
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()){
            List<Account> accList=TestDataUtil.createAccountRecords(3);
            System.assertNotEquals(NULL, accList , 'null Account List');
            
            List<Opportunity> oppList = TestDataUtil.createOpportunityRecords(accList,3);
            System.assertNotEquals(NULL, oppList , 'null Opportunity List');
            update oppList;
            delete oppList;
            List<Opportunity> opp =[select ID from Opportunity where ID=:oppList[0].ID ALL ROWS];
            undelete opp;
        
        }
        Test.stopTest();
            
    }
}