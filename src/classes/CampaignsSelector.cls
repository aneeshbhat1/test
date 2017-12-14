public class CampaignsSelector{     

    public static Campaign getCampaigns(id campaignId)
    {
        return [select id,name,Market__c,IsUP__c,Product__c,DateFrom__c,DateTo__c,MeetingSize__c,Address__c,
                SendtoEFCOM__c,Description,SalesOffice__c,Program__c,MeetingType__c,Status,MeetingCity__c,EFCOMMarket__c
                from campaign where id=:campaignId];
    }
    
    public static List<Campaign> getCampaignRecords(){
          return [SELECT Program__c, MeetingCity__c, MeetingType__c, DateFrom__c, DateTo__c, IsUP__c, MeetingSize__c FROM Campaign where status = 'Active' and DateFrom__c >= Today];
    }

    public static   Map<Id, Integer> getCampaignMembers(List<campaign> campaignRecords ){
        List<Campaign> newCampaigns=new List<Campaign>();
        newCampaigns=[select id,(select id from campaignmembers where status='Invited' or status ='Sent') from campaign where id in :campaignRecords];
        Map<Id, Integer> invitedCount= new  Map<Id,Integer>();

        for(campaign campaignMembers:  newCampaigns)
        {
            invitedCount.put(campaignMembers.id,campaignMembers.campaignmembers.size());
        }
     return invitedCount;

    }

}