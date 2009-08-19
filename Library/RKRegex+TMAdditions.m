static RKRegex *reservedCharacters = NULL;

@implementation RKRegex (TMAdditions)

+ (NSString *) escapedStringForRegex:(NSString *)string {
	if (!reservedCharacters)
		reservedCharacters = [[RKRegex alloc] initWithRegexString:@"[\\\\\\^$.\\[|()?*+{}]" options:RKCompileNoOptions];
	
	return [string stringByMatching:reservedCharacters replace:RKReplaceAll withReferenceString:@"`\\$1"];
}

+ (NSString *) escapedSubpatternReferenceString:(NSString *)string {
	NSMutableString *result = [NSMutableString stringWithString:result];
	[result replaceOccurrencesOfString:@"$" withString:@"$$" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	return result;
}

@end
