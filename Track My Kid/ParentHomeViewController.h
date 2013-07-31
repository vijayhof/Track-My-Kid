//
//  ParentHomeViewController.h
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

#import "DropBoxUnlinkViewController.h"
#import "ListKidsViewController.h"
#import "Constants.h"
#import "Utility.h"

@interface ParentHomeViewController : UIViewController

@property (strong, nonatomic) DropBoxUnlinkViewController *dropBoxUnlinkViewController;
@property (strong, nonatomic) ListKidsViewController *listKidsViewController;

@property (strong, nonatomic) DBRestClient *restClient;

- (IBAction) doSetupPage:(id)sender; 
- (IBAction) doListKids:(id)sender;

- (void) listFilesFromDropBox;

@end
