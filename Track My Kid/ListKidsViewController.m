//
//  ListKidsViewController.m
//  Track My Kid
//
//  Created by Vijayant Palaiya on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListKidsViewController.h"
#import "Utility.h"
#import "SearchByTimeViewController.h"

@implementation ListKidsViewController

- (void)viewDidLoad
{ 
    [super viewDidLoad]; 
    self.title = @"Check On Kids"; 
} 

- (void)viewDidUnload
{ 
    [super viewDidUnload]; 
} 

#pragma mark - 
#pragma mark Table Data Source Methods 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
    return [[Utility theAppDataObject].forParentKidListArr count]; 
} 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{     
    static NSString *ListKidCell = @"ListKidCell"; 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListKidCell]; 
    if (cell == nil) 
    { 
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier: ListKidCell]; 
    } 

    // Configure the cell 
    NSUInteger row = [indexPath row]; 
    NSString* kidName = [[Utility theAppDataObject].forParentKidListArr objectAtIndex:row]; 
    cell.textLabel.text = kidName;
//    cell.imageView.image = controller.rowImage; 
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 

    return cell; 
} 

#pragma mark - 
#pragma mark Table View Delegate Methods 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    NSUInteger row = [indexPath row];
    [Utility theAppDataObject].forParentSelectedKid = [[Utility theAppDataObject].forParentKidListArr objectAtIndex:row];
    SearchByTimeViewController *nextController = [[SearchByTimeViewController alloc] init];
    [self.navigationController pushViewController:nextController animated:YES]; 
} 
@end
