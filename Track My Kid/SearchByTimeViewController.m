//
//  SearchByTimeViewController.m
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchByTimeViewController.h"
#import "Utility.h"
#import "ListLocationByTimeViewController.h"

@implementation SearchByTimeViewController

@synthesize timeSliceArr;

- (void)viewDidLoad
{ 
    [super viewDidLoad]; 
    self.title = @"View By Time"; 
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"Past Hour", @"Past 2 Hours", @"Past 4 Hours", @"Past 8 Hours", @"Past 24 Hours", nil];
    self.timeSliceArr = arr;
} 

- (void)viewDidUnload
{ 
    [super viewDidUnload]; 
} 

#pragma mark - 
#pragma mark Table Data Source Methods 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.timeSliceArr count]; 
} 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{     
    static NSString *SearchByTimeCell = @"SearchByTimeCell"; 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchByTimeCell]; 
    if (cell == nil) 
    { 
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier: SearchByTimeCell]; 
    } 
    
    // Configure the cell 
    NSUInteger row = [indexPath row]; 
    NSString* timeName = [self.timeSliceArr objectAtIndex:row]; 
    cell.textLabel.text = timeName;
    //    cell.imageView.image = controller.rowImage; 
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
    
    return cell; 
} 

#pragma mark - 
#pragma mark Table View Delegate Methods 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    NSUInteger row = [indexPath row];
    if(row == 0)
    {
        [Utility theAppDataObject].forParentSelectedPastHours = 1;
    }
    else if(row == 1)
    {
        [Utility theAppDataObject].forParentSelectedPastHours = 2;
    }
    else if(row == 2)
    {
        [Utility theAppDataObject].forParentSelectedPastHours = 4;
    }
    else if(row == 3)
    {
        [Utility theAppDataObject].forParentSelectedPastHours = 8;
    }
    else
    {
        [Utility theAppDataObject].forParentSelectedPastHours = 24;
    }
    
    D2Log(@"past hours %d", [Utility theAppDataObject].forParentSelectedPastHours);
    ListLocationByTimeViewController* nextController = [[ListLocationByTimeViewController alloc] init];
    [self.navigationController pushViewController:nextController animated:YES]; 
} 


@end
