/**
 * Created by shravan.boddula on 7/17/2017.
 */
@isTest
public with sharing class DCJobTest {

    static testmethod void leadJob() {
        system.runAs(TestDataUtil.createUserRecord()) {
            List<Lead> leadList = TestdataUtil.createLeadList(4);
            insert leadList;
            dupcheck__dcJob__c dupCheckJob = TestDataUtil.createDupCheck(leadList[0]);
            insert dupCheckJob;
            dupcheck__dcGroup__c dcGroup = TestDataUtil.createdcGroup(dupCheckJob);
            insert dcGroup;
            dupcheck__dcJob__c dupCheckJobNew = TestDataUtil.createDupCheck(leadList[1]);
            insert dupCheckJobNew;
            dupcheck__dc3Duplicate__c dc3duplicate = TestDataUtil.createdc3Duplicate(dupCheckJobNew,leadList[1],
            dcGroup);
            insert dc3duplicate;
            update dupCheckJOb;
        }
    }

    static testmethod void leadDupJob() {
        system.runAs(TestDataUtil.createUserRecord()) {
            List<Lead> leadList = TestdataUtil.createLeadList(4);
            insert leadList;
            dupcheck__dcJob__c dupCheckJob = TestDataUtil.createDupCheck(leadList[0]);
            insert dupCheckJob;
            dupcheck__dcGroup__c dcGroup = TestDataUtil.createdcGroup(dupCheckJob);
            insert dcGroup;
            dupcheck__dcJob__c dupCheckJobNew = TestDataUtil.createDupCheck(leadList[1]);
            insert dupCheckJobNew;
            dupcheck__dc3Duplicate__c dc3duplicate = TestDataUtil.createdc3Duplicate(dupCheckJobNew,leadList[1],
                    dcGroup);
            insert dc3duplicate;
            update dupCheckJOb;
        }
    }
}