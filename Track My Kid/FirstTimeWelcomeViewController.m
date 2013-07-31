//
//  FirstTimeWelcomeViewController.m
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstTimeWelcomeViewController.h"
#import "Constants.h"
#import "Utility.h"


@implementation FirstTimeWelcomeViewController

@synthesize dropBoxLinkViewController;

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
    self.title = @"Welcome";

    // Kid Link DropBox Controller 
    if(self.dropBoxLinkViewController == nil)
    {
        self.dropBoxLinkViewController = [[DropBoxLinkViewController alloc] init]; 
    }
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

- (void)viewDidAppear:(BOOL)animated
{
}


#pragma mark - Actions

- (IBAction) doSetupKids:(id)sender
{
    [self.navigationController pushViewController:dropBoxLinkViewController animated:YES];

    [Utility sharedAppDelegate].persistentApplicationData.kidOrParent = kKidKeyValue;
    [Utility sharedAppDelegate].persistentApplicationData.personName = nil;
}

- (IBAction) doSetupParents:(id)sender
{
    [self.navigationController pushViewController:dropBoxLinkViewController animated:YES];

    [Utility sharedAppDelegate].persistentApplicationData.kidOrParent = kParentKeyValue;
    [Utility sharedAppDelegate].persistentApplicationData.personName = nil;
}

- (IBAction) doMore:(id)sender
{
    
}


@end
