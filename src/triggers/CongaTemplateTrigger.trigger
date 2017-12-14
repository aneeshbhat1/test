trigger CongaTemplateTrigger on APXTConga4__Conga_Template__c (before insert,before update,before delete,after insert,after update,after delete,after undelete) {
    Boolean isTriggerDisabled=SFLangUtil.getTriggerSettings(Label.CongaTemplateApiName);
    if(!isTriggerDisabled)
    {
        CongaTemplatesDispatcher.run();
    }
}