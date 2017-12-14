public with sharing class MyProductivity {

    private static Id USER = UserInfo.getUserId();
    
    @AuraEnabled
    public static MyStatistics getMyStatistics(){
        try{
            MyStatistics stats = new MyStatistics();
            stats.myCompletedTasks = MyProductivity.calculateMyCompletedTasks();
            stats.myReachedTasks = MyProductivity.calculateMyReachedTasks();
            stats.weeksBooked = MyProductivity.calculateWeeksBooked();
            stats.myLeads = MyProductivity.myLeads();
            return stats;
        }catch(Exception ex){
            throw new AuraHandledException('Something went wrong: '+ ex.getMessage());
        }
        return NULL;
    }
    
    private static Integer calculateMyCompletedTasks(){
        return TasksSelector.getTasksClosedTodayByUser(USER).size();
    }

    private static Integer calculateMyReachedTasks(){
        return TasksSelector.getTodaysCallTasksReachedByUser(USER).size();
    }
    
    private static Integer myLeads(){
        return (Integer)TasksSelector.getTodaysTasksByTypeAndWhoType('CallTask', 'Lead')[0].get('cnt');
    }
    
    private static Integer calculateWeeksBooked(){
        return 0;
    }
    
    public class MyStatistics{
        @AuraEnabled
        public Integer myCompletedTasks;
        @AuraEnabled
        public Integer myReachedTasks;
        @AuraEnabled
        public Integer weeksBooked;
        @AuraEnabled
        public Integer myLeads;
    }
}