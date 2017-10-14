public class ApexLambda {
    public static MatchingFilterQuery filter(sObject prototype){
        Filter.match(prototype);
    }

    public static FieldFilterQueryElement filter(Schema.SObjectField field){
        Filter.field( field);
    }
}
