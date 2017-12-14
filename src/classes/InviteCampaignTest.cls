/**
 * Created by thejasvi.a on 9/11/2017.
 */

@isTest(SeeAllData=false)
private class InviteCampaignTest {

    static testMethod void getInitialDataTest() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {           
            
            List<Campaign> campaignList = new List<Campaign>();
            List<String> market = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Market__c').values();
            List<String> product = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Product__c').values();
            List<String> meetingType = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'MeetingType__c').values();
            String salesOffice= FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'SalesOffice__c').get(market[0])[0];
             system.debug('>>>>market'+market[0]);
            system.debug('>>>>salesOffice'+salesOffice);
            String meetingCity = FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'MeetingCity__c').get(market[0])[0];
            string program = FieldUtilityClass.getFieldDependencies('Campaign','Product__c','Program__c').get(product[0])[0];
            string meetingStatus = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Status').values()[0];
            DateTime dateAndTime = DateTime.now();

            for (integer i = 0; i < 5; i++) {
            if((market[0] != '' && market[0] != null ) && ( product[0]!= '' && product[0]!= null) && ( meetingType[0] != '' && meetingType[0] != null) && ( salesOffice!='' && salesOffice!=null) && ( meetingCity!= '' && meetingCity!= null) && ( program!= '' &&  program!= null) && (meetingStatus!= '' && meetingStatus!= null)){
                           
                campaign campaignRecord = new campaign();
                campaignRecord = TestDataUtil.createDynamicCampaigns(market[0],product[0], meetingType[0],salesOffice,meetingCity,program, meetingStatus, dateAndTime.addHours(4 + i), dateAndTime.addHours(5 + i), 20, 'testCamp' + i);
                campaignList.add(campaignRecord);              
            }
            }


            Account newAcc = DCTestDataUtil.creatAcc();
            newAcc.Market__c= market[0] ;
            system.debug('marketAccount'+ newAcc.Market__c);
            insert newacc;
            Id accountId = newacc.id;
            string dateValue = string.valueof(System.today());
            Map<String,String> opportunityFieldValues = new Map<String,String>
            {
                    'AccountID'=>accountId,
                    'Market__c'=>market[0],
                    'Product__c'=>product[0],
                    'SalesOffice__c'=>salesOffice,
                    'Program__c'=>program,
                    'StageName'=>'Open',
                    'Name'=>'TestOpportunity',
                   'Closedate' => dateValue
            };
                    Opportunity newOpportunity = TestDataFactory.createOpportunityForAccount(newacc.id,'Testopportunity',opportunityFieldValues,True);
                  

            string programs = FieldUtilityClass.getFieldDependencies('Campaign','Product__c','Program__c').get(product[2])[2];
            String salesOffices= FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'SalesOffice__c').get(market[16])[0];
            system.debug('salesOffices>>>>'+salesOffices);
            String meetingCity1 = FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'MeetingCity__c').get(market[16])[0];
            DateTime dateAndTimee = DateTime.now();

            for (integer i = 0; i < 5; i++) {               
                if((market[1] != '' && market[1] != null ) && ( product[2]!= '' && product[2]!= null) && ( meetingType[1] != '' && meetingType[1] != null) && ( salesOffices!='' && salesOffices!=null) && ( meetingCity1!= '' && meetingCity1!= null) && ( programs!= '' &&  programs!= null) && (meetingStatus!= '' && meetingStatus!= null)){
                campaign campaignRecord = new campaign();
                campaignRecord = TestDataUtil.createDynamicCampaigns(market[16],product[2], meetingType[1],salesOffices,meetingCity1,programs, meetingStatus,dateAndTime.addHours(4 + i), dateAndTime.addHours(5 + i) , 20, 'testCamp' + i);
                campaignList.add(campaignRecord);               
                }
            }
            insert campaignList;
            
           List<Invitecampaign.CampaignWrapper> camp =  InviteCampaign.getInitialCampaignData(newOpportunity.Id,DateTime.now());
            System.assertEquals(5, camp.size());
            Test.stopTest();
         }
    }
    
   static testMethod void getCampaignsFoProgramTest(){
         Test.startTest();
         system.runAs(TestDataUtil.createUserRecord()) {         

            List<Campaign> campaignList = new List<Campaign>();
            List<Campaign> campaignList2 = new List<Campaign>();
            List<Campaign> campaignList3 = new List<Campaign>();
            List<String> market = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Market__c').values();
             system.debug('>>>>market'+market[0]);
            List<String> product = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Product__c').values();
            List<String> meetingType = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'MeetingType__c').values();
            String salesOffice= FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'SalesOffice__c').get(market[0])[0];
            String meetingCity = FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'MeetingCity__c').get(market[0])[0];
            string program = FieldUtilityClass.getFieldDependencies('Campaign','Product__c','Program__c').get(product[0])[0];
            string meetingStatus = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Status').values()[0];
            DateTime dateAndTime = DateTime.now();
                        
            Account newAcc = DCTestDataUtil.creatAcc();
            newAcc.Market__c= market[0] ;
             system.debug('>>>>ProgramTestMarketAccount'+ newAcc.Market__c);
            insert newacc;
            Opportunity newOpportunity = testDataUtil.createopportunity(newacc,market[0],product[0],salesOffice,program);
             system.debug('>>>>ProgramTestMarketOpp'+newOpportunity );
            insert newOpportunity;
 
            for (integer i = 0; i < 3; i++) {
            if((market[0] != '') && ( product[0]!= '') && ( meetingType[0] != '') && ( salesOffice!='') && ( meetingCity!= '') && ( program!= '') && (meetingStatus!= '')){
                campaign campaignRecord = new campaign();
                campaignRecord = TestDataUtil.createDynamicCampaigns(market[0],product[0], meetingType[0],salesOffice,meetingCity,program, meetingStatus, dateAndTime.addHours(4 + i), dateAndTime.addHours(5 + i), 20, 'testCamp' + i);
                campaignList.add(campaignRecord);
                }
            }
            insert campaignList; 
                     
             string[] programss= new String[]{campaignList[0].program__c};
             string myJSONprogram = JSON.serialize(programss);          
                                                     
             List<InviteCampaign.CampaignWrapper> camp = InviteCampaign.getCampaignsWithFilter(newOpportunity.Id,'',myJSONprogram ,'','',null,null);           
             
             string program2 = FieldUtilityClass.getFieldDependencies('Campaign','Product__c','Program__c').get(product[2])[2];  
             
              for (integer i = 0; i < 3; i++) {
              if((market[0] != '') && ( product[2]!= '') && ( meetingType[0] != '') && ( salesOffice!='') && ( meetingCity!= '') && ( program2!= '') && (meetingStatus!= '')){
                campaign campaignRecord = new campaign();
                campaignRecord = TestDataUtil.createDynamicCampaigns(market[0],product[2], meetingType[0],salesOffice,meetingCity,program2, meetingStatus, dateAndTime.addHours(4 + i), dateAndTime.addHours(5 + i), 20, 'testCamp' + i);
                campaignList2.add(campaignRecord);
                }
            }
            insert campaignList2;    


            string[] programs2= new String[]{campaignList2[0].program__c};
            string myJSONprogram2 = JSON.serialize(programs2);           
             
            List<String> tokens = new List<String>{myJSONprogram, myJSONprogram2};
            string str = myJSONprogram+myJSONprogram2;
            List<InviteCampaign.CampaignWrapper> camp2 = InviteCampaign.getCampaignsWithFilter(newOpportunity.Id,'',str ,'','',null,null);         
            System.assertEquals(camp2.size(),3);
                                              
            Test.stopTest();
        }
    }
    
     static testMethod void getCampaignsForSalesOfficeTest(){
         Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {

            List<Campaign> campaignList = new List<Campaign>();
            List<Campaign> campaignList2 = new List<Campaign>();
            List<Campaign> campaignList3 = new List<Campaign>();
            List<String> market = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Market__c').values();
            List<String> product = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Product__c').values();
            List<String> meetingType = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'MeetingType__c').values();
            String salesOffice= FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'SalesOffice__c').get(market[0])[0];
            String meetingCity = FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'MeetingCity__c').get(market[0])[0];
            string program = FieldUtilityClass.getFieldDependencies('Campaign','Product__c','Program__c').get(product[0])[0];
            string meetingStatus = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Status').values()[0];
            DateTime dateAndTime = DateTime.now();
                        
            Account newAcc = DCTestDataUtil.creatAcc();
            newAcc.Market__c= market[0] ;
            insert newacc;
            Opportunity newOpportunity = testDataUtil.createopportunity(newacc,market[0],product[0],salesOffice,program);
            insert newOpportunity;
 
            for (integer i = 0; i < 3; i++) {
            if((market[0] != '') && ( product[0]!= '') && ( meetingType[0] != '') && ( salesOffice!='') && ( meetingCity!= '') && ( program!= '') && (meetingStatus!= '')){
                campaign campaignRecord = new campaign();
                campaignRecord = TestDataUtil.createDynamicCampaigns(market[0],product[0], meetingType[0],salesOffice,meetingCity,program, meetingStatus, dateAndTime.addHours(4 + i), dateAndTime.addHours(5 + i), 20, 'testCamp' + i);
                campaignList.add(campaignRecord);
                }
            }
            insert campaignList;                        
            
            string[] salesoffice1= new String[]{campaignList[0].SalesOffice__c};
            string myJSONsalesoffice1 = JSON.serialize(salesoffice1);            
                                                     
             List<InviteCampaign.CampaignWrapper> camp = InviteCampaign.getCampaignsWithFilter(newOpportunity.Id,myJSONsalesoffice1,'' ,'','',null,null);           
             
            String salesOffices= FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'SalesOffice__c').get(market[1])[0];
            String meetingCity1 = FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'MeetingCity__c').get(market[1])[0];
             
              for (integer i = 0; i < 3; i++) {
              if((market[1] != '') && ( product[0]!= '') && ( meetingType[0] != '') && ( salesOffices!='') && ( meetingCity1!= '') && ( program!= '') && (meetingStatus!= '')){
                campaign campaignRecord = new campaign();
                campaignRecord = TestDataUtil.createDynamicCampaigns(market[1],product[0], meetingType[0],salesOffices,meetingCity1,program, meetingStatus, dateAndTime.addHours(4 + i), dateAndTime.addHours(5 + i), 20, 'testCamp' + i);
                campaignList2.add(campaignRecord);
                }
            }
            insert campaignList2;    


             string[] salesoffice2= new String[]{campaignList2[0].SalesOffice__c};
             string myJSONsalesoffice2 = JSON.serialize(salesoffice2);
          
            List<String> tokens = new List<String>{myJSONsalesoffice1, myJSONsalesoffice2};
            string str = myJSONsalesoffice1+myJSONsalesoffice2;
           
          
             List<InviteCampaign.CampaignWrapper> camp2 = InviteCampaign.getCampaignsWithFilter(newOpportunity.Id,str,'','','',null,null);
          
            System.assertEquals(camp2.size(),3);
                                              
            Test.stopTest();
        }
    }
    
     static testMethod void getCampaignsForMeetingTypeTest() {
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {        

            List<Campaign> campaignList = new List<Campaign>();
            List<Campaign> campaignList2 = new List<Campaign>();
            List<Campaign> campaignList3 = new List<Campaign>();
            List<String> market = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Market__c').values();
            List<String> product = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Product__c').values();
            List<String> meetingType = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'MeetingType__c').values();
            String salesOffice= FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'SalesOffice__c').get(market[0])[0];
            String meetingCity = FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'MeetingCity__c').get(market[0])[0];
            string program = FieldUtilityClass.getFieldDependencies('Campaign','Product__c','Program__c').get(product[0])[0];
            string meetingStatus = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Status').values()[0];
            DateTime dateAndTime = DateTime.now();
                        
            Account newAcc = DCTestDataUtil.creatAcc();
            insert newacc;
            Opportunity newOpportunity = testDataUtil.createopportunity(newacc,market[0],product[0],salesOffice,program);
            insert newOpportunity;
 
            for (integer i = 0; i < 3; i++) {
            if((market[0] != '') && ( product[0]!= '') && ( meetingType[0] != '') && ( salesOffice!='') && ( meetingCity!= '') && ( program!= '') && (meetingStatus!= '')){
                campaign campaignRecord = new campaign();
                campaignRecord = TestDataUtil.createDynamicCampaigns(market[0],product[0], meetingType[0],salesOffice,meetingCity,program, meetingStatus, dateAndTime.addHours(4 + i), dateAndTime.addHours(5 + i), 20, 'testCamp' + i);
                campaignList.add(campaignRecord);
            }
            }
            insert campaignList;                       
            
            string[] meetingType1 = new String[]{campaignList[0].MeetingType__c};
            string myJSONmeetingType1 = JSON.serialize(meetingType1);            
                                                     
             List<InviteCampaign.CampaignWrapper> camp = InviteCampaign.getCampaignsWithFilter(newOpportunity.Id,'','' ,myJSONmeetingType1,'',null,null);                                        
             
              for (integer i = 0; i < 3; i++) {
              if((market[0] != '') && ( product[0]!= '') && ( meetingType[1] != '') && ( salesOffice!='') && ( meetingCity!= '') && ( program!= '') && (meetingStatus!= '')){
                campaign campaignRecord = new campaign();
                campaignRecord = TestDataUtil.createDynamicCampaigns(market[0],product[0], meetingType[1],salesOffice,meetingCity,program, meetingStatus, dateAndTime.addHours(4 + i), dateAndTime.addHours(5 + i), 20, 'testCamp' + i);
                campaignList2.add(campaignRecord);
            }
            }
            insert campaignList2;    


            string[] meetingType2= new String[]{campaignList2[0].MeetingType__c};
            string myJSONmeetingType2 = JSON.serialize(meetingType2);                     
            string str = myJSONmeetingType1+myJSONmeetingType2;           
          
            List<InviteCampaign.CampaignWrapper> camp2 = InviteCampaign.getCampaignsWithFilter(newOpportunity.Id,'','',str,'',null,null);          
            System.assertEquals(camp2.size(),3);                                              
            Test.stopTest();
        }
    }
    
     static testMethod void getCampaignsForMeetingCityTest(){
        
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {

            List<Campaign> campaignList = new List<Campaign>();
            List<Campaign> campaignList2 = new List<Campaign>();
            List<Campaign> campaignList3 = new List<Campaign>();
            List<String> market = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Market__c').values();
            List<String> product = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Product__c').values();
            List<String> meetingType = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'MeetingType__c').values();
            String salesOffice= FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'SalesOffice__c').get(market[0])[0];
            String meetingCity = FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'MeetingCity__c').get(market[0])[0];
            string program = FieldUtilityClass.getFieldDependencies('Campaign','Product__c','Program__c').get(product[0])[0];
            string meetingStatus = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Status').values()[0];
            DateTime dateAndTime = DateTime.now();
                        
            Account newAcc = DCTestDataUtil.creatAcc();
            insert newacc;
            Opportunity newOpportunity = testDataUtil.createopportunity(newacc,market[0],product[0],salesOffice,program);
            insert newOpportunity;
 
            for (integer i = 0; i < 3; i++) {
            if((market[0]!='')  && (product[0]!='')  &&  (meetingType[0]!='' ) && (salesOffice!='')  && (meetingCity!='')  && (program!='')  &&  (meetingStatus!='')){
                campaign campaignRecord = new campaign();
                campaignRecord = TestDataUtil.createDynamicCampaigns(market[0],product[0], meetingType[0],salesOffice,meetingCity,program, meetingStatus, dateAndTime.addHours(4 + i), dateAndTime.addHours(5 + i), 20, 'testCamp' + i);
                campaignList.add(campaignRecord);
            }
            }
            insert campaignList;            
            
            string[] meetingCity1 = new String[]{campaignList[0].MeetingCity__c};
            string myJSONmeetingCity1 = JSON.serialize(meetingCity1);            
                                                     
             List<InviteCampaign.CampaignWrapper> camp = InviteCampaign.getCampaignsWithFilter(newOpportunity.Id,'','' ,'',myJSONmeetingCity1 ,null,null);                                 
                                     
             String meetingCitys = FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'MeetingCity__c').get(market[1])[0];
             String salesOffices = FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'SalesOffice__c').get(market[1])[0];
             
              for (integer i = 0; i < 3; i++) {
              if((market[1] != '') && ( product[0]!= '') && ( meetingType[0] != '') && ( salesOffices!='') && ( meetingCitys!= '') && ( program!= '') && (meetingStatus!= '')){
                campaign campaignRecord = new campaign();
                campaignRecord = TestDataUtil.createDynamicCampaigns(market[1],product[0], meetingType[0],salesOffices,meetingCitys,program, meetingStatus, dateAndTime.addHours(4 + i), dateAndTime.addHours(5 + i), 20, 'testCamp' + i);
                campaignList2.add(campaignRecord);
                }
            }
            insert campaignList2;    


             string[] meetingCity2= new String[]{campaignList2[0].MeetingCity__c};
             string myJSONmeetingCity2 = JSON.serialize(meetingCity2);
                     
            string str = myJSONmeetingCity1+myJSONmeetingCity2;
           
          
             List<InviteCampaign.CampaignWrapper> camp2 = InviteCampaign.getCampaignsWithFilter(newOpportunity.Id,'','','',str,null,null);
          
            System.assertEquals(camp2.size(),3);
                                              
            Test.stopTest();
        }
    }
    

    static testMethod void getCampaignsForDateToTest(){
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {         

            List<Campaign> campaignList = new List<Campaign>();
            List<String> market = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Market__c').values();
            List<String> product = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Product__c').values();
            List<String> meetingType = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'MeetingType__c').values();
            String salesOffice = FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'SalesOffice__c').get(market[0])[0];
            String meetingCity = FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'MeetingCity__c').get(market[0])[0];
            string program = FieldUtilityClass.getFieldDependencies('Campaign', 'Product__c', 'Program__c').get(product[0])[0];
            string meetingStatus = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Status').values()[0];
            DateTime dateAndTime = DateTime.now();

            Account newAcc = DCTestDataUtil.creatAcc();
            insert newacc;
            Opportunity newOpportunity = testDataUtil.createopportunity(newacc, market[0], product[0], salesOffice, program);
            insert newOpportunity;


            for (integer i = 0; i < 5; i++) {
            if((market[0] != '') && ( product[0]!= '') && ( meetingType[0] != '') && ( salesOffice!='') && ( meetingCity!= '') && ( program!= '') && (meetingStatus!= '')){
                campaign campaignRecord = new campaign();
                campaignRecord = TestDataUtil.createDynamicCampaigns(market[0], product[0], meetingType[0], salesOffice, meetingCity, program, meetingStatus, dateAndTime.addHours(4 + i), dateAndTime.addHours(5 + i), 20, 'testCamp' + i);
                campaignList.add(campaignRecord);
            }
            }
            insert campaignList;

            Datetime[] dateto= new Datetime[]{campaignList[0].DateTo__c};
            
            List<InviteCampaign.CampaignWrapper> camp2= InviteCampaign.getCampaignsWithFilter(newOpportunity.Id, '', '', '', '',null, dateto[0]);
            System.assertEquals(camp2.size(),1);
            Test.stopTest();

        }

    }

    static testMethod void getCampaignsForDateFromTest(){
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
          
            List<Campaign> campaignList = new List<Campaign>();
            List<String> market = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Market__c').values();
            List<String> product = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Product__c').values();
            List<String> meetingType = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'MeetingType__c').values();
            String salesOffice = FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'SalesOffice__c').get(market[0])[0];
            String meetingCity = FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'MeetingCity__c').get(market[0])[0];
            string program = FieldUtilityClass.getFieldDependencies('Campaign', 'Product__c', 'Program__c').get(product[0])[0];
            string meetingStatus = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Status').values()[0];
            DateTime dateAndTime = DateTime.now();

            Account newAcc = DCTestDataUtil.creatAcc();
            insert newacc;
            Opportunity newOpportunity = testDataUtil.createopportunity(newacc, market[0], product[0], salesOffice, program);
            insert newOpportunity;


            for (integer i = 0; i < 5; i++) {
            if((market[0] != '') && ( product[0]!= '') && ( meetingType[0] != '') && ( salesOffice!='') && ( meetingCity!= '') && ( program!= '') && (meetingStatus!= '')){
                campaign campaignRecord = new campaign();
                campaignRecord = TestDataUtil.createDynamicCampaigns(market[0], product[0], meetingType[0], salesOffice, meetingCity, program, meetingStatus, dateAndTime.addHours(4 + i), dateAndTime.addHours(5 + i), 20, 'testCamp' + i);
                campaignList.add(campaignRecord);
            }
            }
            insert campaignList;

            Datetime[] datefrom= new Datetime[]{campaignList[0].Datefrom__c};
             
            List<InviteCampaign.CampaignWrapper> camp2= InviteCampaign.getCampaignsWithFilter(newOpportunity.Id, '', '', '', '', datefrom[0], null);
             System.assertEquals(camp2.size(),5);
             Test.stopTest();

        }

    }

    static testMethod void getCampaigns(){
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {           

            List<Campaign> campaignList = new List<Campaign>();
            List<String> market = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Market__c').values();
            List<String> product = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Product__c').values();
            List<String> meetingType = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'MeetingType__c').values();
            String salesOffice = FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'SalesOffice__c').get(market[0])[0];
            String meetingCity = FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'MeetingCity__c').get(market[0])[0];
            string program = FieldUtilityClass.getFieldDependencies('Campaign', 'Product__c', 'Program__c').get(product[0])[0];
            string meetingStatus = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Status').values()[0];
            DateTime dateAndTime = DateTime.now();

            Account newAcc = DCTestDataUtil.creatAcc();
            insert newacc;
            Opportunity newOpportunity = testDataUtil.createopportunity(newacc, market[0], product[0], salesOffice, program);
            insert newOpportunity;


            for (integer i = 0; i < 5; i++) {
            if((market[0] != '') && ( product[0]!= '') && ( meetingType[0] != '') && ( salesOffice!='') && ( meetingCity!= '') && ( program!= '') && (meetingStatus!= '')){
                campaign campaignRecord = new campaign();
                campaignRecord = TestDataUtil.createDynamicCampaigns(market[0], product[0], meetingType[0], salesOffice, meetingCity, program, meetingStatus, dateAndTime.addHours(4 + i), dateAndTime.addHours(5 + i), 20, 'testCamp' + i);
                campaignList.add(campaignRecord);
            }
            }
            insert campaignList;


            List<InviteCampaign.CampaignWrapper> camp2= InviteCampaign.getCampaignsWithFilter(newOpportunity.Id, '', '', '', '', null, dateAndTime.addHours(4));
            Test.stopTest();

        }

    }

    static testMethod void addToCampaignTest(){
        Test.startTest();
        system.runAs(TestDataUtil.createUserRecord()) {
           
            List<Campaign> campaignList = new List<Campaign>();
            List<String> market = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Market__c').values();
            List<String> product = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Product__c').values();
            List<String> meetingType = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'MeetingType__c').values();
            String salesOffice = FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'SalesOffice__c').get(market[0])[0];
            String meetingCity = FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'MeetingCity__c').get(market[0])[0];
            string program = FieldUtilityClass.getFieldDependencies('Campaign', 'Product__c', 'Program__c').get(product[0])[0];
            string meetingStatus = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Status').values()[0];
            DateTime dateAndTime = DateTime.now();
      
            Account newAccount = TestDataUtil.creatPersonAccount();                      
            insert newAccount;
            Opportunity newOpportunity = testDataUtil.createopportunity(newAccount, market[0], product[0], salesOffice, program);
            insert newOpportunity;


            for (integer i = 0; i < 5; i++) {
            if((market[0] != '') && ( product[0]!= '') && ( meetingType[0] != '') && ( salesOffice!='') && ( meetingCity!= '') && ( program!= '') && (meetingStatus!= '')){
                campaign campaignRecord = new campaign();
                campaignRecord = TestDataUtil.createDynamicCampaigns(market[0], product[0], meetingType[0], salesOffice, meetingCity, program, meetingStatus, dateAndTime.addHours(4 + i), dateAndTime.addHours(5 + i), 20, 'testCamp' + i);
                campaignList.add(campaignRecord);
            }
            }
            insert campaignList;
                      
            List<Campaign> JsonCampaignList= campaignList;         
            string addcampaign = JSON.serialize(JsonCampaignList);          
            InviteCampaign.AddCampaigns(addcampaign ,newOpportunity.Id);              
            List<CampaignMember> campaignMembers =  [select Id,CampaignId,ContactId,status FROM CampaignMember where campaignId  in:campaignList];           
            System.assertEquals(campaignMembers.size(),5);          
            Test.stopTest();

        }

    }
    
     static testMethod void codeCoverage(){
        Test.startTest();
           system.runAs(TestDataUtil.createUserRecord()) {
          
            List<Campaign> campaignList = new List<Campaign>();
            List<Campaign> campaignList2 = new List<Campaign>();
            List<Campaign> campaignList3 = new List<Campaign>();
            List<String> market = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Market__c').values();
            List<String> product = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Product__c').values();
            List<String> meetingType = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'MeetingType__c').values();
            String salesOffice= FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'SalesOffice__c').get(market[0])[0];
            String meetingCity = FieldUtilityClass.getFieldDependencies('Campaign', 'Market__c', 'MeetingCity__c').get(market[0])[0];
            string program = FieldUtilityClass.getFieldDependencies('Campaign','Product__c','Program__c').get(product[0])[0];
            string meetingStatus = FieldUtilityClass.getPickListValues(Campaign.getSObjectType(), 'Status').values()[0];
            DateTime dateAndTime = DateTime.now();
                        
            Account newAcc = DCTestDataUtil.creatAcc();
            insert newacc;
            Opportunity newOpportunity = testDataUtil.createopportunity(newacc,market[0],product[0],salesOffice,program);
            insert newOpportunity;
 
            for (integer i = 0; i < 3; i++) {
            if((market[0] != '') && ( product[0]!= '') && ( meetingType[0] != '') && ( salesOffice!='') && ( meetingCity!= '') && ( program!= '') && (meetingStatus!= '')){
                campaign campaignRecord = new campaign();
                campaignRecord = TestDataUtil.createDynamicCampaigns(market[0],product[0], meetingType[0],salesOffice,meetingCity,program, meetingStatus, dateAndTime.addHours(4 + i), dateAndTime.addHours(5 + i), 20, 'testCamp' + i);
                campaignList.add(campaignRecord);
                }
            }
            insert campaignList;            
            
            InviteCampaign.getInitialData(campaignList[0].id);
            InviteCampaign.getMeetingCity(newOpportunity.id);
            InviteCampaign.getProgram(newOpportunity.id);
            InviteCampaign.getsalesoffice(newOpportunity.id);
            InviteCampaign.getMeetingTypes();
            InviteCampaign.getcampaigns();
            InviteCampaign.getMarket(newOpportunity.id);                    
                                              
            Test.stopTest();
        }
       

    }
 
    }