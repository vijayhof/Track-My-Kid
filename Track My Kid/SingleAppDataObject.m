//
//  SingleAppDataObject.m
//

#import "SingleAppDataObject.h"
#import "Constants.h"

@implementation SingleAppDataObject

@synthesize forParentKidListArr;
@synthesize forParentSelectedKid;
@synthesize forParentSelectedPastHours;
@synthesize forKidLastSuccessfulUploadDateTime;

- (id) init
{
	self.forParentKidListArr = [[NSMutableArray alloc] init];
	return [super init];
}

@end
