//
//  DropBoxLinkViewController.h
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface DropBoxLinkViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

- (IBAction)nameTextFieldDoneEditing:(id)sender; 
- (IBAction)didPressDropBoxLink:(id)sender;

@end
