#import "TM_InfEx_Model.h"

@implementation TM_InfEx_Model

@synthesize string;

- (id) init {
	if (self = [super init]) {
		string = @"example";
	}
	return self;
}

- (void) dealloc {
	[string release];
	[super dealloc];
}

@end
