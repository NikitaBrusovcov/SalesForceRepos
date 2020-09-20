public with sharing class ScheduleTask implements Schedulable{

    public void execute(SchedulableContext schedulableContext) {
        Database.executeBatch(new BatchTaskIt());
        Database.executeBatch(new BatchTaskQL());
    }
}