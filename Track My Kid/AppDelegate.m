//
//  AppDelegate.m
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "FirstTimeWelcomeViewController.h"
#import "KidHomeViewController.h"
#import "ParentHomeViewController.h"
#import "PersistentApplicationData.h"
#import "SingleAppDataObject.h"
#import "Utility.h"

#import <DropboxSDK/DropboxSDK.h>

@interface AppDelegate () <DBSessionDelegate>

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController;
@synthesize dropBoxUserId;
@synthesize persistentApplicationData;
@synthesize theAppDataObject;

- (id) init;
{
	self.theAppDataObject = [[SingleAppDataObject alloc] init];
	return [super init];
}

#pragma mark - 
#pragma mark Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Override point for customization after application launch.

    /*
     * Initialize DropBox session
     */
    
    // Set these variables before launching the app
    NSString* appKey = @"c8wujfmsu21fd47";
	NSString* appSecret = @"g3lcg4ack6ehzux";
	NSString *root = kDBRootAppFolder; // Should be set to either kDBRootAppFolder or kDBRootDropbox
    
	DBSession* dbSession = [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root];
	dbSession.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
	[DBSession setSharedSession:dbSession];
	//[dbSession release];
	
    BOOL isLinked = [[DBSession sharedSession] isLinked];
    
    D2Log(@"here 5");

    // If drop box is not linked, then show first time welcome page
    if(!isLinked)
    {
        D2Log(@"first time");
        FirstTimeWelcomeViewController *first = [[FirstTimeWelcomeViewController alloc] init]; 
        self.navController = [[UINavigationController alloc] initWithRootViewController:first]; 
    }
    else
    {
        D2Log(@"here 6");
        persistentApplicationData = [Utility readFromArchive];
        D2Log(@"here 7");
        if(persistentApplicationData == nil)
        {
            D2Log(@"cAD is null");
            persistentApplicationData = [[PersistentApplicationData alloc] init];
            
            // If no custom application data is found, then show first time welcome page
            FirstTimeWelcomeViewController *first = [[FirstTimeWelcomeViewController alloc] init]; 
            self.navController = [[UINavigationController alloc] initWithRootViewController:first];             
        }
        else
        {
            D2Log(@"cAD is not null");
            D2Log(@"cAD: %d %d %@", persistentApplicationData.version, persistentApplicationData.kidOrParent, persistentApplicationData.personName);

            if (persistentApplicationData.kidOrParent == kKidKeyValue)
            {
                // If custom application data has kid value, then show kid home page
                KidHomeViewController *kidHome = [[KidHomeViewController alloc] init]; 
                self.navController = [[UINavigationController alloc] initWithRootViewController:kidHome]; 
            }
            else if (persistentApplicationData.kidOrParent == kParentKeyValue)
            {
                // If custom application data has parent value, then show parent home page
                ParentHomeViewController *parentHome = [[ParentHomeViewController alloc] init]; 
                self.navController = [[UINavigationController alloc] initWithRootViewController:parentHome]; 
            }
            else
            {
                // If custom application data doesn't have valid value for kid or parent, then show first time welcome page
                FirstTimeWelcomeViewController *first = [[FirstTimeWelcomeViewController alloc] init]; 
                self.navController = [[UINavigationController alloc] initWithRootViewController:first];                             
            }
        }
    }

    [self.window addSubview:navController.view];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    D2Log(@"will resign active");
    [Utility storeIntoArchive:persistentApplicationData];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
	NSLog(@"In handleOpenURL");
    
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}

#pragma mark -
#pragma mark DBSessionDelegate methods

- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session userId:(NSString *)userId 
{
	NSLog(@"In sessionDidReceiveAuthorizationFailure!");
    
	dropBoxUserId = userId;
    
	UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:@"Dropbox Session Ended" 
                              message:@"Do you want to relink?" 
                              delegate:self 
                              cancelButtonTitle:@"Cancel" 
                              otherButtonTitles:@"Relink", nil];
    [alertView show];
}


#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index
{
	NSLog(@"In clickedButtonAtIndex!");
    
    //[self.navController popToViewController:<#(UIViewController *)#> animated:YES];

	if (index != alertView.cancelButtonIndex)
    {
		[[DBSession sharedSession] linkUserId:dropBoxUserId];
	}
}


@end
