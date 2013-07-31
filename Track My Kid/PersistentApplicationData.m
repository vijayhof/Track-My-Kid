//
//  PersistentApplicationData.m
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PersistentApplicationData.h"

#define    kVersionKey        @"version" 
#define    kKidOrParentKey    @"kidOrParent" 
#define    kPersonNameKey     @"personName" 

@implementation PersistentApplicationData

@synthesize version;
@synthesize kidOrParent;
@synthesize personName;

#pragma mark NSCoding 
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInt:version forKey:kVersionKey]; 
    [encoder encodeInt:kidOrParent forKey:kKidOrParentKey]; 
    [encoder encodeObject:personName forKey:kPersonNameKey]; 
} 

- (id)initWithCoder:(NSCoder *)decoder
{ 
    if (self = [super init])
    { 
        version = [decoder decodeIntForKey:kVersionKey];
        kidOrParent = [decoder decodeIntForKey:kKidOrParentKey]; 
        personName = [decoder decodeObjectForKey:kPersonNameKey]; 
    }
    
    return self; 
} 

#pragma mark - 
#pragma mark NSCopying 
- (id)copyWithZone:(NSZone *)zone
{ 
    PersistentApplicationData *copy = [[[self class] allocWithZone:zone] init]; 
    copy.version = self.version;
    copy.kidOrParent = self.kidOrParent; 
    copy.personName = self.personName; 
    return copy; 
}

@end
