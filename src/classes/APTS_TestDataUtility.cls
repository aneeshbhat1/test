/*******************************************************************************************************************************************
* @author        Karan Khatri
* @date          25/11/2016        
* @description   This class creates test data for test classes.
*******************************************************************************************************************************************/ 
@isTest
public class APTS_TestDataUtility {


	//Method to fetch profile
    public static Profile getProfile(String profileName){
        Profile profile = [SELECT Id FROM Profile WHERE Name =: ProfileName limit 1];
        return profile;    
    }

    //creating user
    public static User createUser(Id profileId){
        
        User objUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='ISO-8859-1', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = profileId, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='sudhavish613@gmail.com');
        insert objUser ;
        system.assertNotEquals(null, objUser.Id);
        system.debug('User Inserted!!!!!!!');
        return objUser ;
    }

    //Create Quote/Proposal record
    public static Apttus_Proposal__Proposal__c createProposal(String propName, Id oppId, String currcode, Id accId, String QuoteType, ID priceListId) {
        ID QuoteRecTypeId;
        if(QuoteType=='Proposal')
        {
            QuoteRecTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        }
        Apttus_Proposal__Proposal__c prop = new Apttus_Proposal__Proposal__c(
            Apttus_Proposal__Proposal_Name__c = propName,
            Apttus_Proposal__Opportunity__c  = oppId,
            RecordTypeId = QuoteRecTypeId,
            Apttus_QPConfig__PriceListId__c=priceListId,
            Apttus_Proposal__Account__c = accId);
        return prop;
    }

    //Create Opportunity record
    public static Opportunity createOpportunities(ID acctId, User owner) {
        Opportunity oppty = new Opportunity(
                AccountId = acctId,
                Name = 'TestModeOppty',
                CloseDate = Date.today().addDays(5),
                OwnerId=owner.id,
                Type='New Business',
                StageName='Prospecting',
                Description='testDiscription');
        System.debug(LoggingLevel.Info,'####Count query before opty insert '+Limits.getQueries());
        return oppty;
    }

    //create account
    public static Account createAccount(string recordType){    
        Account account = new Account(
                Name = 'TestAccount',
                RecordTypeId = recordType,     
                Type='Customer',
                BillingCountry = 'USA',
                BillingCity= 'TestCity',
                BillingState= 'TestState',
                BillingPostalCode='050121',
                BillingStreet= 'Teststr',
                ShippingStreet ='testcountry',
                ShippingCity = 'TestCity',
                ShippingState = 'TestState',
                ShippingCountry = 'USA',
                ShippingPostalCode = '0501431',
                Industry='Fund'
            );
        System.debug('account:>>>>'+account);
        return account;
    }    
}