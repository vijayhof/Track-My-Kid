//
//  PersistentApplicationData.h
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersistentApplicationData : NSObject <NSCoding, NSCopying>

@property (nonatomic) int version; 
@property (nonatomic) int kidOrParent; 
@property (strong,nonatomic) NSString* personName;

@end
