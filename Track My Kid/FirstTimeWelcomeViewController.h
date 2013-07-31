//
//  FirstTimeWelcomeViewController.h
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropBoxLinkViewController.h"

@class PersistentApplicationData, AppDelegate;

@interface FirstTimeWelcomeViewController : UIViewController

@property (strong, nonatomic) DropBoxLinkViewController *dropBoxLinkViewController;

- (IBAction) doSetupKids:(id)sender; 
- (IBAction) doSetupParents:(id)sender; 
- (IBAction) doMore:(id)sender; 

@end
