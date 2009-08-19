#import "TMInflector.h"

static TMInflector *inflector = NULL;

@implementation TMInflector

#pragma mark Properties

@synthesize plurals;
@synthesize singulars;
@synthesize uncountables;
@synthesize humans;

#pragma mark Working with the singleton instance

+ (TMInflector *) inflector {
	@synchronized(self) {
		if (inflector == NULL) [[self alloc] init];
	}
	return inflector;
}

/*
 Ensures that someone else cannot directly allocate space for another instance.
 */

+ (id) allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (inflector == NULL) {
			inflector = [super allocWithZone:zone];
			return inflector;
		}
	}
	return NULL;
}

/*
 Ensures singleton status by disallowing copies.
 */

- (id) copyWithZone:(NSZone *)zone {
	return self;
}

/*
 Prevents this object from being retained.
 */

- (id) retain {
	return self;
}

/*
 Indicates that this object is not memory-managed.
 */

- (NSUInteger) retainCount {
	return NSUIntegerMax;
}

/*
 Prevents this object from being released.
 */

- (void) release {
	
}

/*
 Prevents this object from being added to an autorelease pool.
 */

- (id) autorelease {
	return self;
}

#pragma mark Initializing and deallocating

- (id) init {
	if (self = [super init]) {
		plurals = [[NSMutableArray alloc] init];
		singulars = [[NSMutableArray alloc] init];
		uncountables = [[NSMutableSet alloc] init];
		humans = [[NSMutableArray alloc] init];
		
		parameterRegexp = [[RKRegex alloc] initWithRegexString:@"[^a-z0-9\\-_\\+]+" options:RKCompileCaseless];
	}
	return self;
}

- (void) dealloc {
	[plurals release];
	[singulars release];
	[uncountables release];
	[humans release];
	
	[super dealloc];
}

#pragma mark Configuring the language

- (void) addPluralRule:(id)rule replacement:(NSString *)replacement {
	if ([rule isKindOfClass:[NSString class]]) [uncountables removeObject:rule];
	else if (![rule isKindOfClass:[RKRegex class]])
		[NSException raise:NSInvalidArgumentException format:@"addPluralRule:replacement: takes only NSString or RKRegex rules"];
	[uncountables removeObject:replacement];
	NSArray *pair = [[NSArray alloc] initWithObjects:rule, replacement, NULL];
	[plurals insertObject:pair atIndex:0];
	[pair release];
}

- (void) addSingularRule:(id)rule replacement:(NSString *)replacement {
	if ([rule isKindOfClass:[NSString class]]) [uncountables removeObject:rule];
	else if (![rule isKindOfClass:[RKRegex class]])
		[NSException raise:NSInvalidArgumentException format:@"addSingularRule:replacement: takes only NSString or RKRegex rules"];
	[uncountables removeObject:replacement];
	NSArray *pair = [[NSArray alloc] initWithObjects:rule, replacement, NULL];
	[singulars insertObject:pair atIndex:0];
	[pair release];
}

- (void) addIrregularRuleWithSingular:(NSString *)singular plural:(NSString *)plural {
	[uncountables removeObject:singular];
	[uncountables removeObject:plural];
	
	NSRange firstChar = NSMakeRange(0,1);
	NSString *singularFirstChar = [singular substringWithRange:firstChar];
	NSString *pluralFirstChar = [plural substringWithRange:firstChar];
	NSString *singularRestOfString = [singular substringFromIndex:1];
	NSString *pluralRestOfString = [plural substringFromIndex:1];
	
	if ([singularFirstChar localizedCaseInsensitiveCompare:pluralFirstChar] == NSOrderedSame) {
		NSString *ruleString = [[NSString alloc] initWithFormat:@"(%@)%@$", singularFirstChar, singularRestOfString];
		RKRegex *rule = [[RKRegex alloc] initWithRegexString:ruleString options:RKCompileCaseless];
		NSString *replacement = [[NSString alloc] initWithFormat:@"$1%@", pluralRestOfString];
		
		[self addPluralRule:rule replacement:replacement];
		[ruleString release];
		[rule release];
		[replacement release];
		
		ruleString = [[NSString alloc] initWithFormat:@"(%@)%@$", pluralFirstChar, pluralRestOfString];
		rule = [[RKRegex alloc] initWithRegexString:ruleString options:RKCompileCaseless];
		replacement = [[NSString alloc] initWithFormat:@"$1%@", singularRestOfString];
		
		[self addSingularRule:rule replacement:replacement];
		[ruleString release];
		[rule release];
		[replacement release];
	}
	else {
		NSString *singularFirstCharUp = [singularFirstChar uppercaseString];
		NSString *pluralFirstCharUp = [pluralFirstChar uppercaseString];
		NSString *singularFirstCharDown = [singularFirstChar lowercaseString];
		NSString *pluralFirstCharDown = [pluralFirstChar lowercaseString];
		
		NSString *ruleString = [[NSString alloc] initWithFormat:@"%@(?i)%@$", singularFirstCharUp, singularRestOfString];
		RKRegex *rule = [[RKRegex alloc] initWithRegexString:ruleString options:RKCompileNoOptions];
		NSString *replacement = [pluralFirstCharUp stringByAppendingString:pluralRestOfString];
		
		[self addPluralRule:rule replacement:replacement];
		[ruleString release];
		[rule release];
		
		ruleString = [[NSString alloc] initWithFormat:@"%@(?i)%@$", singularFirstCharDown, singularRestOfString];
		rule = [[RKRegex alloc] initWithRegexString:ruleString options:RKCompileNoOptions];
		replacement = [pluralFirstCharDown stringByAppendingString:pluralRestOfString];
		
		[self addPluralRule:rule replacement:replacement];
		[ruleString release];
		[rule release];
		
		ruleString = [[NSString alloc] initWithFormat:@"%@(?i)%@$", pluralFirstCharUp, pluralRestOfString];
		rule = [[RKRegex alloc] initWithRegexString:ruleString options:RKCompileNoOptions];
		replacement = [singularFirstCharUp stringByAppendingString:singularRestOfString];
		
		[self addSingularRule:rule replacement:replacement];
		[ruleString release];
		[rule release];
		
		ruleString = [[NSString alloc] initWithFormat:@"%@(?i)%@$", pluralFirstCharDown, pluralRestOfString];
		rule = [[RKRegex alloc] initWithRegexString:ruleString options:RKCompileNoOptions];
		replacement = [singularFirstCharDown stringByAppendingString:singularRestOfString];
		
		[self addSingularRule:rule replacement:replacement];
		[ruleString release];
		[rule release];
	}
}

- (void) addUncountableWord:(NSString *)word {
	[uncountables addObject:word];
}

- (void) addUncountableWords:(NSString *)firstWord, ... {
	va_list args;
	va_start(args, firstWord);
	for (NSString *word = firstWord; word != NULL; word = va_arg(args, NSString *))
		[self addUncountableWord:word];
	va_end(args);
}

- (void) addHumanRule:(id)rule replacement:(NSString *)replacement {
	if (![rule isKindOfClass:[RKRegex class]] && ![rule isKindOfClass:[NSString class]])
		[NSException raise:NSInvalidArgumentException format:@"addHumanRule:replacement: takes only NSString or RKRegex rules"];
	
	NSArray *pair = [[NSArray alloc] initWithObjects:rule, replacement, NULL];
	[humans insertObject:pair atIndex:0];
	[pair release];
}

#pragma mark Clearing the inflections database

- (void) clearAll {
	[plurals removeAllObjects];
	[singulars removeAllObjects];
	[uncountables removeAllObjects];
}

- (void) clearPlurals {
	[plurals removeAllObjects];
}

- (void) clearSingulars {
	[singulars removeAllObjects];
}

- (void) clearUncountables {
	[uncountables removeAllObjects];
}

- (void) clearHumans {
	[humans removeAllObjects];
}

#pragma mark Inflecting words

- (NSString *) pluralize:(NSString *)word {
	NSMutableString *result = [NSMutableString stringWithString:word];
	if ([word isBlank] || [uncountables containsObject:[word lowercaseString]]) return result;
	else {
		for (NSArray *pair in plurals) {
			id rule = [pair objectAtIndex:0];
			NSString *replacement = [pair objectAtIndex:1];
			if ([result match:rule replace:RKReplaceAll withString:replacement]) break;
		}
	}
	return result;
}

- (NSString *) singularize:(NSString *)word {
	NSMutableString *result = [NSMutableString stringWithString:word];
	if ([uncountables containsObject:[word lowercaseString]]) return result;
	else {
		for (NSArray *pair in singulars) {
			id rule = [pair objectAtIndex:0];
			NSString *replacement = [pair objectAtIndex:1];
			if ([result match:rule replace:RKReplaceAll withString:replacement]) break;
		}
	}
	return result;
}

- (NSString *) camelize:(NSString *)word uppercase:(BOOL)upperCase {
	if (upperCase) {
		NSMutableString *result = [NSMutableString stringWithString:word];
		[result match:@"/(.?)" replace:RKReplaceAll withString:@"::\\U$1\\E"];
		[result match:@"(?:^|_)(.)" replace:RKReplaceAll withString:@"\\U$1\\E"];
		return result;
	}
	else {
		return [[[word substringWithRange:NSMakeRange(0,1)] lowercaseString] stringByAppendingString:[[self camelize:word uppercase:YES] substringFromIndex:1]];
	}
}

- (NSString *) camelize:(NSString *)word {
	return [self camelize:word uppercase:YES];
}

- (NSString *) titleize:(NSString *)word {
	NSMutableString *result = [NSMutableString stringWithString:[self humanize:[self underscore:word]]];
	[result match:@"\\b('?[a-z])" replace:RKReplaceAll withString:@"\\U$1\\E"];
	return result;
}

- (NSString *) underscore:(NSString *)word {
	NSMutableString *result = [NSMutableString stringWithString:word];
	[result match:@"::" replace:RKReplaceAll withString:@"/"];
	[result match:@"([A-Z]+)([A-Z][a-z])" replace:RKReplaceAll withString:@"$1_$2"];
	[result match:@"([a-z\\d])([A-Z])" replace:RKReplaceAll withString:@"$1_$2"];
	[result replaceOccurrencesOfString:@"-" withString:@"_" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	return [result lowercaseString];
}

- (NSString *) dasherize:(NSString *)word {
	return [word stringByReplacingOccurrencesOfString:@"_" withString:@"-" options:NSLiteralSearch range:NSMakeRange(0, [word length])];
}

- (NSString *) humanize:(NSString *)word {
	NSMutableString *result = [NSMutableString stringWithString:word];
	for (NSArray *pair in humans) {
		id rule = [pair objectAtIndex:0];
		NSString *replacement = [pair objectAtIndex:1];
		if ([result match:rule replace:RKReplaceAll withString:replacement]) break;
	}
	[result match:@"_id$" replace:RKReplaceAll withString:@""];
	[result replaceOccurrencesOfString:@"_" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	return [result capitalizedString];
}

- (NSString *) demodulize:(NSString *)word {
	return [word stringByMatching:@"^.*::" replace:RKReplaceAll withReferenceString:@""];
}

- (NSString *) parameterize:(NSString *)word separator:(NSString *)separator {
	// replace accented chars with ther ascii equivalents
	NSMutableString *result = [NSMutableString stringWithString:[self transliterate:word]];
	// Turn unwanted chars into the seperator
	[result match:parameterRegexp replace:RKReplaceAll withString:separator];
	if (![separator isBlank]) {
		NSString *escapedSeparator = [RKRegex escapedStringForRegex:separator];
		NSString *referenceEscapedSeparator = [RKRegex escapedSubpatternReferenceString:separator];
		
		NSString *sepRegexStr = [[NSString alloc] initWithFormat:@"%@{2,}", escapedSeparator];
		RKRegex *sepRegex = [[RKRegex alloc] initWithRegexString:sepRegexStr options:RKCompileNoOptions];
		[result match:sepRegex replace:RKReplaceAll withString:referenceEscapedSeparator];
		[sepRegex release];
		[sepRegexStr release];
		
		sepRegexStr = [[NSString alloc] initWithFormat:@"^%@|%@$", escapedSeparator, escapedSeparator];
		sepRegex = [[RKRegex alloc] initWithRegexString:sepRegexStr options:RKCompileCaseless];
		[result match:sepRegex replace:RKReplaceAll withString:@""];
		[sepRegex release];
		[sepRegexStr release];
	}
	return [result lowercaseString];
}

- (NSString *) parameterize:(NSString *)word {
	return [self parameterize:word separator:@"-"];
}

- (NSString *) transliterate:(NSString *)string {
	return [string stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
}

- (NSString *) tableize:(NSString *)className {
	return [self pluralize:[self underscore:className]];
}

- (NSString *) classify:(NSString *)tableName {
	NSString *result = [tableName stringByMatching:@".*\\." replace:1 withReferenceString:@""];
	return [self camelize:[self singularize:result]];
}

- (NSString *) foreignKey:(NSString *)className separatingClassNameAndIDWithUnderscore:(BOOL)separate {
	return [[self underscore:[self demodulize:className]] stringByAppendingString:(separate ? @"_id" : @"id")];
}

- (id) constantize:(NSString *)name {
	Class klass = NSClassFromString(name);
	if (klass) return klass;
	Protocol *protocol = NSProtocolFromString(name);
	if (protocol) return protocol;
	return NULL;
}

- (NSString *) ordinalize:(NSInteger)number {
	if (number % 100 >= 11 && number % 100 <= 13) return [NSString stringWithFormat:@"%dth", number];
	else {
		switch (number % 10) {
			case 1:
				return [NSString stringWithFormat:@"%dst", number];
			case 2:
				return [NSString stringWithFormat:@"%dnd", number];
			case 3:
				return [NSString stringWithFormat:@"%drd", number];
			default:
				return [NSString stringWithFormat:@"%dth", number];
		}
	}
}

@end
