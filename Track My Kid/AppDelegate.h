//
//  AppDelegate.h
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersistentApplicationData.h"
#import "AppDataObjectProtocol.h"

@class SingleAppDataObject;

@interface AppDelegate : UIResponder <UIApplicationDelegate, AppDataObjectProtocol>

@property (strong, atomic) SingleAppDataObject* theAppDataObject;

@property (strong, nonatomic) NSString *dropBoxUserId;
@property (strong, nonatomic) PersistentApplicationData *persistentApplicationData;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;

@end
