@isTest
private class LeadTriggerTest 
{
    static testmethod void leadsharingTest1()
    {
       Test.startTest();
        system.runAs(TestDataUtil.createUserRecord())
        {
              List<lead> LDList=TestdataUtil.insertLeadRecord();
              insert LDList;
              System.assertNotEquals(NULL, LDList , 'null lead List');     
        }
       Test.stopTest();
    }
    
    
    static testmethod void leadsharingTest2()
    {
       Test.startTest();
        system.runAs(TestDataUtil.createUserRecord())
        {
              List<lead> LDList=TestdataUtil.insertLeadRecord();
              insert LDList;
              List<lead> UpLead=TestdataUtil.updateLEADRecords(LDList); 
              update UpLead;
              System.assertNotEquals(NULL, UpLead , 'null lead List');
        }
       Test.stopTest();
    }
    
    static testmethod void leadsharingTest3()
    {
       Test.startTest();
        system.runAs(TestDataUtil.createUserRecord())
        {
             lead LDList=TestdataUtil.insertAnotherSetOfLeadRecord();
             insert LDList;
             lead DeleteList=TestdataUtil.DeleteLeads(LDList);
             delete DeleteList;
              System.assertNotEquals(NULL, LDList , 'null lead List');     
        }
       Test.stopTest();
    }
    
    static testmethod void leadsharingTest4()
    {
       Test.startTest();
        system.runAs(TestDataUtil.createUserRecord())
        {
             lead LDList=TestdataUtil.insertAnotherSetOfLeadRecord();
             insert LDList;
             lead UnDeleteList=TestdataUtil.UnDeleteLeads(LDList);
             undelete UnDeleteList;
              System.assertNotEquals(NULL, LDList , 'null lead List');     
        }
       Test.stopTest();
    }
   
    static testmethod void leadsharingTest5()
    {
       Test.startTest();
        system.runAs(TestDataUtil.createUserRecord())
        {
              lead LDList=TestdataUtil.insertAnotherSetOfLeadRecord();
              insert LDList;
              lead UpLeadKey=TestdataUtil.UpdateSharingKey(LDList); 
              update UpLeadKey;
              System.assertNotEquals(NULL, UpLeadKey, 'null lead List');
        }
       Test.stopTest();
    }

   
    
}