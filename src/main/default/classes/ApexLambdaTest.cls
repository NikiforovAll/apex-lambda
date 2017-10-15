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
}