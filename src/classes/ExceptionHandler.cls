public class ExceptionHandler{
    public static void errorLog(String errMessage, String trace, String className, String methodName, Id id) {
        ErrorLog__c err = new ErrorLog__c();
        err.ID__c = id;
        err.Name = className;
        err.MethodName__c = methodName;
        err.Description__c = errMessage;
        err.StackTrace__c = trace;
        SObjectUnitOfWork.createErrorLog(err);
    }

    @future
    public static void errorLogAsync(String errMessage, String trace, String className, String methodName, Id id) {
        ErrorLog__c err = new ErrorLog__c();
        err.ID__c = id;
        err.Name = className;
        err.MethodName__c = methodName;
        err.Description__c = errMessage;
        err.StackTrace__c = trace;
        SObjectUnitOfWork.createErrorLog(err);

    }

    public static void bulkLeadError( List<Database.LeadConvertResult> erroredLeads,String className,String methodName){
        List<ErrorLog__c> errList = new List<ErrorLog__c>();
        for(Database.LeadConvertResult convertedLead: erroredLeads){
            if(!convertedLead.isSuccess()){
                for (Database.Error error : convertedLead.getErrors()) {
                    ErrorLog__c err = new ErrorLog__c();
                    err.ID__c = convertedLead.getLeadId();
                    err.Name = className;
                    err.MethodName__c = methodName;
                    err.Description__c = error.getMessage();
                    err.StackTrace__c = '';//error.getFields();
                    errList.add(err);
                }
            }
        }
        SObjectUnitOfWork.createBulkErrorLog(errList);

    }

}