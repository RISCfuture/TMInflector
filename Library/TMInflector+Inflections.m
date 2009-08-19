#import "TMInflector+Inflections.h"

@implementation TMInflector (Inflections)

+ (void) initialize {
	[self addPluralRules];
	[self addSingularRules];
	[self addIrregularRules];
	[self addUncountables];
}

+ (void) addPluralRules {
	RKRegex *rule;
	
	[[TMInflector inflector] addPluralRule:@"$" replacement:@"s"];
	
	rule = [[RKRegex alloc] initWithRegexString:@"s$" options:RKCompileCaseless];
	[[TMInflector inflector] addPluralRule:rule replacement:@"s"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(ax|test)is$" options:RKCompileCaseless];
	[[TMInflector inflector] addPluralRule:rule replacement:@"$1es"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(octop|vir)us$" options:RKCompileCaseless];
	[[TMInflector inflector] addPluralRule:rule replacement:@"$1i"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(alias|status)$" options:RKCompileCaseless];
	[[TMInflector inflector] addPluralRule:rule replacement:@"$1es"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(bu)s$" options:RKCompileCaseless];
	[[TMInflector inflector] addPluralRule:rule replacement:@"$1ses"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(buffal|tomat)o$" options:RKCompileCaseless];
	[[TMInflector inflector] addPluralRule:rule replacement:@"$1oes"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"([ti])um$" options:RKCompileCaseless];
	[[TMInflector inflector] addPluralRule:rule replacement:@"$1a"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"sis$" options:RKCompileCaseless];
	[[TMInflector inflector] addPluralRule:rule replacement:@"ses"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(?:([^f])fe|([lr])f)$" options:RKCompileCaseless];
	[[TMInflector inflector] addPluralRule:rule replacement:@"$1$2ves"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(hive)$" options:RKCompileCaseless];
	[[TMInflector inflector] addPluralRule:rule replacement:@"$1s"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"([^aeiouy]|qu)y$" options:RKCompileCaseless];
	[[TMInflector inflector] addPluralRule:rule replacement:@"$1ies"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(x|ch|ss|sh)$" options:RKCompileCaseless];
	[[TMInflector inflector] addPluralRule:rule replacement:@"$1es"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(matr|vert|ind)(?:ix|ex)$" options:RKCompileCaseless];
	[[TMInflector inflector] addPluralRule:rule replacement:@"$1ices"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"([m|l])ouse$" options:RKCompileCaseless];
	[[TMInflector inflector] addPluralRule:rule replacement:@"$1ice"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"^(ox)$" options:RKCompileCaseless];
	[[TMInflector inflector] addPluralRule:rule replacement:@"$1en"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(quiz)$" options:RKCompileCaseless];
	[[TMInflector inflector] addPluralRule:rule replacement:@"$1zes"];
	[rule release];
}

+ (void) addSingularRules {
	RKRegex *rule;
	
	rule = [[RKRegex alloc] initWithRegexString:@"s$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@""];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(n)ews$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1ews"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"([ti])a$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1um"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1$2sis"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(^analy)ses$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1sis"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"([^f])ves$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"\1fe"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(hive)s$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(tive)s$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"([lr])ves$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"\1f"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"([^aeiouy]|qu)ies$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1y"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(s)eries$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1eries"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(m)ovies$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1ovie"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(x|ch|ss|sh)es$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"([m|l])ice$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1ouse"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(bus)es$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(o)es$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(shoe)s$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(cris|ax|test)es$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1is"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(octop|vir)i$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1us"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(alias|status)es$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"^(ox)en" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(vert|ind)ices$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1ex"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(matr)ices$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1ix"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(quiz)zes$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1"];
	[rule release];
	
	rule = [[RKRegex alloc] initWithRegexString:@"(database)s$" options:RKCompileCaseless];
	[[TMInflector inflector] addSingularRule:rule replacement:@"$1"];
	[rule release];	
}

+ (void) addIrregularRules {
	[[TMInflector inflector] addIrregularRuleWithSingular:@"person" plural:@"people"];
	[[TMInflector inflector] addIrregularRuleWithSingular:@"man" plural:@"men"];
	[[TMInflector inflector] addIrregularRuleWithSingular:@"child" plural:@"children"];
	[[TMInflector inflector] addIrregularRuleWithSingular:@"sex" plural:@"sexes"];
	[[TMInflector inflector] addIrregularRuleWithSingular:@"move" plural:@"moves"];
	[[TMInflector inflector] addIrregularRuleWithSingular:@"cow" plural:@"kine"];
}

+ (void) addUncountables {
	[[TMInflector inflector] addUncountableWords:@"equipment", @"information", @"rice", @"money", @"species", @"series", @"fish", @"sheep", NULL];
}

@end
