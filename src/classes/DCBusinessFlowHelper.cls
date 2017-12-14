/**
 * Created by shravan.boddula on 9/6/2017.
 */

public with sharing class DCBusinessFlowHelper {
    //notify ranking
    public static void notifyForRanking(Lead sourceLead) {
        try {
            if (sourceLead.IsDupe__c == false) {
                sourceLead.ReadyForRanking__c = true;
            }
            //SObjectUnitOfWork.executeUpdateLeads(new List<Lead>{sourceLead});
            update sourceLead;
            
        } catch (Exception ex) {
            ExceptionHandler.errorLog(ex.getMessage(),
                    ex.getStackTraceString(), 'DCBusinessFlowHelper', 'notifyForRanking', '');
        }
    }

}