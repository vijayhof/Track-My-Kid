//
//  DropBoxLinkViewController.m
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <DropboxSDK/DropboxSDK.h>

#import "DropBoxLinkViewController.h"
#import "KidHomeViewController.h"
#import "ParentHomeViewController.h"
#import "Utility.h"

@implementation DropBoxLinkViewController

@synthesize nameTextField;

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
    self.title = @"Link to DropBox";
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)nameTextFieldDoneEditing:(id)sender
{
     [sender resignFirstResponder];
}

- (IBAction)didPressDropBoxLink:(id)sender
{
    NSLog(@"In dP1: didPressDropBoxLink");

    NSString* nameStr = nameTextField.text;
    if([allTrim(nameStr) length] == 0)
    {
        UIAlertView *alertView1 = [[UIAlertView alloc] 
                                   initWithTitle:@"Choose a Name"
                                   message:@"Please enter name to link to DropBox" 
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [alertView1 show];
        return;
    }
        
    // If DropBox is already linked, then show popup, and go to proper KidHome or ParentHome page
    if ([[DBSession sharedSession] isLinked]) 
    {
        NSLog(@"In dP4: Already linked");
        
        // [[DBSession sharedSession] unlinkAll]; // TODO remove later
        
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"Account already linked!"
                                  message:@"Your dropbox account has already been linked" 
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        
    }
    else
    {
        // If here, then DropBox is not linked
        NSLog(@"In dP2: Not linked. Trying to link...");
        [[DBSession sharedSession] linkFromController:self];
        NSLog(@"In dP3: Seems to have linked.");
        
        // If here, then DropBox is linked
        UIAlertView *alertViewSuccess = [[UIAlertView alloc] 
                                         initWithTitle:@"Account linked!" 
                                         message:@"Your dropbox account has been linked" 
                                         delegate:nil 
                                         cancelButtonTitle:@"OK" 
                                         otherButtonTitles:nil];
        [alertViewSuccess show];
    }
    
    // store kid or parent name in the archive
    if([Utility sharedAppDelegate].persistentApplicationData.kidOrParent == kKidKeyValue)
    {
        [Utility sharedAppDelegate].persistentApplicationData.personName = nameStr;

        // go to kid home
        KidHomeViewController* vc = [[KidHomeViewController alloc] init];
        NSArray *vcArr = [NSArray arrayWithObject:vc];
        [self.navigationController setViewControllers:vcArr];
        
    }
    else if([Utility sharedAppDelegate].persistentApplicationData.kidOrParent == kParentKeyValue)
    {
        [Utility sharedAppDelegate].persistentApplicationData.personName = nameStr;

        // go to parent home
        ParentHomeViewController* vc = [[ParentHomeViewController alloc] init];
        NSArray *vcArr = [NSArray arrayWithObject:vc];
        [self.navigationController setViewControllers:vcArr];
        
    }

}



@end
