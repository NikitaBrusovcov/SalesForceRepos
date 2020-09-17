public with sharing class TaskCreator {

    @InvocableMethod(label = 'Creater of Tasks' category = 'Account')
    public static void managingTask(List<AccountVars> vars){
        for(AccountVars var : vars){
            Id accountId = var.account.Id;
            String accountName = var.account.name;
            List<Task> tasks = [SELECT Subject FROM Task WHERE WhatId =: accountId];
            if (tasks.size() <= 3){
                insert createNewTask(accountId, accountName);
            }else {
                assignTask(tasks);
                update tasks;
            }

        }
    }

    private static Task createNewTask(Id accountId, String accountName){
        Task newTask = new Task();
        newTask.WhatId = accountId;
        newTask.Subject = 'Negotiations with' + accountName;
        return newTask;
    }

    private static void assignTask(List<Task> tasks){
        List<User> users = [SELECT id FROM User WHERE IsActive = TRUE];
        Integer enteredRandomUser = (Math.random() * (users.size() - 1)).intValue();
        for (Task task : tasks){
            task.OwnerId = users.get(enteredRandomUser).Id;
        }
    }

    public class AccountVars{
        @InvocableVariable(required = true)
        public Account account;
    }
}