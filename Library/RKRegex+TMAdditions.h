@interface RKRegex (TMAdditions)

+ (NSString *) escapedStringForRegex:(NSString *)string;
+ (NSString *) escapedSubpatternReferenceString:(NSString *)string;

@end
