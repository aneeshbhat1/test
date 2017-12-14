/**************************************************************************************
 Apex Class Name    : TestDataFactory
 Version            : 1.0
 Created Date       : Oct 10 2017
 Function           : Factory class for Creating  TestData.
 Modification Log   : Draft created by Manos
 -----------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * Manos S                  25/10/2017              Original Version
 *************************************************************************************/

@isTest
public class TestDataFactory {
    public static string suffix;

    private static final String EMAIL_SUFFIX = '@ef.com.lang.dev.tst';
    private static final String USERNAME_SUFFIX = '@ef.com.lang.dev.tst';
    private static Integer countUsersCreated = 0; //Use this to avoid duplicate Test User names

    /********************************************************************************************************************************
    *
    * ver 1.0 2017.10.27 Manos Spanoudakis <manos.spanoudakis@ef.com>
    *
    *                    Creates an admin user with 'default' values for required fields
    *
    * @param doInsert true if the method should also insert the object,
    *                 if set to false no DML operations will be executed
    *
    */
    public static User createAdminUser(boolean doInsert) {
        Profile uProfile = getProfile(Label.System_administrator_profile_name, true);
        if (uProfile==null)
            return null;

        User tUser = new User();
        tUser.ProfileId = uProfile.Id;
        tUser.alias = 'admnTU';
        tUser.email = tUser.alias + EMAIL_SUFFIX;
        tUser.emailencodingkey = 'UTF-8';
        tUser.lastname = 'admTU'+system.now();
        tUser.languagelocalekey = 'en_US';
        tUser.localesidkey = 'en_US';
        tUser.timezonesidkey = 'Europe/Berlin';
        tUser.username = 'TestAdmin'+ (countUsersCreated++) + USERNAME_SUFFIX;

        if (doInsert)
            insert tUser;

        system.debug('User:'+tUser);
        return tUser;
    }
    /****************************************************************************************************/
    public static Group getRegularTypeGroupByLabel(string developerName){
    
     Group publicGroup = [select id,name,DeveloperName from Group where type='Regular' and DeveloperName = :developerName LIMIT 1];
     return publicGroup ;
    }
    /*****************************************************************************************************/
    public static user getGroupmemberbyGroup(group publicGroup){
     GroupMember member = [SELECT Id,UserOrGroupId FROM GroupMember WHERE GroupId = :publicGroup.Id LIMIT 1];
            User user = [SELECT Id,Name FROM User WHERE Id = :member.UserOrGroupId LIMIT 1];
            return user;
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*********************************************************************************************************************************/


    /********************************************************************************************************************************
    *
    * ver 1.0 2017.10.27 Manos Spanoudakis <manos.spanoudakis@ef.com>
    *
    *                    Creates a User with the given profile name. If the profile doesn't exist it will not continue and will return null
    *
    * @param strProfileName The required profile name
    * @param doInsert true if the method should also insert the object,
    *                 if set to false no DML operations will be executed
    *
    */
    public static User createUser(String strProfileName, boolean doInsert) {

        Profile uProfile = getProfile(strProfileName,false);
        if (uProfile==null)
            return null;

        User tUser = new User();
        tUser.ProfileId = uProfile.Id;
        tUser.alias = 'TUsr'+countUsersCreated;
        tUser.email = tUser.alias + EMAIL_SUFFIX;
        tUser.emailencodingkey = 'UTF-8';
        tUser.lastname = 'cdtUsr'+system.now();
        tUser.languagelocalekey = 'en_US';
        tUser.localesidkey = 'en_US';
        tUser.timezonesidkey = 'Europe/Berlin';
        tUser.username = 'TestUser'+ (countUsersCreated++) + USERNAME_SUFFIX;

        if (doInsert)
            insert tUser;

        system.debug('User:'+tUser);
        return tUser;
    }
    /*********************************************************************************************************************************/

    /********************************************************************************************************************************
    *
    * ver 1.0 2017.10.27 Manos Spanoudakis <manos.spanoudakis@ef.com>
    *
    *                    Return the profile with the name specified in the input parameter. If the parameter onMisMatchReturnAdmin is set to true it will
    *                    return the default Salesforce system administrator profile (provided it exists !!!)
    *
    * @param strProfileName The required profile name
    * @param onMisMatchReturnAdmin Boolean to return the system administrator profile in case the required profile name is not found
    *
    */
    public static Profile getProfile(String strProfileName, boolean onMisMatchReturnAdmin) {
        profile p = new profile();
        try {
            p = [SELECT Id, Name FROM profile WHERE name like :strProfileName LIMIT 1];
        }
        catch (system.Queryexception exc) {
            if (onMisMatchReturnAdmin)
                p = [SELECT Id, Name FROM profile WHERE name like 'system%administrator' LIMIT 1];
        }

        system.debug('Profile:' +p);

        return  p;
    }
    /*********************************************************************************************************************************/


    /********************************************************************************************************************************
     *
     * ver 1.0 2017.10.27 Manos Spanoudakis <manos.spanoudakis@ef.com>
     *
     *                    Create a Lead with specified parameters
     *
     * @param strFirstName Lead first name
     * @param strLastName Lead last name
     * @param strCompanyName Lead company name HINT:leave empty in case you plan to convert to Person Account
     * @param strRecordTypeId The recordtypeId of the to be created accounts
     * @param doInsert true if the method should also insert the object,
     *                 if set to false no DML operations will be executed
     *
     */
    public static Lead createLead(String strFirstName, String strLastName, String strCompanyName, String strRecordTypeId, boolean doInsert) {
        Lead tLead = new Lead();

        tLead.FirstName = strFirstName;
        tLead.LastName = strLastName;
        tLead.Company = strCompanyName;

        String strEmail = strFirstName  + 'test' + strLastName + EMAIL_SUFFIX ;
        tLead.Email = strEmail.trim().replaceAll(' ', '_');

        if (doInsert)
            insert tLead;
        return tLead;
    }
    /*********************************************************************************************************************************/


    /********************************************************************************************************************************
    *
    * ver 1.0 2017.10.27 Manos Spanoudakis <manos.spanoudakis@ef.com>
    *
    *                    Create an account with specified parameters
    *
    * @param strAccountName Account name
    * @param strRecordTypeId The recordtypeId of the to be created accounts
    * @param doInsert true if the method should also insert the object,
    *                 if set to false no DML operations will be executed
    *
    */
    public static Account createAccount(String strAccountName, String strRecordTypeId,boolean doInsert) {
        Account tAccount = new Account();
        tAccount.name = strAccountName;
        tAccount.RecordTypeId=strRecordTypeId;
        if (doInsert)
            insert tAccount;
        return tAccount;
    }
    /*********************************************************************************************************************************/


    /********************************************************************************************************************************
    *
    * ver 1.0 2017.10.27 Manos Spanoudakis <manos.spanoudakis@ef.com>
    *
    * @param strAccountName Account name
    * @param strRecordTypeId The recordtypeId of the to be created accounts
    * @param mFieldNameToVal a map to specify additional fields during the Account creation. Map Key is the field API name and Map value the respective field value.
    * @param doInsert true if the method should also insert the object,
    *                 if set to false no DML operations will be executed
    *
    */
    public static Account createAccount(String strAccountName,  Map<String, String> mFieldNameToVal,boolean doInsert) {
        Account tAccount = new Account();
        tAccount.name = strAccountName;

        Map<String, Schema.SObjectField> mSobjFields = Schema.SObjectType.Account.fields.getMap();
        if (mFieldNameToVal != null) {
            for (String strFieldName : mFieldNameToVal.keySet()) {
                String strVal = mFieldNameToVal.get(strFieldName);

                //Might require to  do the same for other data types !
                if (mSobjFields.get(strFieldName).getDescribe().getType() == Schema.DisplayType.Date)

                    tAccount.put(strFieldName, Date.valueOf(strVal) );
                else
                    tAccount.put(strFieldName, strVal);
            }
        }

        if (doInsert)
            insert tAccount;
        return tAccount;
    }
    /*********************************************************************************************************************************/


    /********************************************************************************************************************************
    *
    * ver 1.0 2017.09.22 Manos Spanoudakis <manos.spanoudakis@ef.com>
    *
    *                    Creates numAccounts with the given prefix as the name, and the specified recordtypeId
    *
    * @param strAccountName the prefix for the created accounts. Full name would be strAccountName + ' ' + counter
    * @param strRecordTypeId The recordtypeId of the accounts to be created
    * @param numAccounts the number of accounts to be created
    * @param doInsert true if the method should also insert the object,
    *                 if set to false no DML operations will be executed
    *
    */
    public static List<Account> createAccounts(String strAccountName, String strRecordTypeId, Integer numAccounts, boolean doInsert) {

        List<Account> lAccounts = new List<Account>();

        for (Integer i=0;i<numAccounts;i++)
        {
            Account tAccount = createAccount(strAccountName+ ' ' + i,strRecordTypeId,false);
            lAccounts.add(tAccount);
        }

        if (doInsert && lAccounts.size()>0)
            insert lAccounts;
        return lAccounts;
    }
    /*********************************************************************************************************************************/


    /*******************************************************************************************************************************
    *
    * ver 1.0 2017.10.27 Manos Spanoudakis <manos.spanoudakis@ef.com>
    *
    *                    Create a Business Account with a Contact. Returns the created Account
    *
    * @param strAccountName The name of the Account
    * @param strAccountRecordTypeId the record type of the Account
    * @param strContactFirstName the first name of the contact
    * @param strContactLastName the last name of the contact
    * @param strContactRecordTypeId the record type id of the contact
    *
    */
    public static Account createAccountWithContact(String strAccountName, String strAccountRecordTypeId, String strContactFirstName, String strContactLastName, String strContactRecordTypeId) {
        Account tAccount = createAccount(strAccountName,strAccountRecordTypeId,true);
        Contact tContact = new Contact();
        insert tContact;
        return tAccount;

    }
    /*********************************************************************************************************************************/


    /*******************************************************************************************************************************
    *
    * ver 1.0 2017.10.27 Manos Spanoudakis <manos.spanoudakis@ef.com>
    *
    *                    Create  Accounts with Opportunities. Returns the Accounts created
    *
    * @param numAccounts The number of Accounts to create
    * @param strAccountNamePrefix the Prefix of the account name. The final name will be Prefix + Iterator
    * @param mAccountFieldNameToVal a map to specify additional fields during the Account creation. Map Key is the field API name and Map value the respective field value.
    * @param numOppsPerAccount The number of Opportunities per Account to create
    * @param strOppNamePrefix the Prefix of the Opportunity name. The final name will be Prefix + '-' + Account.Name + Iterator
    * @param mOppFieldNameToVal a map to specify additional fields during the Opportunity creation. Map Key is the field API name and Map value the respective field value.
    *
    */
    public static List<Account> createAccountsWithOpportunities(Integer numAccounts, String strAccountNamePrefix, Map<String,String> mAccountFieldNameToVal,
                                                                Integer numOppsPerAccount, String strOppNamePrefix, Map<String,String> mOppFieldNameToVal)
    {

        List<Account> tAccounts = new List<Account>();
        for(Integer i=0;i<numAccounts;i++) {
            Account tAccount = createAccount(strAccountNamePrefix + ' ' + i,  mAccountFieldNameToVal,true);
            tAccounts.add(tAccount);
        }
        if (tAccounts.size()>0)
            insert tAccounts;


        List<Opportunity> tOpps = new List<Opportunity>();

        for (Integer j=0;j<numAccounts;j++) {
            Account tAccount = tAccounts[j];
            // For each account just inserted, add opportunities
            for (Integer k=0;k<numOppsPerAccount;k++) {
                Opportunity tOpp = createOpportunityForAccount(tAccount.Id,strOppNamePrefix + ' - ' + tAccount.name + ' ' + k ,mOppFieldNameToVal, false);
                tOpps.add(tOpp);
            }
        }
        // Insert all opportunities for all accounts.

        if(tOpps.size()>0)
            insert tOpps;

        return tAccounts;
    }
    /*********************************************************************************************************************************/


    /*******************************************************************************************************************************
    *
    * ver 1.0 2017.10.27 Manos Spanoudakis <manos.spanoudakis@ef.com>
    *
    *                    Creates an Opportunity with specified parameters for the Account strAccountId
    *
    * @param strAccountId The related Account Id
    * @param strOpportunityName the Opportunity name    
    * @param mFieldNameToVal a map to specify additional fields during the Opportunity creation. Map Key is the field API name and Map value the respective field value.
    * @param doInsert true if the method should also insert the object,
    *                 if set to false no DML operations will be executed
    */
    public static Opportunity createOpportunityForAccount(String strAccountId,String strOpportunityName, Map<String, String> mFieldNameToVal, boolean doInsert ) {
        Opportunity tOpp = new Opportunity();
        tOpp.name = strOpportunityName;
        tOpp.AccountId= strAccountId;

        Map<String, Schema.SObjectField> mSobjFields = Schema.SObjectType.Opportunity.fields.getMap();

        if (mFieldNameToVal != null) {
            for (String strFieldName : mFieldNameToVal.keySet()) {
                String strVal = mFieldNameToVal.get(strFieldName);

                //Might require to  do the same for other data types !
                if (mSobjFields.get(strFieldName).getDescribe().getType() == Schema.DisplayType.Date)

                    tOpp.put(strFieldName, Date.valueOf(strVal) );
                else
                    tOpp.put(strFieldName, strVal);
            }
        }
        if (doInsert)
            insert tOpp;
        return tOpp;
    }
    /*********************************************************************************************************************************/


    /********************************************************************************************************************************
    *
    * ver 1.0 2017.10.31 Manos Spanoudakis <manos.spanoudakis@ef.com>
    *
    *                    Create a Campaign with specified parameters
    *
    * @param strCampaignName Account name
    * @param strRecordTypeId The recordtypeId of the to be created accounts
    * @param doInsert true if the method should also insert the object,
    *                 if set to false no DML operations will be executed
    *
    */
    public static Campaign createCampaign(String strCampaignName, String strRecordTypeId,boolean doInsert) {
        Campaign tCampaign = new Campaign();
        tCampaign.name = strCampaignName;
        tCampaign.RecordTypeId=strRecordTypeId;
        tCampaign.isActive = true;
        tCampaign.dateFrom__c = Date.today().addDays(5);
        tCampaign.dateTo__c = tCampaign.dateFrom__c.addHours(1);
        if (doInsert)
            insert tCampaign;
        return tCampaign;
    }
    /*********************************************************************************************************************************/

    /********************************************************************************************************************************
    *
    * ver 1.0 2017.10.31 Manos Spanoudakis <manos.spanoudakis@ef.com>
    *
    *                    Create a Campaign with specified parameters
    *
    * @param strCampaignName Account name
    * @param mFieldNameToVal a map to specify additional fields during the Campaign creation. Map Key is the field API name and Map value the respective field value.
    * @param doInsert true if the method should also insert the object,
    *                 if set to false no DML operations will be executed
    *
    */
    public static Campaign createCampaign(String strCampaignName, Map<String, String> mFieldNameToVal,boolean doInsert) {
        Campaign tCampaign = new Campaign();
        tCampaign.name = strCampaignName;

        Map<String, Schema.SObjectField> mSobjFields = Schema.SObjectType.Campaign.fields.getMap();

        if (mFieldNameToVal != null) {
            for (String strFieldName : mFieldNameToVal.keySet()) {
                String strVal = mFieldNameToVal.get(strFieldName);

                //Might require to  do the same for other data types !
                if (mSobjFields.get(strFieldName).getDescribe().getType() == Schema.DisplayType.Date)

                    tCampaign.put(strFieldName, Date.valueOf(strVal)); else
                        tCampaign.put(strFieldName, strVal);
            }
        }
        if (doInsert)
            insert tCampaign;
        return tCampaign;
    }
    /*********************************************************************************************************************************/


    /********************************************************************************************************************************
    *
    * ver 1.0 2017.10.31 Manos Spanoudakis <manos.spanoudakis@ef.com>
    *
    *                    Create a Campaign with specified parameters
    *
    * @param strCampaignId Related Campaign Id
    * @param lPersonAccountsToAdd The list of Person Accounts to be added as Campaign Members
    * @param strCampaignMemberStatus The campaign member status
    * @param doInsert true if the method should also insert the Campaign Members,
    *                                if set to false no DML operations will be executed
    *
    */
    public static List<CampaignMember> createCampaignMembersForCampaign(String strCampaignId,
                                                                        List<Account> lPersonAccountsToAdd,
                                                                        String strCampaignMemberStatus,
                                                                        boolean doInsert) {
        List<CampaignMember> lCampaignMembers = new List<CampaignMember>();

        if (lPersonAccountsToAdd.size()>0) {
            for (Integer i = 0; i<lPersonAccountsToAdd.size(); i++) {
                CampaignMember tCampaignMember = new CampaignMember();
                tCampaignMember.CampaignId = strCampaignId;
                tCampaignMember.contactId = lPersonAccountsToAdd[i].personContactId;
                tCampaignMember.Status = strCampaignMemberStatus;
                lCampaignMembers.add(tCampaignMember);
            }
        }

        if (doInsert &&  lCampaignMembers.size() >0)
            insert lCampaignMembers;
        return lCampaignMembers;
    }

    /*
    * ver 1.0 07-dec-2017
    * @author Arkadiusz Celej
    *
    * Method creates and returns task record.
    *
    * @param opportunityId Task parent ID
    * @param taskRecordTypeId Task RecordTypeId
    * @param subject Subject
    * @param taskType Type of task
    * @param toInsert To insert or to not Insert
    * */
    public static Task createTaskForOpportunity(Id opportunityId, Map<String, String> mFieldNameToVal, Boolean toInsert){
        Task tTask = new Task(WhatId = opportunityId);
        Map<String, Schema.SObjectField> mSobjFields = Schema.SObjectType.Task.fields.getMap();

        if (mFieldNameToVal != null) {
            for (String strFieldName : mFieldNameToVal.keySet()) {
                String strVal = mFieldNameToVal.get(strFieldName);
                if (mSobjFields.get(strFieldName).getDescribe().getType() == Schema.DisplayType.Date)
                    tTask.put(strFieldName, Date.valueOf(strVal) );
                else
                    tTask.put(strFieldName, strVal);
            }
        }
        if(toInsert){
            insert tTask;
        }
        return tTask;
    }

    /*** METHODS FOR CREATING CUSTOM SETTINGS GO HERE ****/



    /*****   ***/


}