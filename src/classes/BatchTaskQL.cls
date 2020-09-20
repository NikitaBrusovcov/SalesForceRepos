public with sharing class BatchTaskQL implements Database.Batchable<SObject>, Database.Stateful{

    public Database.QueryLocator start(Database.BatchableContext batchableContext) {
        System.debug('Begin!');
        return Database.getQueryLocator('SELECT Id, \n' +
                'AccountId, \n' +
                'account.BillingAddress, \n' +
                'account.BillingCountry, \n' +
                'account.BillingCity, \n' +
                'account.BillingPostalCode, \n' +
                'account.BillingStreet, \n' +
                'account.BillingState \n' +
                'FROM Contact \n' +
                'WHERE Is_Synced__c = FALSE'
        );
    }

    public void execute(Database.BatchableContext batchableContext, List<Contact> contacts) {
        System.debug('Execute');
        List<Account> accounts = new List<Account>();
        for (Contact contact : contacts){
            Account account = contact.Account;
            contact.MailingCountry = account.BillingCountry;
            contact.MailingCity =  account.BillingCity;
            contact.MailingPostalCode = account.BillingPostalCode;
            contact.MailingStreet = account.BillingStreet;
            contact.MailingState = account.BillingState;
            contact.Is_Synced__c = true;
            account.Updated_By_Contact__c = true;
            accounts.add(account);
        }
        update contacts;
        update accounts;

    }

    public void finish(Database.BatchableContext batchableContext) {
        System.debug('End!');
    }
}