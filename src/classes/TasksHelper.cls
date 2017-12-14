public class TasksHelper {

    private static final String SEPARATOR = ';';
    @testvisible private static final String SBR_TASK_DEVELOPER_NAME = 'SBRTask';
    @testvisible private static final String MCR_TASK_DEVELOPER_NAME = 'MCRTask';
    @testvisible private static final String SPQ_TASK_DEVELOPER_NAME = 'SPQTask';
    @testvisible private static final String DO_NOT_SEND_BROCHURE = 'Will not Send Brochure';
    @testvisible private static final String SENT_BROCHURE = 'Sent Brochure';

    public enum CustomerActivities {
        BR, PQ, BKN, CNT, CALL, EXPRESS_CALL, CAM, CAM_BR
    }
    public enum SalesTasks {
        TCC, UCC, FUP, FUA, SPQ, SBR, MCR, PTS, CLOSEDCALL, OPENCALL, Call
    }

    public enum SObjectName {
        LEAD, OPPORTUNITY, TASK, ACCOUNT
    }

    public enum TaskActivityType {
        CUSTOMERREQUEST, TASK
    }

    public enum SaveType {
        INSERTDATA, UPDATEDATA, CLOSEDINSERT
    }
    public static Opportunity oppRecord;
    public static Lead leadrecord;
    public static Event eventRecord;

    public static Map<String,Task> tasksForActivitiesList = new Map<String,Task>();
    public static Id eventId;
    public static Map<String, TaskSetting__mdt> taskSettingsMap = MetaDataSelector.getTaskSettingMetada();
    public static Set<String> allReachedItems = new Set<String>{Label.CallReached.toUpperCase(),Label.CalledUs.toUpperCase(),Label.VisitedUs.toUpperCase(),Label.EmailedUs.toUpperCase(),Label.SocialMediaReached.toUpperCase()};
    public static Set<String> allNotReachedItems = new Set<String>{Label.CallNotReached.toUpperCase(),Label.SentEmail.toUpperCase(),Label.SocialMediaSent.toUpperCase()};

    public static void convertActivitiesToTask(List<Id> parentIdList)
    {
        Id parentId;
        Map<Id, List<Task>> currentTaskMap =new Map<Id, List<Task>>();
        Map<Id, List<Event>> activityMap =new Map<Id, List<Event>>();
        Map<Id, Opportunity> parentOpportunityMap=new Map<Id, Opportunity> ();
        List<Event> eventsToUpdateList = new List<Event>();
        if (parentIdList.size() > 0) {
            for (Opportunity opportunityRecords : OpportunitiesSelector.getAllEventsAndTasksforOpportunity(parentIdList)) {
                currentTaskMap.put(opportunityRecords.id, opportunityRecords.tasks);
                activityMap.put(opportunityRecords.id,opportunityRecords.events);
                parentOpportunityMap.put(opportunityRecords.id,opportunityRecords);
            }

            //Here we will get mix of LEAD and opportunity records
            //Here we are getting all the activities for parent
            //activityMap = EventsSelector.getAllActivities(parentIdList);           
            //taskSettingsMap = getTaskSettings();
            //Here we are getting all the tasks for parent

            //########Commented by suresh..why u need this ???*********
            //currentTaskMap = TasksSelector.getAllTasksForparent(parentIdList) ;

            try {
                for(Id parentIds: activityMap.keySet())
                {
                    for (Event parentActivity : activityMap.get(parentIds)) {
                        eventRecord=parentActivity;
                        eventId = parentActivity.Id;
                        //Here we are processing record by record for parent object(LEAD/OPPORTUNITY
                        //parentId = parentActivity.whatId != null ? parentActivity.whatId : parentActivity.WhoId;

                        Map<String, List<Task>> filterTaskTypeForParentMap = new Map<String,List<Task>>();
                        //leadrecord = parentLeadMap.containsKey(parentId) ? parentLeadMap.get(parentId) : null;
                        oppRecord = parentOpportunityMap.containsKey(parentIds) ? parentOpportunityMap.get(parentIds) : null;

                        //Filter tasks based on task type
                        if (currentTaskMap.containsKey(parentIds))
                            filterTaskTypeForParentMap = filterTaskTypeTaskForparent(currentTaskMap.get(parentIds), parentActivity.Program__c);

                        //Here we are collecting all the tasks which are to be saved(Insert/Update)
                        tasksForActivitiesList.putAll(saveActivityDataToTask(filterTaskTypeForParentMap, parentActivity));
                        parentActivity.ProcessedforTaskcreation__c = true;
                        eventsToUpdateList.add(parentActivity);

                    }}
                if (tasksForActivitiesList.size() > 0) {
                    system.debug('tasksForActivitiesListsize>>>>>'+tasksForActivitiesList.size());
                    SObjectUnitOfWork.saveTasks(tasksForActivitiesList.values());
                    system.debug('tasksForActivitiesList>>>>>1'+tasksForActivitiesList.values()[0].id);
                    system.debug('tasksForActivitiesList>>>>2>'+tasksForActivitiesList.values()[1].id);
                    //Here we are Marking Field on Events as ProcessedforTaskcreation__c=true;
                    SObjectUnitOfWork.modifyEvents(eventsToUpdateList);
                }
            } catch (exception ex) {
                ExceptionHandler.errorLog(ex.getMessage(), ex.getStackTraceString(),
                        'Tasks', 'convertActivitiesToTask', eventId);
            }

        }

    }

    //Filter Tasks Types for parent using Map Ex:(SBR,List<3 SBR Tasks>)

    //Get the MetaData Values from Metadata Types
    public static Map<String, TaskSetting__mdt> getTaskSettings()
    {
        return MetaDataSelector.getTaskSettingMetada();
    }

    //Filter Tasks Types for parent using Map Ex:(SBR,List<3 SBR Tasks>)
    public static Map<String, List<Task>> filterTaskTypeTaskForparent(List<Task> currentParentTaskList,
            String CurrentProgram)
    {
        Map<String, List<Task>> currentParentTaskMap = new Map<String, List<Task>>();


        List<Task> brochureRequestTaskList = new List<Task>();
        List<Task> priceQuoteTaskList = new List<Task>();
        List<Task> taskClosedList = new List<Task>();
        List<Task> taskOpenList = new List<Task>();
        for (Task parentTask:currentParentTaskList) {

            if ((parentTask.Type ==SalesTasks.Call.name()
                    || parentTask.Type == SalesTasks.FUA.name()
                    || parentTask.Type == SalesTasks.FUP.name()
                    || parentTask.Type == SalesTasks.UCC.name())) {

                if (parentTask.IsClosed__c)
                    taskClosedList.add(parentTask); else
                        taskOpenList.add(parentTask);


            } else if (parentTask.Type == SalesTasks.SBR.name() && CurrentProgram == parentTask.Program__c) {
                brochureRequestTaskList.add(parentTask);
            } else if (parentTask.Type == SalesTasks.SPQ.name()) {
                priceQuoteTaskList.add(parentTask);
            }


        }
        if (taskClosedList.size() > 0) {
            currentParentTaskMap.put(SalesTasks.CLOSEDCALL.name(), taskClosedList);
        }
        if (taskOpenList.size() > 0) {

            currentParentTaskMap.put(SalesTasks.OPENCALL.name(), taskOpenList);
        }
        if (brochureRequestTaskList.size() > 0) {
            currentParentTaskMap.put(SalesTasks.SBR.name(), brochureRequestTaskList);
        }
        if (priceQuoteTaskList.size() > 0) {
            currentParentTaskMap.put(SalesTasks.SPQ.name(), priceQuoteTaskList);
        }
        return currentParentTaskMap;
    }

    //This will return an List to upsert based on rules and condition
    public static Map<String,Task> saveActivityDataToTask(
            Map<String, List<Task>> currentTasksOfParentMap,
            Event parentActivity)
    {
        Map<String,Task> upsertTasksRecordList = new Map<String,Task>();
        if (taskSettingsMap.containsKey(parentActivity.Type)) {

            TaskSetting__mdt objCurrentType = taskSettingsMap.get(parentActivity.Type);
            Map<String, String[]> saveTypeMap = returnTaskToSave(objCurrentType);
            upsertTasksRecordList = finalTaskListToSave
                    (saveTypeMap,
                            currentTasksOfParentMap,
                            parentActivity, null);
        }
        return upsertTasksRecordList;
    }

    //Here we get array of task types to save for perticular request(Event/Task)
    public static Map<String, String[]> returnTaskToSave(TaskSetting__mdt objCurrentType)
    {
        Map<String, String[]> callTypeMap = new Map<String, String[]>();
        String taskSettingsValues = '';
        if (!String.isBlank(objCurrentType.CreateCallType__c)) {
            taskSettingsValues = objCurrentType.CreateCallType__c;
            //Add is Active Condition
            String[] createCallTypeArray = SFLangUtil.splitString(taskSettingsValues, '|');
            callTypeMap.put(SaveType.INSERTDATA.name(), createCallTypeArray);
        }
        if (!String.isBlank(objCurrentType.UpdateCallType__c)) {
            taskSettingsValues = objCurrentType.UpdateCallType__c;
            String[] updateCallTypeArray = SFLangUtil.splitString(taskSettingsValues, '|');
            callTypeMap.put(SaveType.UPDATEDATA.name(), updateCallTypeArray);
        }
        if (!String.isBlank(objCurrentType.ForClosedCallTypes__c)) {
            taskSettingsValues = objCurrentType.ForClosedCallTypes__c;
            String[] closedCallTypeArray = SFLangUtil.splitString(taskSettingsValues, '|');
            callTypeMap.put(SaveType.CLOSEDINSERT.name(), closedCallTypeArray);
        }
        return callTypeMap;
    }

    //This Method returns list to tasks to be saved for perticular request
    public static Map<String,Task> finalTaskListToSave(Map<String, String[]> typeToSave,
            Map<String, List<Task>> currentParentTaskMap,
            Event requestEventObject, Task requestTaskObj)
    {

        Boolean isClosedOpportunity = true;
        String currentRequestProgram = requestEventObject != null ? requestEventObject.Program__c : requestTaskObj.Program__c;

        Map<String,Task> taskList = new Map<String,Task>();
        if (typeToSave.containsKey(SaveType.INSERTDATA.name())) {
            String[] insertTypeCalls = typeToSave.get(SaveType.INSERTDATA.name());
            Boolean hasCallTask = false;
            Boolean canCreateTask = false;
            Task newTask = new Task();

            for (String typeOfTask:insertTypeCalls) {
                if (taskSettingsMap.containsKey(typeOfTask.trim())) {
                    TaskSetting__mdt objTaskSettingMap = taskSettingsMap.get(typeOfTask);
                    system.debug(' typeOfTask>>>'+ typeOfTask);
                    if (objTaskSettingMap.IsTaskPerCustomer__c) {
                        if (currentParentTaskMap != null
                                && currentParentTaskMap.size() > 0
                                && currentParentTaskMap.containsKey(SalesTasks.OPENCALL.name())
                                && typeOfTask != SalesTasks.MCR.name())
                        {
                            //as this will be call type we will
                            //  get only one call type task per customer
                            system.debug(' pint1>>>');
                            hasCallTask = true;
                            isClosedOpportunity = false;
                        }
                        else if (currentParentTaskMap != null
                                && currentParentTaskMap.size() > 0
                                && !currentParentTaskMap.containsKey(SalesTasks.MCR.name())
                                ) {

                            hasCallTask = false;
                            system.debug(' hasCallTask>>>'+ hasCallTask);
                            isClosedOpportunity = false;
                        }
                        if (!hasCallTask) {
                            isClosedOpportunity = false;
                            if (!String.isBlank(objTaskSettingMap.RuleForActivity__c)) {
                                newTask.type = typeOfTask;
                                canCreateTask = canCreateCallTask();
                                system.debug(' canCreateTask>>'+ canCreateTask);
                                //Create Task Directly TCC/UCC/FUP/FUA
                            } else
                                    canCreateTask = true;
                        }
                    } else {
                        isClosedOpportunity = false;
                        if (!String.isBlank(objTaskSettingMap.RuleForActivity__c)
                                || !String.isBlank(objTaskSettingMap.RuleForTask__c)) {
                            //Here we get SBR Tasks
                            canCreateTask = canSendBrochure(currentParentTaskMap.get(typeOfTask), currentRequestProgram, leadrecord, oppRecord);
                        }
                        //SPQ Task Comes here
                        else
                        {
                            canCreateTask = true;
                        }



                    }
                    newTask.type = typeOfTask;
                    Id id = (leadrecord != null ? requestEventObject.WhoId : requestEventObject.WhatId);
                    String program = requestEventObject.Program__c;
                    String type = typeOfTask;
                    if (canCreateTask && !tasksForActivitiesList.containsKey(id+'|'+type+'|'+program)){
                        system.debug('>>>>>tasksforactivity'+tasksForActivitiesList.containsKey(id+'|'+type+'|'+program));
                        system.debug('stringcomb'+id+'|'+type+'|'+program);
                        Task task = craeteTaskObject(requestEventObject, newTask,objTaskSettingMap.RecordTypeLabel__c);
                        taskList.put(leadRecord+'|'+task.Type+'|'+requestEventObject.Program__c,task);
                    }
                }
            }
        }

        if (typeToSave.containsKey(SaveType.UPDATEDATA.name())) {
            String[] updateTypeCalls = typeToSave.get(SaveType.UPDATEDATA.name());
            String tasktype = '';
            String currentParentProgram;
            List<Task> closedTaskList;
            Task currentActiveTaskToUpdate;
            for (String type:updateTypeCalls) {
                if (taskSettingsMap.containsKey(type.trim())) {
                    TaskSetting__mdt objTaskSettingMap = taskSettingsMap.get(type);
                    boolean canUpdateTask = false;
                    if (currentParentTaskMap.containsKey(SalesTasks.OPENCALL.name())) {
                        //closedTaskList=new List<Task>();
                        //As Per rules update
                        canUpdateTask = true;
                        tasktype = currentParentTaskMap.get(SalesTasks.OPENCALL.name())[0].type;
                        isClosedOpportunity = false;
                        currentActiveTaskToUpdate = currentParentTaskMap.get(SalesTasks.OPENCALL.name())[0];
                        currentParentProgram = currentParentTaskMap.get(SalesTasks.OPENCALL.name())[0].Program__c;

                        if (canUpdateTask) {
                            isClosedOpportunity = false;
                            //Based on parent program we need to update the due date here
                            Task objUpdateTask;
                            if (currentParentTaskMap.containsKey(SalesTasks.OPENCALL.name())  )
                                closedTaskList = currentParentTaskMap.get(SalesTasks.OPENCALL.name());

                            if (requestEventObject != null && currentParentProgram == requestEventObject.Program__c)
                                system.debug('inside if');
                            objUpdateTask = updateTaskRulesForActivity(closedTaskList, currentActiveTaskToUpdate);
                            system.debug('objUpdateTask >>>>>'+objUpdateTask );

                            if (objUpdateTask != null)
                                taskList.put(objUpdateTask.WhatId+'|'+objUpdateTask.Type+'|'+objUpdateTask.Program__c,objUpdateTask);
                            system.debug('taskList>>>>>'+taskList);
                            break;
                        }
                    }
                }
            }
        }
        //This is  for closed opportunity Need to look into it
        if (typeToSave.containsKey(SaveType.CLOSEDINSERT.name()) && isClosedOpportunity) {
            String[] closedInsertTypeCalls = typeToSave.get(SaveType.UPDATEDATA.name());
            for (String type:closedInsertTypeCalls) {
                if (taskSettingsMap.containsKey(type.trim())) {
                    TaskSetting__mdt objTaskSettingMap = taskSettingsMap.get(type);
                    if (objTaskSettingMap.IsTaskPerCustomer__c) {
                        String[] groupItems = SFLangUtil.splitString(objTaskSettingMap.TaskGroup__c, '|');
                        boolean canInsertTask = false;
                        for (String Item:groupItems) {
                            if (currentParentTaskMap.containsKey(Item)) {
                                for (Task currentTask:currentParentTaskMap.get(Item)) {

                                    if (!currentTask.IsClosed__c) {
                                        canInsertTask = true;
                                        break;
                                    }

                                }
                                if (canInsertTask) {
                                    //Create Task FUP
                                }
                            }
                        }
                    }
                }
            }
        }


        return taskList;
    }

    //For Customer activities we need to updates the call tasks which are alrteady there that is being checked here
    public static Task updateTaskRulesForActivity(List<Task> closedTaskList, Task tasktoUpdate) {


        system.debug('tasktoUpdate before>>>>>'+tasktoUpdate );
        if (closedTaskList != null && closedTaskList.size() > 0) {
            for (Task objtask:closedTaskList) {
                if (date.today() == SFLangUtil.ConvertDateTimeTodate(objtask.FollowUpDate__c)) {
                    return tasktoUpdate;
                }
            }
            //we will update this only if the Sales user has not spoken to customer today.
            if (tasktoUpdate != null)
                system.debug('tasktoUpdate >>>>>'+tasktoUpdate );
            tasktoUpdate.FollowUpDate__c = Datetime.now();
        }



        return tasktoUpdate;
    }

    //Under Construction
    public static void createTaskFromTask(Id parentId, Task salesActionTask) {

    }

    //Partially done only mapping of event to task is done but stiil we need to do task to task mapping
    public static Task craeteTaskObject(Event eventObj, Task objTask,String recordTypeLabel) {
        Id recordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();
        Task newTask = new Task();
        String taskSubject='';
        if (eventObj != null) {

            newTask.WhoId = eventObj.WhoId;
            newTask.WhatId = eventObj.WhatId;
            //newTask.Market__c = eventObj.Market__c;
            newTask.Type = (objTask.Type==SalesTasks.TCC.Name())?SalesTasks.Call.Name():objTask.Type;
            system.debug('>>>>tyoe'+newTask.Type);
            if(objTask.Type==SalesTasks.TCC.Name()) {
                newTask.NextCallType__c = objTask.Type;
            }
            system.debug('>>nextcalltype'+newTask.NextCallType__c);
            newTask.FalseBrochureProgramCodes__c = eventObj.FalseBrochureProgramCodes__c;
            newTask.Program__c = eventObj.Program__c;
            newTask.IsExpressCall__c= eventObj.IsExpressCall__c;
            newTask.FollowUpDate__c = Datetime.now();
            newTask.ActivityDate = SFLangUtil.ConvertDateTimeTodate(Datetime.now()) ;
            newTask.EventId__c = eventObj.Id;
            newTask.recordtypeid =recordTypeId;

            taskSubject=taskSettingsMap.get(objTask.Type).TaskSubject__c;
            String[] program=SFLangUtil.splitString(taskSubject,' _');
            if(program.size()>1)
            {
                taskSubject=program[0]+eventObj.Program__c;
            }
            newTask.Subject=String.isBlank(taskSubject)?objTask.Type:taskSubject;

        } else {
            newTask = objTask;
        }
        return newTask;
    }

    //SBR Complete rules are being verified here
    public static Boolean canSendBrochure(List<Task> taskList, String currentRequestProgram, Lead leadRecord, opportunity oppRecord) {
        boolean canSendBR = false;
        String temp ='';
        canSendBR = oppRecord != null ?  oppRecord.Account.HasAddress__c:false;
        if (!canSendBR) {
            return canSendBR;
        }
        Map<String, MarketProgramLevelSetting__c> marketProgramSetting = MarketProgramLevelSetting__c.getAll();
        If(taskList!=null && taskList.size()>0)
        {
            for (Task taskRecord: taskList) {
                //temp=taskRecord.market__c + '_' + taskRecord.program__c;
                if (marketProgramSetting.containsKey(temp)) {

                    if (taskRecord.IsClosed__c &&(marketProgramSetting.get(temp).AutoCloseBrochureRequest__c == null
                            || marketProgramSetting.get(temp).AutoCloseBrochureRequest__c == 0
                            || marketProgramSetting.get(temp).AutoCloseBrochureRequest__c
                            <
                            (SFLangUtil.ConvertDateTimeTodate(taskRecord.CloseDate__c).daysBetween(date.today())))
                            && !marketProgramSetting.get(temp).DoNotSendBrochure__c) {
                        canSendBR = true;
                        break;
                    }
                    else if(taskRecord.program__c==currentRequestProgram && !taskRecord.IsClosed__c)
                    {
                        canSendBR = false;
                        break;
                    }
                    else if(!marketProgramSetting.get(temp).DoNotSendBrochure__c)
                    {
                        canSendBR = true;
                        break;
                    }


                }

                else if(taskRecord.Program__c==currentRequestProgram && !taskRecord.IsClosed__c )
                {
                    canSendBR = false;
                    break;
                }

            }
        }
        else
        {
            //temp=eventRecord.market__c + '_' + eventRecord.program__c;
            if (marketProgramSetting.containsKey(temp)) {
                if(marketProgramSetting.get(temp).DoNotSendBrochure__c)
                {
                    canSendBR = false;
                }
            }

        }
        return canSendBR;
    }
    //Create call task only if below condition are verified
    public static Boolean canCreateCallTask() {
        return (oppRecord != null)? (oppRecord.Account.HasPhoneNumber__c &&  !oppRecord.Account.PersonDoNotCall):false;
    }

    //Here we check weather we have already task for perticular request which we wiil be saving
    // we will be avoiding creating duplicate task for same request
    public static Boolean isTheTaskAlreadyInQue(Id parentId, String program, String taskType) {
        Boolean hasTaskToCreate = false;
        id whoIdOrWhatId;
        for (Task objTask:tasksForActivitiesList.values()) {
            whoIdOrWhatId=((leadrecord != null) ? objTask.WhoId : objTask.WhatId);
            if (whoIdOrWhatId == parentId  && taskType != SalesTasks.SBR.name()){
                hasTaskToCreate = true;
                break;
            } else if (whoIdOrWhatId == parentId
                    && objTask.program__c == program
                    && taskType == SalesTasks.SBR.name()) {
                hasTaskToCreate = true;
                break;
            }
        }
        return hasTaskToCreate;
    }

    //
    public static Boolean closeTasksOnParent(Id parentId){
        try {
            List<Task> tasksToBeClosed = new List<Task>();
            if (String.valueOf(parentId).substring(0, 3) == '006') {
                tasksToBeClosed = [Select Id,Status FROM Task WHERE WhatId = :parentId AND (Status != 'Deferred' OR Status != 'Completed')];
                for (Task task : tasksToBeClosed) {
                    task.Status = 'Deferred';
                }
                update tasksToBeClosed;
            }
            return true;
        }
        catch (exception ex) {
            ExceptionHandler.errorLog(ex.getMessage(), ex.getStackTraceString(),
                    'Tasks', 'closeTasksOnParent', parentId);
            return false;
        }
    }

    public static void handleLogAnAction(Id parentId, Task newTask,Datetime visitDatetime){
        Task openCallTask = null;
        Opportunity opp = null;
        Lead lead = null;
        string finalProgram;
        System.debug('Call Action :'+newTask.SalesAction__c);
        System.debug('Call Result :'+newTask.ResultType__c);
        System.debug('program :'+newTask.Program__c);
        System.debug('closeReason :'+newTask.CloseMainReason__c);
        System.debug('Follow up date :'+newTask.FollowUpDate__c);
        System.debug('nextCallType :'+newTask.NextCallType__c);
        String callAction = newTask.SalesAction__c;
        String callResult = newTask.ResultType__c;
        String selectedProgram = newTask.Program__c;
        String closeReason = newTask.CloseMainReason__c;
        Datetime followupDate = newTask.FollowUpDate__c;
        Id systemTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('System Task').getRecordTypeId();
        String currentProgram = '';
        // If Lead, use WhoId to filter
        // If Opportunity, use WhatId to filter
        if (String.valueOf(parentId).substring(0, 3) == '00Q') {
            lead = [SELECT Id, Name, Status, Product__c, Program__c FROM Lead WHERE Id = :parentId];
            List<Task> openCallTasks = [
                    SELECT Id,  Subject, Status,NextCallType__c, FollowUpDate__c, Program__c, Type,IsClosed__c,IsOpportunityClosing__c,RecordTypeId
                    FROM Task
                    WHERE WhoId = :parentId AND IsClosed__c = false AND Type = 'Call' AND RecordTypeId = :systemTaskRecordTypeId
            ];
            if(openCallTasks.size() > 0){
                openCallTask = openCallTasks[0];
            }
            currentProgram = lead.Program__c;
        } else if (String.valueOf(parentId).substring(0, 3) == '006') {
            opp = [SELECT Id, Name, StageName, Product__c, Program__c,FirstContactDateTime__c FROM Opportunity WHERE Id = :parentId];
            List<Task> openCallTasks = [
                    SELECT Id,Subject, Status,NextCallType__c, FollowUpDate__c,Program__c,Type,IsClosed__c,IsOpportunityClosing__c,RecordTypeId
                    FROM Task
                    WHERE WhatId = :parentId AND IsClosed__c = false AND Type = 'Call' AND RecordTypeId = :systemTaskRecordTypeId
            ];
            if(openCallTasks.size() > 0){
                openCallTask = openCallTasks[0];
            }
            System.debug('Its Opportunity');
            if(allReachedItems.contains(callAction.toUpperCase()) && opp.FirstContactDateTime__c == NULL){
                System.debug('Date is empty');
                opp.FirstContactDateTime__c = Datetime.now();
                update opp;
            }
            currentProgram = opp.Program__c;
        }

        if (callAction != null && callResult != null ) {
            if(openCallTask != NULL && callResult.toUpperCase() != Label.CloseOpp.toUpperCase())    {
                String nextCallType = openCallTask.NextCallType__c;
                openCallTask.IsOpportunityClosing__c = true;
                update openCallTask;

                if (callResult.toUpperCase() == Label.CallBack.toUpperCase()) {
                    System.debug('Call back section invoked');
                    if (allReachedItems.contains(callAction.toUpperCase()) &&
                            (nextCallType == SalesTasks.FUP.name() ||
                                    nextCallType == SalesTasks.FUA.name() ||
                                    nextCallType == SalesTasks.TCC.name() ||
                                    nextCallType == SalesTasks.UCC.name())) {
                        openCallTask.NextCallType__c = SalesTasks.FUP.name();

                    } else if (allNotReachedItems.contains(callAction.toUpperCase())) {
                        if (nextCallType == SalesTasks.TCC.name() || nextCallType == SalesTasks.UCC.name()) {
                            openCallTask.NextCallType__c = SalesTasks.UCC.name();
                        } else if (nextCallType == SalesTasks.FUP.name() || nextCallType == SalesTasks.FUA.name()) {
                            openCallTask.NextCallType__c = SalesTasks.FUP.name();
                        }
                    }

                    openCallTask.FollowUpDate__c = followupDate;
                    openCallTask.ActivityDate = SFLangUtil.ConvertDateTimeTodate(followupDate);
                    update openCallTask;
                } else if (openCallTask != NULL && callResult.toUpperCase() == Label.CallAppointment.toUpperCase()) {
                    System.debug('Call appointment section invoked');
                    openCallTask.NextCallType__c = SalesTasks.FUA.name();
                    openCallTask.FollowUpDate__c = followupDate;
                    openCallTask.ActivityDate = SFLangUtil.ConvertDateTimeTodate(followupDate);
                    update openCallTask;
                } else if (openCallTask != NULL && callResult.toUpperCase() == Label.Visit.toUpperCase()) {
                    System.debug('Visit section invoked');
                    openCallTask.NextCallType__c = SalesTasks.FUA.name();
                    openCallTask.FollowUpDate__c = followupDate;
                    openCallTask.ActivityDate = SFLangUtil.ConvertDateTimeTodate(followupDate);
                    Event visitEvent = new Event();
                    visitEvent.Program__c = (String.valueOf(parentId).substring(0, 3) == '00Q')?lead.Program__c: opp.Program__c;
                    visitEvent.FollowUpDate__c = visitDatetime;
                    visitEvent.Subject = 'one to one consultation';
                    if(String.valueOf(parentId).substring(0, 3) == '006'){
                        visitEvent.WhatId = opp.Id;
                    }
                    else if(String.valueOf(parentId).substring(0, 3) == '00Q'){
                        visitEvent.WhoId = lead.Id;
                    }
                    visitEvent.DurationInMinutes = 30;
                    visitEvent.ActivityDateTime = visitDatetime;
                    insert visitEvent;
                    update openCallTask;
                } else if (openCallTask != NULL && callResult.toUpperCase() == Label.ChangeProgram.toUpperCase()) {
                    System.debug('Change program section invoked');
                    Map<String, List<String>> picklistDependencies = FieldUtilityClass.getFieldDependencies(getSObjectName(parentId), 'Product__c', 'Program__c');
                    String product = '';
                    for (String products : picklistDependencies.keySet()) {
                        for (String program: picklistDependencies.get(products)) {
                            if (program == selectedProgram) {
                                product = products;
                                break;
                            }
                        }
                    }
                    openCallTask.NextCallType__c = SalesTasks.FUP.name();
                    openCallTask.FollowUpDate__c = followupDate;
                    openCallTask.ActivityDate = SFLangUtil.ConvertDateTimeTodate(followupDate);
                    openCallTask.Program__c = selectedProgram;
                    String subject = openCallTask.Subject;
                    String[] splitSubject = SFLangUtil.splitString(subject, '-');
                    if(splitSubject.size() > 0) {
                        openCallTask.Subject = splitSubject[0] + ' - '+selectedProgram;
                    }
                    if(String.valueOf(parentId).substring(0, 3) == '006'){
                        opp.Product__c = product;
                        opp.Program__c = selectedProgram;
                        update openCallTask;
                        update opp;
                    }
                    else if(String.valueOf(parentId).substring(0, 3) == '00Q'){
                        lead.Product__c = product;
                        lead.Program__c = selectedProgram;
                        update openCallTask;
                        update lead;
                    }
                }

                newTask.Type = openCallTask.NextCallType__c;
                newTask.Status = 'Completed';
                newTask.Program__c = currentProgram;
                insert newTask;

                openCallTask.IsOpportunityClosing__c = false;
                update openCallTask;
            }
            else if (callResult.toUpperCase() == Label.CloseOpp.toUpperCase()) {
                System.debug('Close section invoked');
                if(String.valueOf(parentId).substring(0, 3) == '006'){
                    opp.StageName = 'Closed Lost';
                    opp.CloseMainReason__c = closeReason;
                    update opp;
                }
                else if(String.valueOf(parentId).substring(0, 3) == '00Q'){
                    lead.Status = 'Closed';
                    update lead;
                }
            }
        }

    }

    private static String getSObjectName(Id recordId){
        if(String.valueOf(recordId).substring(0, 3) == '00Q'){
            return Lead.getSObjectType().getDescribe().getName();
        }
        else if(String.valueOf(recordId).substring(0, 3) == '006') {
            return Opportunity.getSObjectType().getDescribe().getName();
        }
        return null;
    }

    /**
    * @author Arkadiusz Celej
    * @date 29.11.2017
    * @description Method updates parent records based on changed tasks
    * @version 1.0
    * */
    public static void updateParents(Map<Id, SObject> newItems){
        updateOpportunitiesWithSBRTasks((Map<Id, Task>)newItems);
        updateOpportunityPendingToDoList((Map<Id, Task>)newItems);
    }


    private static void updateOpportunityPendingToDoList(Map<Id, Task> tasksByIds){
        Set<Id> parentOppIds = new Set<Id>();
        for(Task t : tasksByIds.values()){
            String whatId = t.WhatId;
            if( whatId != NULL && whatId.startsWith('006') && isCallTypeTask(t.RecordTypeId)){
                parentOppIds.add(t.WhatId);
            }
        }

        if(parentOppIds.size() > 0) {
            processOpportunitiesWithPendingNonCallTasks(parentOppIds, tasksByIds);
        }
    }

    private static Boolean isCallTypeTask(Id recordTypeId){
        return isTaskRecordType(SBR_TASK_DEVELOPER_NAME, recordTypeId)
                || isTaskRecordType(MCR_TASK_DEVELOPER_NAME, recordTypeId)
                || isTaskRecordType(SPQ_TASK_DEVELOPER_NAME, recordTypeId);
    }

    private static Boolean isTaskRecordType(String recordTypeDeveloperName, Id recordTypeId){
        return RecordTypeSelector.getRecTypesByDevName(Task.SObjectType).containsKey(recordTypeDeveloperName)
               && RecordTypeSelector.getRecTypesByDevName(Task.SObjectType).get(recordTypeDeveloperName).Id == recordTypeId;
    }

    private static void processOpportunitiesWithPendingNonCallTasks(Set<Id> idsToProcess, Map<Id, Task> updatedTasksByIds){
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        List<Opportunity> opportunitiesToProcess =
                OpportunitiesSelector.getOpportunitiesWithTasksByIdAndTaskRecordType(
                        new List<Id>(idsToProcess),
                        new Set<String>{SBR_TASK_DEVELOPER_NAME, MCR_TASK_DEVELOPER_NAME, SPQ_TASK_DEVELOPER_NAME}
                );
        Map<Id, Map<Id, Task>> tasksByOpportunityIdsIds = new Map<Id, Map<Id, Task>>();
        for(Opportunity opp : opportunitiesToProcess){
            if(opp.Tasks.size() > 0){
                for(Task oppTask : opp.Tasks){
                    if(!tasksByOpportunityIdsIds.containsKey(opp.Id)) {
                        tasksByOpportunityIdsIds.put(opp.Id, new Map<Id, Task>());
                    }
                    tasksByOpportunityIdsIds.get(opp.Id).put(oppTask.Id, oppTask);
                }
            }
        }

        for(Task t : updatedTasksByIds.values()){
            if(!tasksByOpportunityIdsIds.containsKey(t.WhatId)) {
                tasksByOpportunityIdsIds.put(t.WhatId, new Map<Id, Task>());
            }
            tasksByOpportunityIdsIds.get(t.WhatId).put(t.Id, t);
        }

        for(Id oppId : tasksByOpportunityIdsIds.keySet()){
            Task[] opportunityTasks = tasksByOpportunityIdsIds.get(oppId).values();
            List<String> pendingToDo = new List<String>();
            for(Task t : opportunityTasks){
                if(!t.IsClosed){
                    pendingToDo.add(t.Type);
                }
            }
            Opportunity toUpdate = new Opportunity(Id = oppId);
            toUpdate.PendingToDo__c = String.join(pendingToDo, SEPARATOR);
            opportunitiesToUpdate.add(toUpdate);
        }

        if(opportunitiesToUpdate.size() > 0){
            update opportunitiesToUpdate;
        }
    }


    private static void updateOpportunitiesWithSBRTasks(Map<Id, Task> tasksByIds){
        Set<Id> parentOppIds = new Set<Id>();
        for(Task t : tasksByIds.values()){
            String whatId = t.WhatId;
            if( whatId != NULL
                    && whatId.startsWith('006')
                    && RecordTypeSelector.getRecTypesByDevName(Task.SObjectType).containsKey(SBR_TASK_DEVELOPER_NAME)
                    && t.RecordTypeId == RecordTypeSelector.getRecTypesByDevName(Task.SObjectType).get(SBR_TASK_DEVELOPER_NAME).Id)
                            {
                parentOppIds.add(t.WhatId);
            }
        }

        if(parentOppIds.size() > 0) {
            processOpportunitiesWithSBRTasks(parentOppIds, tasksByIds);
        }
    }

    private static void processOpportunitiesWithSBRTasks(Set<Id> idsToProcess, Map<Id, Task> updatedTasksByIds){
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        List<Opportunity> opportunitiesToProcess =
                OpportunitiesSelector.getOpportunitiesWithTasksByIdAndTaskRecordType(
                        new List<Id>(idsToProcess),
                        new Set<String>{SBR_TASK_DEVELOPER_NAME}
                );
        Map<Id, Map<Id, Task>> tasksByOpportunityIdsIds = new Map<Id, Map<Id, Task>>();
        for(Opportunity opp : opportunitiesToProcess){
            if(opp.Tasks.size() > 0){
                for(Task oppTask : opp.Tasks){
                    if(!tasksByOpportunityIdsIds.containsKey(opp.Id)) {
                        tasksByOpportunityIdsIds.put(opp.Id, new Map<Id, Task>());
                    }
                    tasksByOpportunityIdsIds.get(opp.Id).put(oppTask.Id, oppTask);
                }
            }
        }

        for(Task t : updatedTasksByIds.values()){
            if(!tasksByOpportunityIdsIds.containsKey(t.WhatId)) {
                tasksByOpportunityIdsIds.put(t.WhatId, new Map<Id, Task>());
            }
            tasksByOpportunityIdsIds.get(t.WhatId).put(t.Id, t);
        }

        for(Id oppId : tasksByOpportunityIdsIds.keySet()){
            Task[] opportunityTasks = tasksByOpportunityIdsIds.get(oppId).values();
            Set<String> brochuresToSend = new Set<String>();
            Set<String> sentBrochures = new Set<String>();
            for(Task t : opportunityTasks){
                if(t.TaskResult__c != DO_NOT_SEND_BROCHURE){
                    if(!t.IsClosed){
                        brochuresToSend.add(t.Program__c);
                        if(t.FalseBrochureProgramCodes__c!= NULL) {
                            brochuresToSend.addAll(t.FalseBrochureProgramCodes__c.split(SEPARATOR));
                        }
                    }else if(t.IsClosed && t.TaskResult__c == SENT_BROCHURE){
                        sentBrochures.add(t.Program__c);
                        if(t.FalseBrochureProgramCodes__c!= NULL) {
                            sentBrochures.addAll(t.FalseBrochureProgramCodes__c.split(SEPARATOR));
                        }
                    }
                }
            }
            Opportunity toUpdate = new Opportunity(Id = oppId);
            toUpdate.BrochuresToSend__c = String.join(new List<String>(brochuresToSend), SEPARATOR);
            toUpdate.SentBrochures__c = String.join(new List<String>(sentBrochures), SEPARATOR);
            opportunitiesToUpdate.add(toUpdate);
        }

        if(opportunitiesToUpdate.size() > 0){
            update opportunitiesToUpdate;
        }
    }
}