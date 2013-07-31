//
//  ListLocationByTimeViewController.m
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListLocationByTimeViewController.h"
#import "DDFileReader.h"
#import "LocationDataObject.h"

@interface ListLocationByTimeViewController () <DBRestClientDelegate>

@end

@implementation ListLocationByTimeViewController

@synthesize restClient;
@synthesize timeLocationData;
@synthesize keysArr;

- (void)viewDidLoad
{ 
    [super viewDidLoad];
    
    // initialize data structures
    
    self.timeLocationData = [[NSMutableDictionary alloc] init];
    NSArray *array = [[timeLocationData allKeys] sortedArrayUsingSelector:@selector(compare:)]; 
    self.keysArr = [[NSMutableArray alloc] initWithArray: array];
    
    self.title = [[NSString alloc] initWithFormat:@"Past %d hours", [Utility theAppDataObject].forParentSelectedPastHours];
    
    [self downloadKidFiles:[Utility theAppDataObject].forParentSelectedKid forTime:[Utility theAppDataObject].forParentSelectedPastHours];

} 

- (void)viewDidUnload
{ 
    [super viewDidUnload];
} 

#pragma mark - 
#pragma mark Table Data Source Methods 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{ 
    return [self.keysArr count]; 
} 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
    NSString *key = [self.keysArr objectAtIndex:section]; 
    NSArray *locationSection = [timeLocationData objectForKey:key]; 
    return [locationSection count]; 
} 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section]; 
    NSUInteger row = [indexPath row]; 
    
    NSString *key = [self.keysArr objectAtIndex:section]; 
    NSArray *locationSection = [self.timeLocationData objectForKey:key]; 
    
    static NSString *ListLocationByTimeCell = @"ListLocationByTimeCell"; 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListLocationByTimeCell]; 
    if (cell == nil) 
    { 
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier: ListLocationByTimeCell]; 
    } 
    
    // Configure the cell 
//    NSString* kidName = [[Utility theAppDataObject].forParentKidListArr objectAtIndex:row]; 
//    cell.textLabel.text = kidName;
    //    cell.imageView.image = controller.rowImage; 
    
    LocationDataObject* locationDataObject = [locationSection objectAtIndex:row];
    D2Log(@"locationobject %f %f %f", locationDataObject.lat, locationDataObject.lon, locationDataObject.timestamp);
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%.2f %.2f %f", locationDataObject.lat, locationDataObject.lon, locationDataObject.timestamp]; 
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
    
    return cell; 
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{ 
    NSString *key = [self.keysArr objectAtIndex:section]; 
    return key; 
} 

#pragma mark - 
#pragma mark Table View Delegate Methods 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ 
//    NSUInteger row = [indexPath row];
//    SearchByTimeViewController *nextController = [[SearchByTimeViewController alloc] init];
//    [self.navigationController pushViewController:nextController animated:YES]; 
} 


- (void) downloadKidFiles:(NSString*)kidName forTime:(int) timeInterval
{
    NSDate* currentDate = [NSDate date];

    // get date based string with date format of yyyy_mm_dd for directory name
    NSDateFormatter *yymmddFormatter = [[NSDateFormatter alloc] init];
    [yymmddFormatter setDateFormat:kDropBoxDirNameDateFormat];
    
    // get date based string with date format of yyyy_mm_dd for directory name
    NSDateFormatter *hhmmFormatter = [[NSDateFormatter alloc] init];
    [hhmmFormatter setDateFormat:kDropBoxFileNameDateFormat];
    
    D2Log(@"timeinterval %d", timeInterval);
    
    for (int i = 0; i < timeInterval; i = i+1)
    {
        D2Log(@"i %d", i);

        NSTimeInterval hourToProcess = -i;
        NSDate *tmpDate = [currentDate dateByAddingTimeInterval:hourToProcess*3600];
        D2Log(@"date time to process %@", tmpDate);
        
        NSString* dirStr = [yymmddFormatter stringFromDate:tmpDate];
        NSString* remoteDirName = [[NSString alloc] initWithFormat:@"/Kid/%@/%@", kidName, dirStr];
        D2Log(@"remote dir to download %@", remoteDirName);

        [self listFilesFromDropBox:remoteDirName];
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
            [self downloadFromDropBox:metadata.path fileName:file.filename];
		}
    }
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{	
    D2Log(@"Error loading metadata: %@", error);
}



- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath
{
    D2Log(@"File loaded into path: %@", localPath);
    [self customReadFromFile: localPath];
    [self.tableView reloadData];
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error
{
    D2Log(@"There was an error loading the file - %@", error);
}

//
// TODO - change this - Get the data file including the directory and file name, based on current yy/mm/dd/hh/min
//
// Input: 
// Output: 
//
- (BOOL) customReadFromFile:(NSString *) fileName
{
    D2Log(@"customReadFromFile: %@", fileName);
    
	// if invalid file name, return
	if(!fileName)
	{
        D2Log(@"Error occurred while reading from file: filePath %@ is nil", fileName);
		return NO;
	}
    
    NSMutableArray* minuteBasedLocationDataArr = [[NSMutableArray alloc] init];
    
    DDFileReader * reader = [[DDFileReader alloc] initWithFilePath:fileName];
    [reader enumerateLinesUsingBlock:^(NSString * line, BOOL * stop) {
        DLog(@"read line: %@", line);
        LocationDataObject* locationDataObj = [[LocationDataObject alloc] init];
        for(NSString *token in [line componentsSeparatedByString:@", "])
        {
            DLog(@"read token: %@", token);
            NSArray* keyValuePair = [token componentsSeparatedByString:@"="];
            DLog(@"read key: %@", [keyValuePair objectAtIndex:0]);
            DLog(@"read value: %@", [keyValuePair objectAtIndex:1]);
            if([[keyValuePair objectAtIndex:0] isEqualToString:@"lat"])
            {
                locationDataObj.lat = [[keyValuePair objectAtIndex:1] doubleValue];
            }
            else if([[keyValuePair objectAtIndex:0] isEqualToString:@"lon"])
            {
                locationDataObj.lon = [[keyValuePair objectAtIndex:1] doubleValue];
            }
            else if([[keyValuePair objectAtIndex:0] isEqualToString:@"time"])
            {
                locationDataObj.timestamp = [[keyValuePair objectAtIndex:1] intValue];
            }
            
        }
        
        [minuteBasedLocationDataArr addObject:locationDataObj];

    }];

    // if timeLocationData has not been initialized so far, then do it
    if(timeLocationData == NULL)
    {
        timeLocationData = [[NSMutableDictionary alloc] init];
    }
    
    // get time key for timeLocationData
    NSString* timeKey = [self parseForTimeKey:fileName];
    
    // store data into timeLocationData
    [timeLocationData setObject:minuteBasedLocationDataArr forKey:timeKey];
    NSArray *array = [[timeLocationData allKeys] sortedArrayUsingSelector:@selector(compare:)]; 
    self.keysArr = [[NSMutableArray alloc] initWithArray: array];

	return YES;
}

- (NSString*) parseForTimeKey:(NSString*) fileName
{
    D2Log(@"parseForTimeKey in: %@", fileName);

    NSArray* tokens = [fileName componentsSeparatedByString: @"/"];
    NSUInteger numToken = [tokens count];
    
    // ldata_<min>.txt
    NSString* minComp = [tokens objectAtIndex:(numToken - 1)];

    // scan minute value
    int minInt;
    NSScanner *theScanner = [NSScanner scannerWithString:minComp];
    [theScanner setScanLocation:([kLocationFilename length] + 1)]; // set it to ldata_ (including _)
    [theScanner scanInt:&minInt];
    D2Log(@"parseForTimeKey min value: %d", minInt);

    // <hh>
    NSString* hourComp = [tokens objectAtIndex:(numToken - 2)];
    
    // <yyyy_mm_dd>
    NSString* dateComp = [tokens objectAtIndex:(numToken - 3)];

    NSString* retStr = [[NSString alloc] initWithFormat:@"%@-%@:%d", dateComp, hourComp, minInt];

    D2Log(@"parseForTimeKey out: %@", retStr);
    
    return retStr;
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

- (void) listFilesFromDropBox:(NSString*)hourFolder
{
	D2Log(@"Calling drop box list files");
	[[self restClient] loadMetadata:hourFolder];
	D2Log(@"Done calling drop box list files");
}


- (void) downloadFromDropBox:(NSString *)remoteFilePath fileName:(NSString *) remoteFileName
{
    NSString *remoteFileQualifiedName = [[NSString alloc] initWithFormat:@"%@/%@", remoteFilePath, remoteFileName];

    NSString *localDirPath = [[NSString alloc] initWithFormat:@"%@/%@%@", [Utility dataFileDirectory], kDropBoxParentDirectory, remoteFilePath];
    NSString *localFileQualifiedName = [[NSString alloc] initWithFormat:@"%@/%@", localDirPath, remoteFileName];
    D2Log(@"downloadFromDropBox:localDirPath:%@", localDirPath);
    D2Log(@"downloadFromDropBox:localFileQualifiedName:%@", localFileQualifiedName);

    // if dir doesn't exist, create it
	NSFileManager* fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:localDirPath])
	{
		BOOL success = [fileManager createDirectoryAtPath:localDirPath withIntermediateDirectories:YES attributes:nil error:nil];
		if(!success)
		{
			DLog(@"Error occurred while creating dir %@", dirPath);
			return;
		}
	}
	

	D2Log(@"Calling drop box download");
	[[self restClient] loadFile:remoteFileQualifiedName intoPath:localFileQualifiedName];
	D2Log(@"Done calling drop box download");
}



@end
