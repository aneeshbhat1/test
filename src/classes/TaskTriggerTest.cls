/**
 * Created by Arkadiusz Celej on 08-dec-2017.
 */

@IsTest
private class TaskTriggerTest {

    private static String PRODUCT = 'ILS';
    private static String PROGRAM_ILSU = 'ILSU';
    private static String PROGRAM_ILSH = 'ILSH';
    private static String PROGRAM_ILSP = 'ILSP';
    private static String TASK_STATUS_COMPLETED = 'Completed';

    static testMethod void shouldUpdateTaskOpportunityFieldBrochuresToSend() {
        //given
        TestDataUtil.OpportunityBuilder opportunityBuilder = new TestDataUtil.OpportunityBuilder();
        Opportunity opp = (Opportunity)opportunityBuilder.withPersonAccount().save().getRecord();

        Map<String, String> taskFields = new Map<String, String>();
        Task t = TestDataUtil.createTaskForOpportunity(opp.Id, taskFields, false);
        t.RecordTypeId = RecordTypeSelector.getRecTypesByDevName(Task.SObjectType).get(TasksHelper.SBR_TASK_DEVELOPER_NAME).Id;
        t.Product__c = PRODUCT;
        t.Program__c = PROGRAM_ILSU;
        insert t;

        t = TestDataUtil.createTaskForOpportunity(opp.Id, taskFields, false);
        t.RecordTypeId = RecordTypeSelector.getRecTypesByDevName(Task.SObjectType).get(TasksHelper.SBR_TASK_DEVELOPER_NAME).Id;
        t.Product__c = PRODUCT;
        t.Program__c = PROGRAM_ILSH;
        t.FalseBrochureProgramCodes__c = 'ILSP';

        //when
        Test.startTest();
        insert t;
        Test.stopTest();
        //then
        Id[] oppId = new List<Id>();
        oppId.add(opp.Id);
        opp = OpportunitiesSelector.getOpportunitiesWithTasksByIdAndTaskRecordType(oppId, new Set<String>{TasksHelper.SBR_TASK_DEVELOPER_NAME})[0];

        System.assertEquals(true, opp.BrochuresToSend__c.contains(PROGRAM_ILSH) && opp.BrochuresToSend__c.contains(PROGRAM_ILSU));
    }

    static testMethod void shouldUpdateTaskOpportunityFieldSendBrochures() {
        //given
        TestDataUtil.OpportunityBuilder opportunityBuilder = new TestDataUtil.OpportunityBuilder();
        Opportunity opp = (Opportunity)opportunityBuilder.withPersonAccount().save().getRecord();
        Map<String, String> taskFields = new Map<String, String>();
        Task t = TestDataUtil.createTaskForOpportunity(opp.Id, taskFields, false);
        t.RecordTypeId = RecordTypeSelector.getRecTypesByDevName(Task.SObjectType).get(TasksHelper.SBR_TASK_DEVELOPER_NAME).Id;
        t.Product__c = PRODUCT;
        t.Program__c = PROGRAM_ILSU;
        t.FalseBrochureProgramCodes__c = PROGRAM_ILSP;
        t.Status = TASK_STATUS_COMPLETED;
        t.TaskResult__c = TasksHelper.SENT_BROCHURE;
        insert t;

        t = TestDataUtil.createTaskForOpportunity(opp.Id, taskFields, false);
        t.RecordTypeId = RecordTypeSelector.getRecTypesByDevName(Task.SObjectType).get(TasksHelper.SBR_TASK_DEVELOPER_NAME).Id;
        t.Product__c = PRODUCT;
        t.Program__c = PROGRAM_ILSH;
        t.TaskResult__c = TasksHelper.DO_NOT_SEND_BROCHURE;
        t.Status = TASK_STATUS_COMPLETED;
        //when
        Test.startTest();
        insert t;
        Test.stopTest();
        //then
        Id[] oppId = new List<Id>();
        oppId.add(opp.Id);
        opp = OpportunitiesSelector.getOpportunitiesWithTasksByIdAndTaskRecordType(oppId, new Set<String>{TasksHelper.SBR_TASK_DEVELOPER_NAME})[0];

        System.assertEquals(true, opp.SentBrochures__c.contains(PROGRAM_ILSU) && opp.SentBrochures__c.contains(PROGRAM_ILSP));
    }
}