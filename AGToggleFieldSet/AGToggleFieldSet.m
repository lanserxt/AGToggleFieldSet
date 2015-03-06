//
//  AGToggleFieldSet.m
//  ToggleFieldSets
//
//  Created by Anton Gubarenko on 05.03.15.
//  Copyright (c) 2015 Anton Gubarenko. All rights reserved.
//

#import "AGToggleFieldSet.h"

const CGFloat separatorWidth = 40.0f;
static NSString *cellIdentifier = @"CellIdentifier";

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface AGToggleFieldSet () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) AGToggleTablesOrientation tablesOrientation;
@property (nonatomic) AGToggleButtonsPosition buttonsPosition;

@property (nonatomic, strong) NSMutableArray *innerLeftItems;
@property (nonatomic, strong) NSMutableArray *innerRightItems;

@property (nonatomic, strong) NSString *innerDescriptionField;
@end

@implementation AGToggleFieldSet

#pragma mark - View Lyfecycle

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initView];
}

- (void)initView
{
    [self addTables];
    self.innerLeftItems = [NSMutableArray arrayWithCapacity:0];
    self.innerRightItems = [NSMutableArray arrayWithCapacity:0];
    self.innerDescriptionField = @"description";
}

- (void)addTables
{
    self.leftTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.leftTable setAllowsMultipleSelection:YES];
    [self.leftTable setDataSource:self];
    [self.leftTable setDelegate:self];
    [self addSubview:self.leftTable];
    
    self.rightTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.rightTable setAllowsMultipleSelection:YES];
    [self.rightTable setDataSource:self];
    [self.rightTable setDelegate:self];
    [self addSubview:self.rightTable];
    
    self.separatorView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.separatorView];
    
    self.upArrowButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self addSubview:self.upArrowButton];
    [self.upArrowButton setTitle:@"⬆" forState:UIControlStateNormal];
    [self.upArrowButton addTarget:self action:@selector(upArrowAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.downArrowButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self addSubview:self.downArrowButton];
    [self.downArrowButton setTitle:@"⬇" forState:UIControlStateNormal];
    [self.downArrowButton addTarget:self action:@selector(downArrowAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)removeTables
{
    [self.leftTable removeFromSuperview];
    [self.rightTable removeFromSuperview];
    [self.separatorView removeFromSuperview];
}

- (void)layoutSubviews
{
    [self arrangeFrames];
}

- (void)arrangeFrames
{
    CGFloat tablesHeight = CGRectGetHeight(self.frame);
    CGFloat tablesWidth = CGRectGetWidth(self.frame);
    
    if( self.tablesOrientation == AGToggleTablesVertical)
    {
        tablesHeight -= separatorWidth;
        [self.leftTable setFrame:CGRectMake(0, 0, tablesWidth, tablesHeight/2.0)];
        [self.rightTable setFrame:CGRectMake(0, tablesHeight/2.0 + separatorWidth, tablesWidth, tablesHeight/2.0)];
        [self.separatorView setFrame:CGRectMake(0, tablesHeight/2.0, tablesWidth, separatorWidth)];
        
        if(self.buttonsPosition == AGToggleButtonsPositionOnSides)
        {
            [self.upArrowButton setFrame:CGRectMake(0, tablesHeight/2.0, separatorWidth, separatorWidth)];
            [self.downArrowButton setFrame:CGRectMake(tablesWidth - separatorWidth, tablesHeight/2.0, separatorWidth, separatorWidth)];
        }
        else
        {
            [self.upArrowButton setFrame:CGRectMake(tablesWidth/2.0 + (separatorWidth/2.0), tablesHeight/2.0, separatorWidth, separatorWidth)];
            [self.downArrowButton setFrame:CGRectMake(tablesWidth/2.0 - (separatorWidth*1.5), tablesHeight/2.0, separatorWidth, separatorWidth)];
        }
    }
    else
    {
        tablesWidth -= separatorWidth;
        [self.leftTable setFrame:CGRectMake(0, 0, tablesWidth/2.0, tablesHeight)];
        [self.rightTable setFrame:CGRectMake(tablesWidth/2.0 + separatorWidth, 0, tablesWidth/2.0, tablesHeight)];
        [self.separatorView setFrame:CGRectMake(tablesWidth/2.0, 0, separatorWidth, tablesHeight)];
        
        if(self.buttonsPosition == AGToggleButtonsPositionOnSides)
        {
            [self.upArrowButton setFrame:CGRectMake(tablesWidth/2.0, 0, separatorWidth, separatorWidth)];
            [self.upArrowButton setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90))];
            [self.downArrowButton setFrame:CGRectMake(tablesWidth/2.0, tablesHeight - separatorWidth, separatorWidth, separatorWidth)];
            [self.downArrowButton setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90))];
        }
        else
        {
            [self.upArrowButton setFrame:CGRectMake(tablesWidth/2.0, tablesHeight/2.0 - (separatorWidth * 1.5), separatorWidth, separatorWidth)];
            [self.upArrowButton setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90))];
            [self.downArrowButton setFrame:CGRectMake(tablesWidth/2.0, tablesHeight/2.0 + (separatorWidth/2.0), separatorWidth, separatorWidth)];
            [self.downArrowButton setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90))];
        }
    }
}

#pragma mark - Properties

- (void)setToggleTablesOrientation:(AGToggleTablesOrientation)orientation
{
    self.tablesOrientation = orientation;
    [self arrangeFrames];
}

- (void)setToggleButtonsPosition:(AGToggleButtonsPosition)position
{
    self.buttonsPosition = position;
    [self arrangeFrames];
}

- (void)setLeftItems:(NSArray*)leftItems
{
    self.innerLeftItems = [NSMutableArray arrayWithArray:leftItems];
    [self.leftTable reloadData];
}

- (void)setRightItems:(NSArray*)rightItems
{
    self.innerRightItems = [NSMutableArray arrayWithArray:rightItems];
    [self.rightTable reloadData];
}

- (void)setDescriptionField:(NSString*)descriptionString
{
    self.innerDescriptionField = [descriptionString copy];
    [self.leftTable reloadData];
    [self.rightTable reloadData];
}

- (NSArray*)leftItems
{
    return [self.innerLeftItems copy];
}

- (NSArray*)rightItems
{
    return [self.innerRightItems copy];
}

#pragma mark - Buttons Actions

- (void)upArrowAction:(id)upArrpwButton
{
    NSMutableArray *dataToInsert = [NSMutableArray arrayWithCapacity:[[self.rightTable indexPathsForSelectedRows] count]];
    NSMutableArray *indexesToInsert = [NSMutableArray arrayWithCapacity:[[self.rightTable indexPathsForSelectedRows] count]];
    NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet new];
    for (NSIndexPath *selectedPath in [self.rightTable indexPathsForSelectedRows])
    {
        [indexesToInsert addObject:[NSIndexPath indexPathForRow:[self.innerLeftItems count] + [dataToInsert count] inSection:0]];
        [dataToInsert addObject:[self.innerRightItems objectAtIndex:selectedPath.row]];
        [indexesToDelete addIndex:selectedPath.row];
    }
    
    if([dataToInsert count])
    {
        [self.innerRightItems removeObjectsAtIndexes:indexesToDelete];
        [self.rightTable deleteRowsAtIndexPaths: [self.rightTable indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.innerLeftItems addObjectsFromArray:dataToInsert];
        [self.leftTable insertRowsAtIndexPaths:indexesToInsert withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.delegate fieldDidToggle:self];
    }
    
    [self deselectAllLeftCells];
}

- (void)downArrowAction:(id)upArrpwButton
{
    NSMutableArray *dataToInsert = [NSMutableArray arrayWithCapacity:[[self.leftTable indexPathsForSelectedRows] count]];
    NSMutableArray *indexesToInsert = [NSMutableArray arrayWithCapacity:[[self.leftTable indexPathsForSelectedRows] count]];
     NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet new];
    for (NSIndexPath *selectedPath in [self.leftTable indexPathsForSelectedRows])
    {
        [indexesToInsert addObject:[NSIndexPath indexPathForRow:[self.innerRightItems count] + [dataToInsert count] inSection:0]];
        [dataToInsert addObject:[self.innerLeftItems objectAtIndex:selectedPath.row]];
        [indexesToDelete addIndex:selectedPath.row];
    }
    
    if([dataToInsert count])
    {
        [self.innerLeftItems removeObjectsAtIndexes:indexesToDelete];
        [self.leftTable deleteRowsAtIndexPaths: [self.leftTable indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.innerRightItems addObjectsFromArray:dataToInsert];
        [self.rightTable insertRowsAtIndexPaths:indexesToInsert withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.delegate fieldDidToggle:self];
    }
    
    [self deselectAllRightCells];
}

- (void)deselectAllRightCells
{
    if([[self.rightTable indexPathsForSelectedRows] count])
    {
        for (NSIndexPath *selectedPath in [self.rightTable indexPathsForSelectedRows])
        {
            [self.rightTable deselectRowAtIndexPath:selectedPath animated:NO];
        }
    }
}
- (void)deselectAllLeftCells
{
    if([[self.leftTable indexPathsForSelectedRows] count])
    {
        for (NSIndexPath *selectedPath in [self.leftTable indexPathsForSelectedRows])
        {
            [self.leftTable deselectRowAtIndexPath:selectedPath animated:NO];
        }
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView == self.leftTable ? [self.innerLeftItems count] : [self.innerRightItems count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    NSString *cellText = @"";
    
    if(tableView == self.leftTable)
    {
        cellText = [[self.innerLeftItems objectAtIndex:indexPath.row] isKindOfClass:[NSString class]] ? [self.innerLeftItems objectAtIndex:indexPath.row] : [[self.innerLeftItems objectAtIndex:indexPath.row] valueForKey:self.innerDescriptionField];
    }
    else
    {
        cellText = [[self.innerRightItems objectAtIndex:indexPath.row] isKindOfClass:[NSString class]] ? [self.innerRightItems objectAtIndex:indexPath.row] : [[self.innerRightItems objectAtIndex:indexPath.row] valueForKey:self.innerDescriptionField];
    }
    
    [cell.textLabel setText:cellText];
    
    return cell;
}

@end
