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
public class LeadsSelector{

    Public static List<LeadShare> getLeadShareRecDetails(Map<Id,ID> leadShareDeleteMap){
        return [select Id from leadShare where UserOrGroupId IN:leadShareDeleteMap.values()
        AND leadId IN:leadShareDeleteMap.keyset()];
    }

    public static lead getSourceLead(lead sourceLead) {
        //return [select id,firstname,street,LastName, DOB__c,City,PostalCode,Region__c,Email,Email2__c,phone,MobilePhone,OtherPhone__c,TritonId__c from lead where id = :sourceLead.id limit 1];
        return [select id,FirstName,street,state,LastName,City,PostalCode,phone,MobilePhone,OtherPhone__c,
                DOB__c,Email,Email2__c,RequestType__c,Program__c,CreationType__c,
                Market__c,InsertTime__c,ActivityDateTime__c,Region__c,IsDupeProcessed__c,IsDupe__c,
                ReadyForRanking__c,Ranking__c,TritonId__c from Lead where id = :sourceLead.id limit 1];
    }
    public static List<Lead> leadListDetails(List<Id> leadIdList) {
        return [Select id, IsDupe__c,ReadyforRanking__c from Lead Where id in :leadIdList];
    }

    public static List<Lead> getLeads(List<Lead> leads) {
        return [
                select id, FirstName,LastName,City,product__c,PostalCode,phone,MobilePhone,
                        OtherPhone__c,DoubleOptIn__c,DOB__c,Email,Email2__c,street,market__c,salesoffice__c,
                        RequestType__c,Program__c,InsertTime__c,ActivityDateTime__c,Region__c,
                        IsDupeProcessed__c,IsDupe__c,ReadyForRanking__c,Ranking__c
                from Lead
                where Id IN:leads
        ];
    }

    public static List<Lead> getLeadsWithReservations(List<Lead> leads) {
        return [
                select id, FirstName, LastName,City,PostalCode,phone,MobilePhone,OtherPhone__c,
                        DOB__c,street,Email,Email2__c,CreationType__c,
                        RequestType__c,Program__c,Market__c,InsertTime__c,ActivityDateTime__c,Region__c,
                        IsDupeProcessed__c,IsDupe__c,ReadyForRanking__c,Ranking__c
                from Lead
                where Id IN:leads and RequestType__c = 'RES'
                ORDER BY ActivityDateTime__c];
    }

   public static List<Lead> getLeadOnId(Set<Id> leadID)
    {
        List<Lead> leadList = [select RequestType__c, ActivityDateTime__c, City, DOB__c, DoubleOptIn__c, Email, Email2__c, FirstName,
                 id, InsertTime__c, IsConverted, IsDupe__c, IsDupeProcessed__c,CreationType__c,
                LastName, market__c, MobilePhone, OtherPhone__c, Phone, PostalCode, product__c,CreationMethod__c,
                Program__c, Ranking__c, ReadyForRanking__c, Region__c, state, salesoffice__c, street from Lead  where Id in :leadId];

        return leadList;
    }
    
    public static Lead getLeadOnId(Id leadID)
    {
        lead leadList = new lead();
        if(leadId!=null){
            leadList = [select
                    id, FirstName,street,state,LastName,City,PostalCode,phone,product__c,
                    MobilePhone,OtherPhone__c,DoubleOptIn__c,DOB__c,Email,Email2__c,CreationType__c,
                    RequestType__c,Program__c,Market__c,InsertTime__c,ActivityDateTime__c,ownerId,
                    Region__c,IsDupeProcessed__c,IsDupe__c,ReadyForRanking__c,IsConverted,
                    Ranking__c,TritonId__c from Lead  where Id=:leadId];
        }
        return leadList;
    }


    public static List<Lead> getSortedLeadsOnActivityDate(List<Lead> leads) {
        return [
                select
                        id,FirstName,street,state,LastName,City,PostalCode,phone,MobilePhone,OtherPhone__c,
                        DOB__c,Email,Email2__c,RequestType__c,TritonId__c,CreationType__c,
                        Program__c,Market__c,InsertTime__c,ActivityDateTime__c,Region__c,IsDupeProcessed__c,
                        IsDupe__c,ReadyForRanking__c,Ranking__c
                from Lead where Id IN:leads ORDER BY ActivityDateTime__c desc
        ];
    }


    public static Map<Id,Lead> leadRecordMap(List<Id> leadIdList) {
        Map<Id,Lead> leadMap = new Map<Id,Lead>(
        [select
                id, FirstName,street,state,LastName,City,PostalCode,phone,
                MobilePhone,OtherPhone__c,DoubleOptIn__c,DOB__c,Email,Email2__c,Product__c,
                RequestType__c,Program__c,Market__c,InsertTime__c,ActivityDateTime__c,
                Region__c,IsDupeProcessed__c,IsDupe__c,ReadyForRanking__c,CreationType__c,DoNotCall,
                Ranking__c,
                ConvertedAccountId,ConvertedOpportunityId 
        from Lead  where Id in :leadIdList ORDER BY ActivityDateTime__c DESC]);
        return leadMap;
    }


    public static Map<Id,Lead> selectLeadById( List<Id> leadIdList) {
        Map<Id,Lead> leadMap = new Map<Id,Lead>([select Id from Lead where
        IsConverted = false and Id in :leadIdList]);
        return leadMap;
    }
    public static List<User> getLeaduserDetails(set<id> leadOwnerids)
    {
        List<User> userList=[select id,MarketsEnabled__c from user where id in :leadOwnerids];
        return userList;
    }
    public static List<Lead> getAllEventsAndTasksforLead(List<id> leadids)
    {
        return [select id,(Select id,FalseBrochureProgramCodes__c,Type from tasks),(Select id from events) from lead where id in : leadids];
    }
    public static List <Lead> getLeadRecordOnId(Id leadID)
    {
        List<Lead> leadList = new List<Lead>();
        if(leadId!=null){
            leadList = [select
                    id, FirstName,street,state,LastName,City,PostalCode,phone,product__c,
                    MobilePhone,OtherPhone__c,DoubleOptIn__c,DOB__c,Email,Email2__c,CreationType__c,
                    RequestType__c,Program__c,Market__c,InsertTime__c,CreationMethod__c,ActivityDateTime__c,ownerId,
                    Region__c,IsDupeProcessed__c,IsDupe__c,ReadyForRanking__c,IsConverted,
                    Ranking__c,TritonId__c from Lead  where Id=:leadId];
        }
        return leadList;
    }
}