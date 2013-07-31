//
//  ListLocationByTimeViewController.h
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>
#import "Constants.h"
#import "Utility.h"

@interface ListLocationByTimeViewController : UITableViewController

@property (strong, nonatomic) NSMutableDictionary *timeLocationData;
@property (strong, nonatomic) NSMutableArray *keysArr;

@property (strong, nonatomic) DBRestClient *restClient;

- (void) listFilesFromDropBox:(NSString*)hourFolder;
- (void) downloadKidFiles:(NSString*)kidName forTime:(int) timeInterval;
- (void) downloadFromDropBox:(NSString *)remoteFilePath fileName:(NSString *) remoteFileName;
- (BOOL) customReadFromFile:(NSString *) fileName;
- (NSString*) parseForTimeKey:(NSString*) fileName;

@end
