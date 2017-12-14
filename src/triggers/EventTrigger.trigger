trigger EventTrigger on Event ( before insert,before update,before delete,after insert,after update,after delete,after undelete ) {
   Boolean isTriggerDisabled=SFLangUtil.getTriggerSettings(Label.EventApiName);
   if(!isTriggerDisabled)
   {
      EventsDispatcher.run();
   }
}