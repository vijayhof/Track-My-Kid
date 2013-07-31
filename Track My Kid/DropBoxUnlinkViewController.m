//
//  DropBoxUnlinkViewController.m
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <DropboxSDK/DropboxSDK.h>

#import "DropBoxUnlinkViewController.h"
#import "FirstTimeWelcomeViewController.h"

@implementation DropBoxUnlinkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)didPressDropBoxUnlink:(id)sender
{
    NSLog(@"In dP1: didPressDropBoxUnlink");
    
    // If DropBox is linked, then unlink
    if ([[DBSession sharedSession] isLinked]) 
    {
        NSLog(@"In dP4: Already linked. Unlink it");
        
        [[DBSession sharedSession] unlinkAll]; // TODO remove later

        // If here, then DropBox is unlinked
        UIAlertView *alertViewSuccess = [[UIAlertView alloc] 
                                         initWithTitle:@"Account unlinked!" 
                                         message:@"Your dropbox account has been unlinked" 
                                         delegate:nil 
                                         cancelButtonTitle:@"OK" 
                                         otherButtonTitles:nil];
        [alertViewSuccess show];
    }
    else
    {
        // If here, then DropBox is not linked. No need to unlink
        UIAlertView *alertViewSuccess = [[UIAlertView alloc] 
                                         initWithTitle:@"Account not linked!" 
                                         message:@"Your dropbox account has already been unlinked" 
                                         delegate:nil 
                                         cancelButtonTitle:@"OK" 
                                         otherButtonTitles:nil];
        [alertViewSuccess show];
    }

    FirstTimeWelcomeViewController * vc = [[FirstTimeWelcomeViewController alloc] init];
    NSArray *vcArr = [NSArray arrayWithObject:vc];
    [self.navigationController setViewControllers:vcArr];    
}


@end
