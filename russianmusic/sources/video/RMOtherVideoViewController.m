//
//  RMOtherVideoViewController.m
//  Tvigle Music
//
//  Created by Elena Yakhina on 27/02/14.
//  Copyright (c) 2014 tvigle. All rights reserved.
//

#import "RMOtherVideoViewController.h"
#import "RMVideoCell.h"
#import "UIImageView+WebCache.h"

@interface RMOtherVideoViewController ()

@end

@implementation RMOtherVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"videos" ofType:@"plist"];
    
    self.videosData = [[[NSArray alloc] initWithContentsOfFile:filePath] mutableCopy];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? @"" : @"ДРУГИЕ КЛИПЫ СБОРНИКА";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 50 : 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : self.videosData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        static NSString *CellIdentifier2 = @"VideoNameCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier2];
        }
        
        NSDictionary *video = self.videosData[indexPath.row];
        
        cell.textLabel.text = [video objectForKey:@"name"];
        cell.detailTextLabel.text = [[video objectForKey:@"artist"] capitalizedString];
        
        return cell;
    }
    
    else
    {
        RMVideoCell *cell;
        
        static NSString *CellIdentifier = @"VideoCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        NSDictionary *video = self.videosData[indexPath.row];
        
        if (cell == nil)
        {
            cell = [[RMVideoCell alloc] init];
        }
        
        cell.videoName.text = [video objectForKey:@"name"];
        cell.artistName.text = [(NSString *)[video objectForKey:@"artist"] capitalizedString];
        [cell.screenshot setImageWithURL:[NSURL URLWithString:[video objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"empty_artist"]];
        
        return cell;
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return NO;
    }
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.videosData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
