global class dcJobCleanUp implements Schedulable{
 global void execute(SchedulableContext sc) {
 //  Instantiate batch class  
   List<dupcheck__dcJob__c> jobList = [SELECT Id,dupcheck__status__c  FROM dupcheck__dcJob__c where dupcheck__duplicateCount__c =0 AND (dupcheck__status__c ='Aborted' OR dupcheck__status__c ='Completed')];
   Set<Id> jobIdSet = new Set<Id>(); 
   for (dupcheck__dcJob__c j : jobList) {
   jobIdSet.add(j.Id);
   }
  // delete jobList ;
   database.executeBatch(new dupcheck.dc3SearchBatchDelete(jobIdSet,'DUPLICATE'), 2000);
  /* String cronStr = '0 0,30 * * * *';
   System.schedule('Process Accs Job', cronStr, new dcJobCleanUp());
   String cronStr1 = '0 0 * * * ?';
    System.schedule('Process Accs Job1', cronStr1, new dcJobCleanUp());*/
    }
       }