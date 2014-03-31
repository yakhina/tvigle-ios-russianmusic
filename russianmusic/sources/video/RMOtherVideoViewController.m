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
    NSString *title = self.isArtistList ? [NSString stringWithFormat:@"ДРУГИЕ КЛИПЫ %@", [self.nextPlaylistData objectForKey:@"title"]] : @"ДРУГИЕ КЛИПЫ СБОРНИКА";
    return section == 1 ? title : @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 1 ? 80 : 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 1 ? self.videosData.count : 1;
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
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = [video objectForKey:@"name"];
        cell.detailTextLabel.text = [[video objectForKey:@"artist"] capitalizedString];
        
        return cell;
    }
    
    else if (indexPath.section == 1)
    {
        RMVideoCell *cell;
        
        static NSString *CellIdentifier = @"VideoCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        NSDictionary *video = self.videosData[indexPath.row];
        
        if (cell == nil)
        {
            cell = [[RMVideoCell alloc] init];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.videoName.text = [video objectForKey:@"name"];
        cell.artistName.text = [(NSString *)[video objectForKey:@"artist"] capitalizedString];
        [cell.screenshot setImageWithURL:[NSURL URLWithString:[video objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"empty_artist"]];
        
        cell.layer.borderColor = [UIColor clearColor].CGColor;
        
        if (indexPath.row == 0)
        {
            cell.layer.borderColor = [UIColor colorWithRed:53/255 green:123/255 blue:255/255 alpha:1.0].CGColor;
            cell.layer.borderWidth = 2.0;
        }
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier3 = @"VideoButtonCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier3];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (self.isArtistList)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"Еще от %@", [self.nextPlaylistData objectForKey:@"title"]] ;
            cell.detailTextLabel.text = @"Сборник «Романтика»";
        }
        else
        {
            cell.textLabel.text = @"К следующему сборнику";
            cell.detailTextLabel.text = @"«Романтика»";
        }
        
        return cell;
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.section != 1)
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
