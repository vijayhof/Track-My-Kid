//
//  LocationDataObject.h
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationDataObject : NSObject

@property (nonatomic) CLLocationDegrees lat; 
@property (nonatomic) CLLocationDegrees lon; 
@property (nonatomic) NSTimeInterval    timestamp; 

@end
