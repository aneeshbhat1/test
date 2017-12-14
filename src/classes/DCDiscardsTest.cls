/******************************************************************************
Apex Class Name    : DCDiscardsTest
Version            : 1.0
Created Date       : 7/7/2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * shravan.boddula                  7/7/2017              Original Version
*******************************************************************************/
@isTest
public class DCDiscardsTest {
    static testmethod void leadDiscardTest() {
        system.runAs(TestDataUtil.createUserRecord()) {
            List<Lead> leadList = TestdataUtil.createLeadList(4);
            insert leadList;
            dupcheck__dcDiscard__c dupcheckDiscard = createDupcheckDiscard(leadList[0].id,leadList[1].id);
            insert dupcheckDiscard;
        }
    }


    public static dupcheck__dcDiscard__c createDupcheckDiscard(String objectA,String objectB) {
        dupcheck__dcDiscard__c dupcheckdiscard = new dupcheck__dcDiscard__c();
        dupcheckdiscard.dupcheck__objectA__c =objectA;
        dupcheckdiscard.dupcheck__objectB__c = objectA;
        dupcheckdiscard.dupcheck__Relation__c='Duplicate';
        dupcheckdiscard.dupcheck__recordA__c=objectA;
        dupcheckdiscard.dupcheck__recordB__c=objectB;
        return dupcheckdiscard;
    }
}