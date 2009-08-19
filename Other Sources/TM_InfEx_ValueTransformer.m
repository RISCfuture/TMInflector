#import "TM_InfEx_ValueTransformer.h"

@implementation TM_InfEx_ValueTransformer

- (id) init {
	if (self = [super init]) {
		[NSValueTransformer setValueTransformer:self forName:@"TMExample"];
	}
	return self;
}

#pragma mark Value transformer

/*
 This transformer converts between NSStrings.
 */

+ (Class) transformedValueClass {
	return [NSString class];
}

/*
 This is a one-directional transformer.
 */

+ (BOOL) allowsReverseTransformation {
	return NO;
}

/*
 Splits a string on the delimiter to form an array.
 */

- (id) transformedValue:(id)value {
	NSString *string = (NSString *)value;
	switch ([popup indexOfSelectedItem]) {
		case 0: return [string pluralize];
		case 1: return [string singularize];
		case 2: return [string camelize];
		case 3: return [string camelize:NO];
		case 4: return [string titleize];
		case 5: return [string underscore];
		case 6: return [string dasherize];
		case 7: return [string demodulize];
		case 8: return [string parameterize];
		case 9: return [string parameterizeWithSeparator:@"_"];
		case 10: return [string tableize];
		case 11: return [string classify];
		case 12: return [string humanize];
		case 13: return [string foreignKey];
		case 14: return [string foreignKeySeparatingWithUnderscore:NO];
		default: return string;
	}
}

@end
