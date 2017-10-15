@isTest
private class ApexLambdaTest {

    @isTest
    static void filter_test() {
        ApexLambda.filter(Account.Name);
        ApexLambda.filter(new Account(Name = 'TestAccount'));
    }

    @isTest
    static void groupBy_test() {
        List<Contact> records = new List<Contact>{
        };
        Schema.SObjectField field = Contact.LastName;
        Object groupedContacts;
        groupedContacts = ApexLambda.groupBy(
            records,
            field,
            ApexTypesEnum.stringType
        );
        groupedContacts = ApexLambda.groupBy(
            records,
            field,
            ApexTypesEnum.dateType
        );
        groupedContacts = ApexLambda.groupBy(
            records,
            field,
            ApexTypesEnum.booleanType
        );
        groupedContacts = ApexLambda.groupBy(
            records,
            field,
            ApexTypesEnum.idType
        );
        groupedContacts = ApexLambda.groupBy(
            records,
            field,
            ApexTypesEnum.decimalType
        );
    }

    @isTest
    private static void pluck_test(){
        List<Contact> records = new List<Contact>{
        };
        Schema.SObjectField field = Contact.LastName;
        Object pluckedContacts;
        pluckedContacts = ApexLambda.pluck(
            records,
            field,
            ApexTypesEnum.stringType
        );
        pluckedContacts = ApexLambda.pluck(
            records,
            field,
            ApexTypesEnum.dateType
        );
        pluckedContacts = ApexLambda.pluck(
            records,
            field,
            ApexTypesEnum.booleanType
        );
        pluckedContacts = ApexLambda.pluck(
            records,
            field,
            ApexTypesEnum.idType
        );
        pluckedContacts = ApexLambda.pluck(
            records,
            field,
            ApexTypesEnum.decimalType
        );
    }
}