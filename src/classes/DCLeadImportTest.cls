/**
 * Created by suresha.shettigar on 6/1/2017.
 */

@isTest(SeeAllData=false)
private class DCLeadImportTest {
    
 /*  static testMethod void testNoLeadDuplicate() {
        Test.startTest();

        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');


            lead newlead = DCTestDataUtil.insertAnotherSetOfLeadRecord();
            insert newlead;
            List<lead> LDList = DCTestDataUtil.insertNewLeadRecords(); //Existing Lead data
            insert LDList;
            account newAcc = DCTestDataUtil.creatAcc();
            insert newacc;
            list<account> accLst = DCTestDataUtil.createAccountRecords(3);
            insert acclst;            
            Map<String, Object> objectData = new Map<String, Object>();

            List<Object> duplicateIncomingLeads = new List<Object>();

            dupcheck.dc3SearchResult dataSet = new dupcheck.dc3SearchResult();
            dataSet.objectData = (Sobject) LDList[0];

            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead;

            duplicateIncomingLeads.add(dataSet1);
            duplicateIncomingLeads.add(dataSet);

            objectData.put('00Q', duplicateIncomingLeads);

            DCSearchPlugin.processResults('ON_UPLOAD;', LDList[1].id, objectData);
            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);

        }
        Test.stopTest();
    }
   
   //Check for no duplicate leads 
   static testMethod void testNoLeadDupe() {
        Test.startTest();

        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');
          
            List<lead> LDList = DCTestDataUtil.leadData();
            insert LDList;
            update LDList;
           
        Map<String, Object> objectData = new Map<String, Object>();            

            DCSearchPlugin.processResults('ON_UPLOAD;', LDList[0].id, objectData);                             

        }
        Test.stopTest();
    }
    
    //Check for duplicate lead
     static testMethod void testLeadDuplicatewithExisting() {
        Test.startTest();

        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');            
            List<lead> LDList = DCTestDataUtil.leaddataa(); //Existing Lead data
            insert LDList;
                        
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            
            dupcheck.dc3SearchResult dataSet = new dupcheck.dc3SearchResult();
            dataSet.objectData = (Sobject) LDList[0];
            duplicateIncomingLeads.add(dataSet);
            objectData.put('00Q', duplicateIncomingLeads);

            DCSearchPlugin.processResults('ON_UPLOAD;', LDList[1].id, objectData);
            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);

        }
        Test.stopTest();
    }
    
    static testMethod void testAccountDupe() {
        Test.startTest();

        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');


            account newAccount = DCTestDataUtil.insertAnotherSetOfaccountRecord();
            insert newAccount;
            List<lead> LDList = DCTestDataUtil.insertNewLeadRecords(); //Existing Lead data
            insert LDList;
            account newAcc = DCTestDataUtil.creatAcc();
            insert newAcc;
            list<account> accLst = DCTestDataUtil.createAccountRecords(3);
            insert accLst;
            list<account> updAcc = DCTestDataUtil.updateAccountRecords(accLst);
            update updAcc;
            Map<String, Object> objectData = new Map<String, Object>();

            List<Object> duplicateIncomingLeads = new List<Object>();

            dupcheck.dc3SearchResult dataSet = new dupcheck.dc3SearchResult();
            dataSet.objectData = (Sobject) LDList[0];

            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newAccount;

            duplicateIncomingLeads.add(dataSet1);
            //   duplicateIncomingLeads.add(dataSet);

            objectData.put('001P', duplicateIncomingLeads);
            //Senario3:"Incoming Lead" Dupe with-->single Account.
            DCSearchPlugin.processResults('ON_UPLOAD;', LDList[1].id, objectData);
          //  DCBusinessHandler.ConvertLead(LDList[1],newAccount);
            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);

        }
        Test.stopTest();
    }

    static testMethod void TestLeadIncomingAccExsis()
    {
        Test.startTest();

        system.runAs(TestDataUtil.createUserRecord()) {
            //custom setting 
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');


            list<account> accs = DCTestDataUtil.insertmultipleAccountRecord();
            insert accs;
            List<lead> LDList = DCTestDataUtil.insertNewLeadRecords(); //Existing Lead data
            insert LDList;
            account newAcc = DCTestDataUtil.creatAcc();
            insert newAcc ;
            list<account> accLst = DCTestDataUtil.createAccountRecords(3);
            insert accLst;
            list<account> updAcc = DCTestDataUtil.updateAccountRecords(accLst);
            update updAcc ;
            Map<String, Object> objectData = new Map<String, Object>();

            List<Object> duplicateIncomingLeads = new List<Object>();
            List<Object> duplicateExistingAccounts = new List<Object>();

            dupcheck.dc3SearchResult dataSet = new dupcheck.dc3SearchResult();
            dataSet.objectData = (Sobject) accs[0];

            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) LDList[0];

            duplicateExistingAccounts.add(dataSet);
            duplicateIncomingLeads.add(dataSet1);

            objectData.put('001P', duplicateExistingAccounts);
            objectData.put('00Q', duplicateIncomingLeads);

            //Senario4:"Incoming Lead" Dupe with-->Single Incoming Lead-->single Account.
            DCSearchPlugin.processResults('ON_UPLOAD;', LDList[1].id, objectData);
          //  DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);

        }
        Test.stopTest();
    }

    static testMethod void testNoAccountDupe() {
        Test.startTest();

        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');


            lead newlead = DCTestDataUtil.insertAnotherSetOfLeadRecord();
            insert newlead;
            List<lead> LDList = DCTestDataUtil.insertNewLeadRecords(); //Existing Lead data
            insert LDList;
            account newAcc = DCTestDataUtil.creatAcc();
            insert newacc;
            list<account> accLst = DCTestDataUtil.createAccountRecords(3);
            insert acclst;
            list<account> updAcc = DCTestDataUtil.updateAccountRecords(accLst);
            update updacc;
            Map<String, Object> objectData = new Map<String, Object>();

            List<Object> duplicateIncomingLeads = new List<Object>();

            dupcheck.dc3SearchResult dataSet = new dupcheck.dc3SearchResult();
            dataSet.objectData = (Sobject) LDList[0];

            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead;

            duplicateIncomingLeads.add(dataSet1);
            duplicateIncomingLeads.add(dataSet);

            objectData.put('00Q', duplicateIncomingLeads);
            //Incoming duplicate Leads.
            DCSearchPlugin.processResults('ON_UPLOAD;', LDList[1].id, objectData);
            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);

        }
        Test.stopTest();
    }*/
    

    static testMethod void testrule14() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('xyz','lastname','city','street',' postalcode','123456','1234567890','1234567890','12345','u@gmail.com','pppp@gmail.com','region',System.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('firstname','lastname','city','street','postalcode','123456','1234567890','1234567890','tritonid','student@gmail.com','studente@gmail.com','region',System.today());
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
     static testMethod void testrule1() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('xyz','lastname','city','street',' postalcode','123456','1234567890','1234567890','12345','u@gmail.com','pppp@gmail.com','region',System.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 =DCTestDataUtil.DynamicinsertNewLeadRecords('xyz','lastname','city','street',' postalcode','123456','1234567890','1234567890','12345','u@gmail.com','pppp@gmail.com','region',System.today());
            newlead.InsertTime__c=system.now();
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    static testMethod void testrule1ForHomephone() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('xyz','lastname','city','street',' postalcode','123456','1234567890','1234567890','12345','u@gmail.com','pppp@gmail.com','region',System.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 =DCTestDataUtil.DynamicinsertNewLeadRecords('xyz','lastname','city','street',' postalcode','123456','123456','123456','12345','u@gmail.com','pppp@gmail.com','region',System.today());
            newlead.InsertTime__c=system.now();
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    static testMethod void testrule1ForMobilephone() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('xyz','lastname','city','street',' postalcode','123456','1234567890','1234567890','12345','u@gmail.com','pppp@gmail.com','region',System.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 =DCTestDataUtil.DynamicinsertNewLeadRecords('xyz','lastname','city','street',' postalcode','1234567890','1234567890','1234567890','12345','u@gmail.com','pppp@gmail.com','region',System.today());
            newlead.InsertTime__c=system.now();
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    static testMethod void testrule1ForOtherphone() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('xyz','lastname','city','street',' postalcode','123456','1234567890','1234567890','12345','u@gmail.com','pppp@gmail.com','region',System.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 =DCTestDataUtil.DynamicinsertNewLeadRecords('xyz','lastname','city','street',' postalcode','1234567890','1234567890','1234567890','12345','u@gmail.com','pppp@gmail.com','region',System.today());
            newlead.InsertTime__c=system.now();
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }

 /*   static testMethod void testrule29() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('xyz','lastname','city','abc',' postalcode','123456','1234567890','1234567890','12345','u@gmail.com','pppp@gmail.com','region',System.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('xyz','lastname','city','street','postalcode','123456','1234567890','1234567890','tritonid','student@gmail.com','studente@gmail.com','region',System.today());
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
        }
    }

    static testMethod void testLeadRank() {
        Test.startTest();

        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');
            List<LeadRankingSetting__c> leadRank = Test.loadData(LeadRankingSetting__c.sObjectType, 'File_LeadRankingSettings');
            List<LegalSettings__c> legal = Test.loadData(LegalSettings__c.sObjectType, 'File_LegalSettings');

            List<lead> LDList = DCTestDataUtil.leadDataforRanking();
            insert LDList;
            LDlist[0].ranking__c=5;
            update LDList;
            
           
        Map<String, Object> objectData = new Map<String, Object>();            

            DCSearchPlugin.processResults('ON_UPLOAD;', LDList[0].id, objectData);                             

        }
        Test.stopTest();
    }
    
    //Test for Rule10
    static testMethod void testrule10() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('XYZ','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('XYZ','ryrhgfgh','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
    static testMethod void testrule11() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('XYZ','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('ghhjbjk','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
    static testMethod void testrule2() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('testfirstname','testlastname','testcity','teststreet','560048','1235678945','1248596357','9876541230','testtritonid','student1@email.com','student2@email.com','testregion', system.today());
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
     static testMethod void testrule3() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','tret@jnj.com','dfdsfd@yahoo.com','testregion',system.today());
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
     static testMethod void testrule12() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('dfdgvf','testlastname','ffdf','dfgff','001234','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
    static testMethod void testrule13() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('gfgbf','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','ertret@email.com','ertgre@email.com','testregion',system.today().adddays(-2));
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }*/
    
     static testMethod void testrule17() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            Account newaccount1 = DCTestDataUtil.DynamicinsertAnotherSetOfaccountRecord('testfirstname','testlastname','fghfh','teststreet','001245','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','rtrfg',True, system.today(), system.today().adddays(-400));
            insert  newaccount1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newaccount1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('001P', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
     static testMethod void testNoDupe() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            Account newaccount1 = DCTestDataUtil.DynamicinsertAnotherSetOfaccountRecord('testfirstname','testlastname','fghfh','teststreet','001245','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','rtrfg',True, system.today(), system.today().adddays(-400));
            insert  newaccount1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newaccount1;
            duplicateIncomingLeads.add(dataSet1);
            duplicateIncomingLeads.clear();
            objectData.put('001P', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
  /*  static testMethod void testrule19() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            Account newaccount1 = DCTestDataUtil.DynamicinsertAnotherSetOfaccountRecord('testfirstname','testlastname','fghfh','teststreet','001245','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','rtrfg',false, system.today(), system.today().adddays(-400));
            insert  newaccount1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newaccount1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('001P', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
    static testMethod void testrule4() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('testfirstname','testlastname','testcity','ghjgj','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
    static testMethod void testrule6() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('testfirstname','testlastname','fgfg','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
    static testMethod void testrule7() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('testfirstname','testlastname','testcity','teststreet','002100','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
    static testMethod void testrule8() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','ghtyii',system.today());
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
    static testMethod void testrule9() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','hjuuyu',system.today().adddays(-2));
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
    static testMethod void testrule20() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','123','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('tyuyrttry','testlastname','tyutuy','yutyubhg','698874','9723445332','7744666333','9954777444','456','student1@email.com','student2@email.com','gyutuyj',system.today());
            newlead1.InsertTime__c=system.now()-1;
            insert  newlead1;
            Account newaccount1 = DCTestDataUtil.DynamicinsertAnotherSetOfaccountRecord('xyz','testlastname','fghfh','teststreet123','001245','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','rtrfg',false, system.today(), system.today().adddays(-400));
            insert  newaccount1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            List<Object> duplicateAccount = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dupcheck.dc3SearchResult dataSet2 = new dupcheck.dc3SearchResult();
            dataSet2.objectData = (Sobject) newaccount1;
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            //duplicateAccount.add(dataSet2);
            objectData.put('00Q', duplicateIncomingLeads);
            
            //objectData.put('001P',duplicateAccount);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
    static testMethod void testrule21() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('testfirstname','testlastname','testcity','teststreet','235645','0012456378','9875641235','2345698741','testtritonid','student1@email.com','student2@email.com','ghgfh',system.today());
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
    static testMethod void testrule25() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('testfirstname','testlastname','testcity','ghjtyj','560048','0012589634','0012456357','0234517856','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
    static testMethod void testrule26() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('testfirstname','testlastname','ytutu','tytuygh','023145','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','hjkyu',system.today());
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
     static testMethod void testrule27() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('testfirstname','testlastname','testcity','teststreet','560048','@@#$%6745@','@@#$%6745@','@@#$%6745@','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
    static testMethod void testrule28() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('testfirstname','testlastname','testcity','teststreet','560048','0012456358','0235896478','0365896478','testtritonid','yuyuy@ef.com','tyrygh@gmty.com','testregion',system.today());
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
    static testMethod void testrule31() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('testfirstname','ghghuy','testcity','gytygh','032563','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    static testMethod void testrule32() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('testfirstname','tytuyyiu','tyutuy','tyutyu','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
    static testMethod void testrule33() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('testfirstname','testlastname','tyutu','gyutuyt','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today().adddays(-2));
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
    static testMethod void testrule36() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('tyututyu','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','yutuytu',system.today().adddays(-3));
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }
    
    static testMethod void testrule37() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
            List<LeadAccountMapping__c> newLeads1 = Test.loadData(LeadAccountMapping__c.sObjectType, 'File_LeadAccountMapping');
            List<MergeRuleConfig__c> LeadswithRules1 = Test.loadData(MergeRuleConfig__c.sObjectType, 'File_NewLeadRules1');

            lead newlead = DCTestDataUtil.DynamicinsertNewLeadRecords('testfirstname','testlastname','testcity','teststreet','560048','9723445332','7744666333','9954777444','testtritonid','student1@email.com','student2@email.com','testregion',system.today());
            newlead.InsertTime__c=system.now();
            insert newlead;
            lead newlead1 = DCTestDataUtil.DynamicinsertAnotherSetOfLeadRecord('testfirstname','testlastname','tyutuyy','teststreet','560048','0123569874','0214589632','9874563254','testtritonid','student1@email.com','student2@email.com','tyutu',system.today().adddays(-2));
            newlead1.InsertTime__c=datetime.now()-1;
            insert  newlead1;
            Map<String, Object> objectData = new Map<String, Object>();
            List<Object> duplicateIncomingLeads = new List<Object>();
            dupcheck.dc3SearchResult dataSet1 = new dupcheck.dc3SearchResult();
            dataSet1.objectData = (Sobject) newlead1;
            duplicateIncomingLeads.add(dataSet1);
            objectData.put('00Q', duplicateIncomingLeads);
            DCSearchPlugin.processResults('ON_UPLOAD;', newlead.id, objectData);

            //DCBusinessHelpher.ProcessAfterMergeorConvert(MergableLeadsWithRules,existingLead,null,null,null);
            // DCBusinessHandler.ProcessDCSearchPlugin('ON_UPLOAD',LDList[1].id,objectData);
            Test.stopTest();
             }
    }*/
    
}