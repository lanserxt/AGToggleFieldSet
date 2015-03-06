//
//  AGToggleFieldSet.h
//  ToggleFieldSets
//
//  Created by Anton Gubarenko on 05.03.15.
//  Copyright (c) 2015 Anton Gubarenko. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    AGToggleTablesVertical = 0,
    AGToggleTablesHorizontal = 1
}AGToggleTablesOrientation;

typedef enum
{
    AGToggleButtonsPositionOnSides = 0,
    AGToggleButtonsPositionCentered = 1
}AGToggleButtonsPosition;

@protocol AGToggleFieldSetDelegate;

@interface AGToggleFieldSet : UIView

- (void)setToggleTablesOrientation:(AGToggleTablesOrientation)orientation;
- (void)setToggleButtonsPosition:(AGToggleButtonsPosition)position;

- (NSArray*)leftItems;
- (NSArray*)rightItems;

- (void)setLeftItems:(NSArray*)leftItems;
- (void)setRightItems:(NSArray*)rightItems;

@property (nonatomic, weak) id <AGToggleFieldSetDelegate>  delegate;

@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UITableView *leftTable;
@property (nonatomic, strong) UITableView *rightTable;

@property (nonatomic, strong) UIButton *upArrowButton;
@property (nonatomic, strong) UIButton *downArrowButton;
@end

@protocol AGToggleFieldSetDelegate

@optional

- (void)fieldDidToggle:(AGToggleFieldSet*)toggleFieldSet;

@end
