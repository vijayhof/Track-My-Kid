//
//  Utility.h
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistentApplicationData.h"
#import "SingleAppDataObject.h"
#import "AppDelegate.h"

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]


@interface Utility : NSObject

+ (void)storeIntoArchive:(PersistentApplicationData *) kidOrParent;
+ (PersistentApplicationData *)readFromArchive;
+ (AppDelegate*) sharedAppDelegate;
+ (SingleAppDataObject*) theAppDataObject;
+ (NSString *)dataFileDirectory;

@end
