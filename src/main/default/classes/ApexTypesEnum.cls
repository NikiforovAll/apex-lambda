public class ApexTypesEnum {
    // WARNING no actual object initialization
    public static BooleanType booleanType;
    public static StringType stringType;
    public static DateType dateType;
    public static IdType idType;
    public static DecimalType decimalType;

    public class BooleanType extends ApexBaseType{
        public BooleanType(){
            type = ApexTypeEnum.BooleanType;
        }
    }

    public class StringType extends ApexBaseType{
        public StringType(){
            type = ApexTypeEnum.StringType;
        }
    }
    public class DateType extends ApexBaseType{
        public DateType(){
            type = ApexTypeEnum.DateType;
        }
    }
    public class IdType extends ApexBaseType{
        public IdType(){
            type = ApexTypeEnum.IdType;
        }
    }
    
    public class DecimalType extends ApexBaseType{
        public DecimalType(){
            type = ApexTypeEnum.DecimalType;
        }
    }
    
    public virtual class ApexBaseType {
        public ApexTypeEnum type;
    }

    public enum ApexTypeEnum {
        BooleanType, 
        StringType,
        IdType,
        DateType,
        DecimalType
    }
}
