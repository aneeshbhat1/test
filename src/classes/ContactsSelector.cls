/**************************************************************************************
Apex Class Name    : ContactsSelector
Version            : 1.0
Created Date       : July 16 2017
Function           :
Modification Log   :
------------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------
 * shravan.boddula                 07/12/2017              Original Version
*******************************************************************************/

public class ContactsSelector {

    public static List<Contact> GetContactsOnAccountId(Id accId) {
        return [select Id from Contact where AccountId = :accId order by createddate desc];
    }

    public static List<Contact> getContactsAndTask_Optm(Set<Id> accId) {
        return [select id,(select id,whoid,WhatId,Type from Tasks order by createdDate) from contact where accountid in :accId];
    }
}