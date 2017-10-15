# Lambda

Lambda brings functional programming to Salesforce!

## Functionality

- [List manipulation](#list-manipulation)
	- [`Filter`](#filter)
	- [`GroupBy`](#group-by)
	- [`Pluck`](#pluck)
	- [Important notes on the type system in Apex](#type-system)

- [Utilities](#utilities)
	- [`ApexString`](#apex-string)
	- [`Optional`](#optional)

## List manipulation
<a name="list-manipulation"></a>

### `Filter`
<a name="filter"></a>

`Filter` enables filtering lists of sObject records by declaring *criteria* that records have to match through a fluent interface.

| Modifier and type | Method | Description |
|-------------------|--------|-------------|
| `static MatchingFilterQuery` 		| `filter(SObject prototype)` 			| Constructs and returns an object matching query against the `prototype` |
| `static FieldFilterQueryElement` 	| `filter(Schema.SObjectField field)` 	| Constructs and returns a field matching filter starting with `field` |


#### Object matching filter

```java
Account prototype = new Account(
    Name = 'Test',
    AnnualRevenue = 50000000
);
// Accounts named 'Test' with an AnnualRevenue of **exactly** 50,000,000 are matched
List<Account> filtered = ApexLambda.filter(prototype).apply(accounts);
```

Matches list records against a “prototype” object. A list record is a match if all the fields which are defined on the prototype object are equal to those on the list record.

`ApexLambda.filter(SObject prototype)` returns a `MatchingFilterQuery` which provides methods to match the filter against a list.

| Modifier and type | Method | Description |
|-------------------|--------|-------------|
| `List<SObject>`	| `apply(Iterable<sObject> records)` 				| Matches elements in `records` and returns them as a new list |
| `List<SObject>`	| `apply(Iterable<sObject> records, Type listType)`	| Matches elements in `records` and returns them as a new list of `listType` type |
| `FilterResult`	| `applyLazy(Iterable<sObject> records)`			| Returns `FilterResult` iterable which can be used for lazy matching to allow extraction of partial results from large sources |
| `List<SObject>`	| `extract(Iterable<sObject> records)`				| Matches elements in `records`, removes them from the original list and returns them in a new list |
| `List<SObject>`	| `extract(Iterable<sObject> records)`				| Matches elements in `records`, removes them from the original list and returns them in a new list of `listType` type |

#### Field matching filter

Matches against field criteria.

```java
// Accounts named 'Test' are matched
List<Account> testAccounts = ApexLambda.filter(Account.Name).equals('Test').apply(accounts);
```

Multiple criteria can be stringed together with `also` to form the full matching query. Records have to match *all*	 criteria.

```java
// Accounts named 'Test' with annual revenue under 100,000 are matched
List<Account> filtered = Filter.field(Account.Name).lessThanOrEquals('Test')
                               .also(Account.AnnualRevenue).equals(100000)
                               .apply(accounts);
```

`Filter.field(Schema.SObjectField field)` returns a `FieldFilterQueryElement` which is used to define criteria:

| Modifier and type | Method | Alias | Description |
|-------------------|--------|-------|-------------|
| `FieldFilterQuery` | `equals(Object value)`				| `eq` | Defines an equality comparison criterium for the current field |
| `FieldFilterQuery` | `notEquals(Object value)`			| `neq` | Defines an inequality comparison criterium for the current field |
| `FieldFilterQuery` | `lessThan(Object value)`				| `lt` | Defines a less than comparison criterium for the current field |
| `FieldFilterQuery` | `lessThanOrEquals(Object value)` 	| `leq` | Defines a less than or equals criterium for the current field |
| `FieldFilterQuery` | `greaterThan(Object value)`			| `gt` | Defines a greater than criterium for the current field |
| `FieldFilterQuery` | `greaterThanOrEquals(Object value)`	| `geq` | Defines a greaterThanOrEquals criterium for the current field |
| `FieldFilterQuery` | `isIn(Object value)` 				| 		| Defines a set membership criterium for the current field |
| `FieldFilterQuery` | `isNotIn(Object value)` 				| `notIn` | Defines a set non-membership criterium for the current field |
| `FieldFilterQuery` | `hasValue()` 						| `notNull` | Defines a non-null criterium for the current field |

`FieldFilterQuery` can then be *applied* to a list, or further criteria can be chained with `also` (alias `field`):

| Modifier and type | Method | Description |
|-------------------|--------|-------------|
| `FieldFilterQueryElement` | `also(Schema.SObjectField field)` | Chains another criterium to the filtering query |
| `List<SObject>` | `apply(Iterable<sObject> records)` | Matches elements in `records` and returns them as a new list |
| `List<SObject>` | `apply(Iterable<sObject> records, Type listType)` | Matches elements in `records` and returns them as a new list of `listType` type |
| `FilterResult` | `applyLazy(Iterable<sObject> records)` | Returns `FilterResult` iterable which can be used for lazy matching to allow extraction of partial results from large sources |
| `List<SObject>` | `extract(Iterable<sObject> records)` | Matches elements in `records`, removes them from the original list and returns them in a new list |
| `List<SObject>` | `extract(Iterable<sObject> records)` | Matches elements in `records`, removes them from the original list and returns them in a new list of `listType` type |

#### Warning :warning:

Most criteria expect a primitive value to compare against. `isIn` and `isNotIn` instead expect a `Set` of one of the following types: `Boolean`, `Date`, `Decimal`, `Double`, `Id`, `Integer` or `String`. **Other types are not supported and will throw an exception**.

Fields used in field criteria must be available on the list which is filtered, otherwise a `System.SObjectException: SObject row was retrieved via SOQL without querying the requested field` exception can be thrown.

Fields that are present on the *prototype* object must also be available on the list which is filtered, otherwise a `System.SObjectException: SObject row was retrieved via SOQL without querying the requested field` exception will be thrown.

Filtering query is dynamic and cannot be type-checked at compile-time.

### `GroupBy`
<a name="group-by"></a>

Groups objects by values on a specified field.

```java
Map<String, List<Opportunity>> opportunitiesByCloseDate = ApexLambda.groupBy(opportunities, Opportunity.CloseDate, ApexTypesEnum.stringType);
```

| Modifier and type | Method | Description |
|-------------------|--------|-------------|
| Map<Boolean, List<SObject>> | `groupBy(List<SObject> records, Schema.SObjectField field, ApexTypesEnum.BooleanType type)` | Groups `records` by value on boolean `field` |
| Map<Date, List<SObject>> | `groupBy(List<SObject> records, Schema.SObjectField field, ApexTypesEnum.DateType type)` | Groups `records` by value on date `field` |
| Map<Decimal, List<SObject>> | `groupBy(List<SObject>, Schema.SObjectField field, ApexTypesEnum.DecimalType type)` | Groups `records` by value on number `field` |
| Map<Id, List<SObject>> | `groupBy(List<SObject>, Schema.SObjectField field, ApexTypesEnum.IdType type)` | Groups `records` by value on id `field` |
| Map<String, List<SObject>> | `groupBy(List<SObject>, Schema.SObjectField field, ApexTypesEnum.StringType type)` | Groups `records` by value on string `field` |

#### Warning :warning:

**The type system will NOT warn you if you use the wrong subtype of `sObject`!** [Important notes on the type system in Apex](#type-system) section explains why.

### `Pluck`
<a name="pluck"></a>

Plucks field values from a list of sObjects into a new list.

```java
List<Account> accounts = new List<Account>{
	new Account(Name = 'Foo'),
	new Account(Name = 'Bar')
}
// Names are plucked into a new list ['Foo', 'Bar']
List<String> names = ApexLambda.pluck(accounts, Account.Name, ApexTypesEnum.stringType);
```

| Modifier and type | Method | Description |
|-------------------|--------|-------------|
| List<Boolean> | pluck(List<SObject> records, Schema.SObjectField field, ApexTypesEnum.BooleanType type) | Plucks booleans on `field` into a new list |
| List<Date> | `pluck(List<SObject> records, Schema.SObjectField field, ApexTypesEnum.DateType type)` | Plucks dates on `field` into a new list |
| List<Decimal> | `pluck(List<SObject> records, Schema.SObjectField field, ApexTypesEnum.DecimalType type)` | Plucks numbers on `field` into a new list |
| Set<Id> | `pluck(List<SObject> records, Schema.SObjectField field, ApexTypesEnum.IdType type)` | Plucks ids on `field` into a new set |
| List<String> | `pluck(List<SObject> records, Schema.SObjectField field, ApexTypesEnum.StringType type)` | Plucks strings or ids on `field` into a new list |

### Important notes on the type system in Apex
<a name="type-system"></a>

Apex allows assignment of `SObject` collection to its “subclass”, and the other way around:

```java
List<SObject> objects = new List<SObject>();
List<Account> accounts = objects; // compiles!

List<Account> accounts = new List<Account>();
List<SObject> objects = accounts; // compiles as well!
```

An `SObject` list is an instance of any `SObject` “subclass” list!

```java
List<SObject> objects = new List<SObject>();
System.debug(objects instanceof List<Account>); // true
System.debug(objects instanceof List<Opportunity>); // true
```

Lambda classes usually return an `SObject` list, which can be then assigned to a specific `SObject` “subclass” list, like `Account`. This is more convenient, but `instanceof` can provide unexpected results:

```java
List<Account> accounts = Filter...
// accounts points to a List<SObject> returned from Filter

Boolean isOpportunities = accounts instanceof List<Opportunity>;
// isOpportunities is true!!!???
```

`Filter` and `GroupBy` therefore provide overloaded methods in which the concrete type of the list can be passed in as well. When this is done, the returned `List` or `Map` are of the correct concrete type instead of generic `SObject` collection type:

```java
List<Account> filteredAccounts = ApexLambda.filter(...).apply(allAccounts, List<Account>.class);
// List<Account> returned!
```

## Utilities
<a name="utilities"></a>

### `ApexString`
<a name="apex-string"></a>

`ApexString` is a case-insensitive `String`, which makes it possible to use collections which behave consistently with `==` operator on `String`.

```java
ApexString a = 'test';
ApexString b = 'tEsT';
Boolean isOperatorEqual = a == b; // true
Boolean isEqualsEqual = a.equals(b); // *true*, unlike regular String

Set<ApexString> stringSet = new Set<ApexString>();
stringSet.add(a);
stringSet.add(b);

System.assertEquals(1, stringSet.size()); // contains just a *single* case-insensitive element, unlike regular String!
System.assert(stringSet.contains(a)); // true
System.assert(stringSet.contains(b)); // true
```

| Modifier and type | Method | Description |
|-------------------|--------|-------------|
| `static ApexString` | `of(String str)` | Returns a case-insensitive `ApexString` |
| `static List<ApexString>` | `listOf(Iterable<String> strings)` | Returns a `List<ApexString>` which contains all strings from provided iterable |
| `static List<ApexString>` | `listOf(Set<String> strings)` | Returns a `List<ApexString>` which contains all strings from provided set |
| `static Set<ApexString>` | `setOf(Iterable<String> strings)` | Returns a `Set<ApexString>` which contains all strings from provided iterable |
| `static Set<ApexString>` | `setOf(Set<String> strings)` | Returns a `Set<ApexString>` which contains all strings from provided set |
| `static String` | `join(Iterable<ApexString> strings, String separator)` | Joins the `strings` with `separator` and returns the resulting `String` |
| `static String` | `join(Set<ApexString> strings, String separator)` | Joins the `strings` with `separator` and returns the resulting `String` |

#### Warning :warning:

`System.String.join` does not use the `toString` method on objects it is joining. All `ApexString` instances are therefore stringified to `'ApexString'` before they are joined into the final string (for example `'ApexString,ApexString,ApexString'`). To join collections of `ApexString`, use `ApexString.join` instead.

### `Optional`
<a name="optional"></a>

`Optional` simplifies operations with values which can be `null`.

| Modifier and type | Method | Description |
|-------------------|--------|-------------|
| `static Optional` | `of(Object value)` | Returns an `Optional` that wraps the provided value if it’s non-null. Throws a `LambdaException` exception otherwise |
| `static Optional` | `ofNullable(Object value)` | Returns an `Optional` that wraps the provided value if it’s non-null. Returns an empty `Optional` otherwise |
| `static Optional` | `empty()` | Returns an empty `Optional` |
| `Object` | `get()` | Returns a value if it’s present. Throws a `LambdaException` otherwise |
| `Boolean` | `isPresent()` | Returns whether the value is present.
| `Object` | `orElse(Object other)` | Returns the value if it’s present, and provided `other` otherwise |
