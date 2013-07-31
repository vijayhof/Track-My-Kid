//
//  ParentHomeViewController.m
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParentHomeViewController.h"

@interface ParentHomeViewController () <DBRestClientDelegate>

@end

@implementation ParentHomeViewController

@synthesize restClient;
@synthesize dropBoxUnlinkViewController;
@synthesize listKidsViewController;


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
    self.title = [[NSString alloc] initWithFormat:@"Welcome %@", [Utility sharedAppDelegate].persistentApplicationData.personName];
    
    // Unlink DropBox Controller 
    if(self.dropBoxUnlinkViewController == nil)
    {
        self.dropBoxUnlinkViewController = [[DropBoxUnlinkViewController alloc] init]; 
    }

    // List Kids Table View Controller 
    if(self.listKidsViewController == nil)
    {
        self.listKidsViewController = [[ListKidsViewController alloc] init]; 
    }
    
    // loads kids from dropbox
    [self listFilesFromDropBox];

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

#pragma mark - Actions

- (IBAction) doSetupPage:(id)sender
{
    [self.navigationController pushViewController:dropBoxUnlinkViewController animated:YES];
}

- (IBAction) doListKids:(id)sender
{
    if([[Utility theAppDataObject].forParentKidListArr count] == 1)
    {
        [self.navigationController pushViewController:listKidsViewController animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:listKidsViewController animated:YES];        
    }
}


#pragma mark -
#pragma mark DBRestClientDelegate Methods

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata
{
    if (metadata.isDirectory)
	{
        D2Log(@"Folder '%@' contains:", metadata.path);
		for (DBMetadata *file in metadata.contents)
		{
			D2Log(@"\t%@", file.filename);
            NSMutableArray* kidsArr = [Utility theAppDataObject].forParentKidListArr;
            [kidsArr addObject:(NSString*) file.filename];
		}
    }
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{	
    D2Log(@"Error loading metadata: %@", error);
}



#pragma mark -
#pragma mark DropBox Methods
- (DBRestClient *)restClient
{
	if (!restClient)
    {
		restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
		restClient.delegate = self;
	}
	return restClient;
}

- (void) listFilesFromDropBox
{
	D2Log(@"Calling drop box list files");
    NSString *kidFolder = [[NSString alloc] initWithFormat:@"/%@/", kDropBoxKidDirectory];
	[[self restClient] loadMetadata:kidFolder];
	D2Log(@"Done calling drop box list files");
}



@end
