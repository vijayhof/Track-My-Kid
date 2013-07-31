//
//  Constants.h
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef DEBUG

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define D2Log(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


@interface Constants : NSObject

//
// Constants for custom application data stored in archive file
//

// name of the archive file which store custom application data
#define kCustomAppArchiveFilename    @"archive" 

// key of the root data (for custom application data) that is stored in the archive file
#define kCustomAppDataKey            @"Data" 

// version value that is stored in the custom application data
#define kVersionKeyValue             0

// whether it is kid or parent, value that is stored in the custom application data 
#define kKidKeyValue                 1
#define kParentKeyValue              2


//
// Drop box related, and file upload related constant
//

// prefix for the file name that contains the location data, uploaded for the kid
#define kLocationFilename            @"ldata"

// drop box kid directory name, where the files would be uploaded
#define kDropBoxKidDirectory         @"Kid"

// drop box parent directory name, where the files would be uploaded // TODO - not used currently
#define kDropBoxParentDirectory      @"Parent"

// file upload interval (in seconds)
#define kDropBoxFileUploadInterval   60

// file directory format
#define kDropBoxDirNameDateFormat    @"yyyy_MM_dd/HH"

// file name format
#define kDropBoxFileNameDateFormat   @"mm"

@end
