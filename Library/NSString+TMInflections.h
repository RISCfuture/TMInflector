#import "TMInflector.h"

@interface NSString (TMInflections)

- (NSString *) pluralize;
- (NSString *) singularize;
- (NSString *) camelize:(BOOL)uppercaseFirstLetter;
- (NSString *) camelize;
- (NSString *) titleize;
- (NSString *) underscore;
- (NSString *) dasherize;
- (NSString *) demodulize;
- (NSString *) parameterize;
- (NSString *) parameterizeWithSeparator:(NSString *)separator;
- (NSString *) tableize;
- (NSString *) classify;
- (NSString *) humanize;
- (NSString *) foreignKeySeparatingWithUnderscore:(BOOL)separate;
- (NSString *) foreignKey;
- (id) constantize;

- (BOOL) isBlank;

@end
