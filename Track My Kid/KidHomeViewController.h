//
//  KidHomeViewController.h
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <DropboxSDK/DropboxSDK.h>

#import "Constants.h"
#import "DropBoxUnlinkViewController.h"

@interface KidHomeViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) DropBoxUnlinkViewController *dropBoxUnlinkViewController;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation        *startingPoint;

@property (strong, nonatomic) DBRestClient *restClient;
@property (strong, nonatomic) NSString* currentFilePath;


- (IBAction) doSetupPage:(id)sender; 
- (void) uploadToDropBox;

- (BOOL) customWriteToFile:(NSString *) strData;

@end
