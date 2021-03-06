public class ApexLambda {
    public static MatchingFilterQuery filter(sObject prototype){
        return Filter.match(prototype);
    }

    public static FieldFilterQueryElement filter(Schema.SObjectField field){
        return Filter.field( field);
    }
    
	public static Map<Boolean, List<sObject>> groupBy(
        List<sObject> records,
        Schema.SObjectField field,
        ApexTypesEnum.BooleanType type) {

        return GroupBy.booleans(records, field);
    }

	public static Map<String, List<sObject>> groupBy(
        List<sObject> records,
        Schema.SObjectField field,
        ApexTypesEnum.StringType type) {
            
        return GroupBy.strings(records, field);
    }

	public static Map<Date, List<sObject>> groupBy(
        List<sObject> records,
        Schema.SObjectField field,
        ApexTypesEnum.DateType type) {
            return GroupBy.dates(records, field);
    }

	public static Map<Id, List<sObject>> groupBy(
        List<sObject> records,
        Schema.SObjectField field,
        ApexTypesEnum.IdType type) {
            
        return GroupBy.ids(records, field);
    }

	public static Map<Decimal, List<sObject>> groupBy(
        List<sObject> records,
        Schema.SObjectField field,
        ApexTypesEnum.DecimalType type) {
            
        return GroupBy.decimals(records, field);
    }

    public static List<Boolean> pluck(List<SObject> records, Schema.SObjectField field, ApexTypesEnum.BooleanType type){
        return Pluck.booleans(records, field);
    }

    public static List<String> pluck(List<SObject> records, Schema.SObjectField field, ApexTypesEnum.StringType type){
        return Pluck.strings(records, field);
    }

    public static List<Decimal> pluck(List<SObject> records, Schema.SObjectField field, ApexTypesEnum.DecimalType type){
        return Pluck.decimals(records, field);
    }

    public static List<Date> pluck(List<SObject> records, Schema.SObjectField field, ApexTypesEnum.DateType type){
        return Pluck.dates(records, field);
    }

    public static Set<Id> pluck(List<SObject> records, Schema.SObjectField field, ApexTypesEnum.IdType type){
        return Pluck.ids(records, field);
    }
}
