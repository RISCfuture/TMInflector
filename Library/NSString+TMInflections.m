#import "NSString+TMInflections.h"

@implementation NSString (TMInflections)

- (NSString *) pluralize {
	return [[TMInflector inflector] pluralize:self];
}

- (NSString *) singularize {
	return [[TMInflector inflector] singularize:self];
}

- (NSString *) camelize:(BOOL)uppercaseFirstLetter {
	return [[TMInflector inflector] camelize:self uppercase:uppercaseFirstLetter];
}

- (NSString *) camelize {
	return [self camelize:YES];
}

- (NSString *) titleize {
	return [[TMInflector inflector] titleize:self];
}

- (NSString *) underscore {
	return [[TMInflector inflector] underscore:self];
}

- (NSString *) dasherize {
	return [[TMInflector inflector] dasherize:self];
}

- (NSString *) demodulize {
	return [[TMInflector inflector] demodulize:self];
}

- (NSString *) parameterizeWithSeparator:(NSString *)separator {
	return [[TMInflector inflector] parameterize:self separator:separator];
}

- (NSString *) parameterize {
	return [self parameterizeWithSeparator:@"-"];
}

- (NSString *) tableize {
	return [[TMInflector inflector] tableize:self];
}

- (NSString *) classify {
	return [[TMInflector inflector] classify:self];
}

- (NSString *) humanize {
	return [[TMInflector inflector] humanize:self];
}

- (NSString *) foreignKeySeparatingWithUnderscore:(BOOL)separate {
	return [[TMInflector inflector] pluralize:self];
}

- (NSString *) foreignKey {
	return [self foreignKeySeparatingWithUnderscore:YES];
}

- (id) constantize {
	return [[TMInflector inflector] pluralize:self];
}

- (BOOL) isBlank {
	NSUInteger index;
	for (index = 0; index != [self length]; index++)
		if (![[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:index]]) return NO;
	return YES;
}

@end
