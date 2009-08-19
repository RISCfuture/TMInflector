@interface TMInflector : NSObject {
	@private
	NSMutableArray *plurals, *singulars, *humans;
	NSMutableSet *uncountables;
	RKRegex *parameterRegexp;
}

@property (readonly) NSMutableArray *plurals;
@property (readonly) NSMutableArray *singulars;
@property (readonly) NSMutableSet *uncountables;
@property (readonly) NSMutableArray *humans;

+ (TMInflector *) inflector;

- (void) addPluralRule:(id)rule replacement:(NSString *)replacement;
- (void) addSingularRule:(id)rule replacement:(NSString *)replacement;
- (void) addIrregularRuleWithSingular:(NSString *)singular plural:(NSString *)plural;
- (void) addUncountableWord:(NSString *)word;
- (void) addUncountableWords:(NSString *)firstWord, ... NS_REQUIRES_NIL_TERMINATION;
- (void) addHumanRule:(id)rule replacement:(NSString *)replacement;

- (void) clearAll;
- (void) clearSingulars;
- (void) clearPlurals;
- (void) clearUncountables;
- (void) clearHumans;

#pragma mark Inflecting words

- (NSString *) pluralize:(NSString *)word;
- (NSString *) singularize:(NSString *)word;
- (NSString *) camelize:(NSString *)word;
- (NSString *) camelize:(NSString *)word uppercase:(BOOL)upperCase;
- (NSString *) titleize:(NSString *)word;
- (NSString *) underscore:(NSString *)word;
- (NSString *) dasherize:(NSString *)word;
- (NSString *) humanize:(NSString *)word;
- (NSString *) demodulize:(NSString *)word;
- (NSString *) parameterize:(NSString *)word;
- (NSString *) parameterize:(NSString *)word separator:(NSString *)separator;
- (NSString *) transliterate:(NSString *)string;
- (NSString *) tableize:(NSString *)className;
- (NSString *) classify:(NSString *)tableName;
- (NSString *) foreignKey:(NSString *)className separatingClassNameAndIDWithUnderscore:(BOOL)separate;
- (id) constantize:(NSString *)name;
- (NSString *) ordinalize:(NSInteger)number;

@end
