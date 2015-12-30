//
//  ViewController.m
//  ExpandableTableviewCells
//
//  Created by Haripal on 7/3/15.
//  Copyright (c) 2015 Organization Name. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
<UITableViewDataSource,
UITableViewDelegate>
{
    NSArray *cell0SubMenuItemsArray;
    
    BOOL isSection0Cell0Expanded;
}

@end

@implementation ViewController

@synthesize tblView;

# pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad]; 
    
    cell0SubMenuItemsArray = @[@"First Static Menu Item", @"Second Static Menu Item", @"Third Static Menu Item"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view setNeedsLayout];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

# pragma mark - UITableView Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        int cellCount = 2; // Default count - if not a single cell is expanded
        
        if (isSection0Cell0Expanded)
        {
            cellCount += [cell0SubMenuItemsArray count];
        }
        
        return cellCount;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCellId = @"CellId";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"Expandable Cell";
            
            UIImageView *accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width - 30, cell.frame.size.height / 2 - 15, 30, 30)];
            
            if (isSection0Cell0Expanded) // Set accessory view according to cell state - EXPANDED / NOT EXPANDED
            {
                accessoryImageView.image = [UIImage imageNamed:@"Minus.png"];
                cell.detailTextLabel.text = @"Status : Expanded";
            }
            else
            {
                accessoryImageView.image = [UIImage imageNamed:@"Plus.png"];
                cell.detailTextLabel.text = @"Status : Not Expanded";
            }
            
            [cell addSubview:accessoryImageView];
        }
        else
        {
            if (isSection0Cell0Expanded && [cell0SubMenuItemsArray count] >= indexPath.row) // Check Expanded status and do the necessary changes
            {
                cell.textLabel.text = [NSString stringWithFormat:@"%@", [cell0SubMenuItemsArray objectAtIndex:indexPath.row - 1]];
            }
            else
            {
                cell.textLabel.text = @"Static Cell";
            }
        }
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        // Change status of a cell reload table
        
        isSection0Cell0Expanded = !isSection0Cell0Expanded;
        
        if (isSection0Cell0Expanded)
        {
            NSArray *cells = [NSArray arrayWithObjects:
                              [NSIndexPath indexPathForRow:1 inSection:0],
                              [NSIndexPath indexPathForRow:2 inSection:0],
                              [NSIndexPath indexPathForRow:3 inSection:0],
                              nil];
            
            [CATransaction begin];
            
            [CATransaction setCompletionBlock:^{
                [tblView reloadData];
            }];
            
            [tblView beginUpdates];
            [tblView insertRowsAtIndexPaths:cells withRowAnimation:UITableViewRowAnimationFade];
            [tblView endUpdates];
            
            [CATransaction commit];
            
        }
        else
        {
            NSArray *cells = [NSArray arrayWithObjects:
                              [NSIndexPath indexPathForRow:1 inSection:0],
                              [NSIndexPath indexPathForRow:2 inSection:0],
                              [NSIndexPath indexPathForRow:3 inSection:0],
                              nil];
            
            [CATransaction begin];
            
            [CATransaction setCompletionBlock:^{
                [tblView reloadData];
            }];
            
            [tblView beginUpdates];
            [tblView deleteRowsAtIndexPaths:cells withRowAnimation:UITableViewRowAnimationFade];
            [tblView endUpdates];
            
            [CATransaction commit];
        }
    }
}

@end
