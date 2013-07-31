//
//  SingleAppDataObject.h
//

#import <Foundation/Foundation.h>
#import "AppDataObject.h"


@interface SingleAppDataObject : AppDataObject 

// list/array of kids names. used in parent flow.
@property (strong,nonatomic) NSMutableArray* forParentKidListArr;

// name of the selected kid. used in parent flow.
@property (strong,nonatomic) NSString* forParentSelectedKid;

// selected time interval to look at kid's location data. used in parent flow.
@property int forParentSelectedPastHours;


// date time for last successful drop box upload. used in kid flow. // TODO - not currently used
@property (strong,nonatomic) NSDate* forKidLastSuccessfulUploadDateTime;

@end
