//
//  Utility.m
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"
#import "Constants.h"

@implementation Utility

#pragma mark - Custom Application Data Archive

//
// Get the path for the archive data file.
// Path is in Document directory, and under kCustomAppArchiveFilename folder.
//
// Returns the string with the path name
//
+ (NSString *)dataFilePath
{ 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    
    return [documentsDirectory stringByAppendingPathComponent:kCustomAppArchiveFilename]; 
}

//
// Store into persistent archive - path for which is determined by dataFilePath method above.
// Stores value for "version" and integer denoting "kid or parent"
// Version is taken from the constant value for kVersionKeyValue.
//
// Input: integer denoting kid or parent
//
+ (void)storeIntoArchive:(PersistentApplicationData *)persistentApplicationData
{     
    NSMutableData *data = [[NSMutableData alloc] init]; 
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] 
                                 initForWritingWithMutableData:data]; 
    [archiver encodeObject:persistentApplicationData forKey:kCustomAppDataKey]; 
    [archiver finishEncoding];
    
    [data writeToFile:[self dataFilePath] atomically:YES]; 
}

//
// Read data from persistent archive - path for which is determined by dataFilePath method above.
// Reads value for "version" and integer denoting "kid or parent".
//
// Input: integer denoting kid or parent
//
+ (PersistentApplicationData *)readFromArchive
{     
    
    NSData *data = [[NSMutableData alloc] 
                    initWithContentsOfFile:[self dataFilePath]]; 
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] 
                                     initForReadingWithData:data]; 
    PersistentApplicationData *persistentApplicationData = [unarchiver decodeObjectForKey:kCustomAppDataKey]; 
    [unarchiver finishDecoding]; 
    
    
    return persistentApplicationData;
}

# pragma misc
+ (AppDelegate*) sharedAppDelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

+ (SingleAppDataObject*) theAppDataObject
{
	id<AppDataObjectProtocol> theDelegate = (id<AppDataObjectProtocol>) [UIApplication sharedApplication].delegate;
	SingleAppDataObject* theDataObject;
	theDataObject = (SingleAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}

//
// Return the directory where we will store the data files
//
+ (NSString *)dataFileDirectory 
{
	// get document directory
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
}


@end
