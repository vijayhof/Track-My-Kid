//
//  KidHomeViewController.m
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KidHomeViewController.h"
#import "Utility.h"

@interface KidHomeViewController () <DBRestClientDelegate>

@end


@implementation KidHomeViewController

@synthesize dropBoxUnlinkViewController;
@synthesize locationManager;
@synthesize startingPoint;
@synthesize restClient;
@synthesize currentFilePath;

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
    
    // Unink DropBox Controller 
    if(self.dropBoxUnlinkViewController == nil)
    {
        self.dropBoxUnlinkViewController = [[DropBoxUnlinkViewController alloc] init]; 
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // TODO - clean up in all the classes
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

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
	// TODO - look at this logic later
	if (startingPoint == nil)
    {
		self.startingPoint = newLocation;
	}
    
	//NSString *latitudeString = [[NSString alloc] initWithFormat:@"%g\u00B0",
	//							newLocation.coordinate.latitude];
	//latitudeLabel.text = latitudeString;
	
	//NSString *longitudeString = [[NSString alloc] initWithFormat:@"%g\u00B0",
	//							 newLocation.coordinate.longitude];
	//longitudeLabel.text = longitudeString;
	
	//NSString *horizontalAccuracyString = [[NSString alloc]
	//									  initWithFormat:@"%gm",
	//									  newLocation.horizontalAccuracy];
	//horizontalAccuracyLabel.text = horizontalAccuracyString;
	
	//NSString *altitudeString = [[NSString alloc] initWithFormat:@"%gm",
	//							newLocation.altitude];
	//altitudeLabel.text = altitudeString;
	
	//NSString *verticalAccuracyString = [[NSString alloc]
	//									initWithFormat:@"%gm",
	//									newLocation.verticalAccuracy];
	//verticalAccuracyLabel.text = verticalAccuracyString;
	
	//CLLocationDistance distance = [newLocation
	//							   distanceFromLocation:startingPoint];
	//NSString *distanceString = [[NSString alloc]
	//							initWithFormat:@"%gm", distance];
	//distanceTraveledLabel.text = distanceString;
	
	NSString* dataStr = [[NSString alloc] initWithFormat:@"lat=%g, lon=%g, time=%f\n", 
                         newLocation.coordinate.latitude, 
                         newLocation.coordinate.longitude,
                         [[NSDate date] timeIntervalSince1970]];
	DLog(@"Getting location: %@", dataStr);
	
	[self customWriteToFile:dataStr];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
	
    NSString *errorType = (error.code == kCLErrorDenied) ?  @"Access Denied" : @"Unknown Error";
    UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Error getting Location"
						  message:errorType
						  delegate:nil
						  cancelButtonTitle:@"Okay"
						  otherButtonTitles:nil];
    [alert show];
}	

#pragma mark -
#pragma mark File Utility Methods


//
// Get the data file including the directory and file name, based on current yy/mm/dd/hh/min
//
- (NSString *)dataFilePath 
{
    // get the directory where to store the daa file
	NSString *documentsDirectory = [Utility dataFileDirectory];
	
	// get date based string with date format of yyyy_mm_dd for directory name
	NSDateFormatter *yymmddFormatter = [[NSDateFormatter alloc] init];
	[yymmddFormatter setDateFormat:kDropBoxDirNameDateFormat];
    
	// get date based string with date format of yyyy_mm_dd for directory name
	NSDateFormatter *hhmmFormatter = [[NSDateFormatter alloc] init];
	[hhmmFormatter setDateFormat:kDropBoxFileNameDateFormat];
    
	NSDate* currentDate = [NSDate date];
	NSString* dirStr = [yymmddFormatter stringFromDate:currentDate];
	NSString* fileStr = [hhmmFormatter stringFromDate:currentDate];
    
	D2Log(@"date string: %@, %@", dirStr, fileStr);

    // prepare dir path
	NSString* dirPath = [[NSString	alloc] initWithFormat:@"%@", dirStr];
	D2Log(@"dir name string %@. take 1", dirPath);
	dirPath = [documentsDirectory stringByAppendingPathComponent:dirPath];
	D2Log(@"dir name string %@. take 2", dirPath);

	// prepare file path
	NSString* filePath = [[NSString	alloc] initWithFormat:@"%@/%@_%@.txt", dirStr, kLocationFilename, fileStr];
	D2Log(@"file name string %@. take 1", filePath);
	filePath = [documentsDirectory stringByAppendingPathComponent:filePath];
	D2Log(@"file name string %@. take 2", filePath);

    // if dir doesn't exist, create it
	NSFileManager* fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:dirPath])
	{
		BOOL success = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
		if(!success)
		{
			DLog(@"Error occurred while creating dir %@", dirPath);
			return nil;
		}
	}
	

	// if file doesn't exist, create it
	if (![fileManager fileExistsAtPath:filePath])
	{
		BOOL success = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
		if(!success)
		{
			DLog(@"Error occurred while creating file %@", filePath);
			return nil;
		}
	}
	
	// return file name along with path
	return filePath;
}

//
// Get the data file including the directory and file name, based on current yy/mm/dd/hh/min
//
// Input: nsData: NSData that contains data that needs to be written into data file
// Output: BOOL based on success or failure of writing the data into the file
//
- (BOOL) customWriteToFile:(NSString *) strData
{
	// if no data to write, return
	if(!strData)
	{
		return NO;
	}
	
	// convert string to data
	NSData* nsData = [strData dataUsingEncoding:NSUTF8StringEncoding];
	
	// get the data file to write into. return if the file path is not valid
	NSString* filePath = [self dataFilePath];
	if(!filePath)
	{
		D2Log(@"Error occurred while writing data: filePath %@ is nil", filePath);
		return NO;
	}
	
	// append data at the very end of the file
	NSFileHandle *myHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
	[myHandle seekToEndOfFile];
	[myHandle writeData:nsData];
	[myHandle closeFile];
    
    // get last successful drop box successful date and time
    //NSDate* lastUploadDateTime = [Utility theAppDataObject].forKidLastSuccessfulUploadDateTime;
    //NSTimeInterval diffTime = 0;
    //
    //if(lastUploadDateTime != nil)
    //{
    //    diffTime = [lastUploadDateTime timeIntervalSinceNow]; 
    //}
    //else
    //{
    //    diffTime = kDropBoxFileUploadInterval; 
    //}
    //
    // TODO - new logic, that was considered to be implemented, but may have some issues, when uploading a file
    // that is still being written to
    // there are references of constants and member variables that may need to be cleaned up, if this is not implemented.
    // if last upload was done quite some time back, upload the latest files
    // if(diffTime >= kDropBoxFileUploadInterval)

	// if the filePath has changed due to change in time, upload the previous file
	if(![filePath isEqualToString:currentFilePath])
	{
        // update the current file path due to new file
        currentFilePath = filePath;

        DLog(@"Uploading file(s) %@", filePath);
		[self uploadToDropBox];
	}
    
    
	return YES;
}

#pragma mark -
#pragma mark DBRestClientDelegate Methods
- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath metadata:(DBMetadata*)metadata 
{
	
    D2Log(@"File uploaded successfully to path: %@, from path: %@", metadata.path, srcPath);
	
    [Utility theAppDataObject].forKidLastSuccessfulUploadDateTime = [NSDate date];
    
	// after successful upload, delete the file
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* errorObj;
	BOOL success = [fileManager removeItemAtPath:srcPath error:&errorObj];
	if(!success)
	{
		D2Log(@"Error occurred while deleting file %@", srcPath);
	}
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error 
{
    D2Log(@"File upload failed with error - %@", error);
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

- (void) uploadToDropBox
{
    // get the kid name
    NSString* kidName = [Utility sharedAppDelegate].persistentApplicationData.personName;
    
	// initialize local directory and destination directory
	NSString *localDir = [Utility dataFileDirectory];
	NSString *destDir = [[NSString alloc] initWithFormat:@"/%@/%@", kDropBoxKidDirectory, kidName];
    D2Log(@"uploadToDropBox: destDir=%@", destDir);
    
	NSFileManager *localFileManager=[[NSFileManager alloc] init];
    
	// go thru all files in localDir and upload to dropbox
	NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:localDir];
	NSString *file;
	while (file = [dirEnum nextObject]) 
	{
		if ([[file pathExtension] isEqualToString: @"txt"]) 
		{
			// upload to dropbox
			NSString* localFile = [localDir stringByAppendingPathComponent:file];
            
            DLog(@"Before Calling drop box upload: \n%@\n%@", localFile, [self currentFilePath]);

            if(![localFile isEqualToString:[self currentFilePath]])
            {
                D2Log(@"Calling drop box upload: %@ %@ %@", file, destDir, localFile);
                [[self restClient] uploadFile:file toPath:destDir withParentRev:nil fromPath:localFile];
                D2Log(@"Done calling drop box upload: %@ %@ %@", file, destDir, localFile);
            }
		}
	}
	
}


@end
