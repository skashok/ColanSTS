//
//  DropDownView.h
//  CustomTableView
//
//  Created by Ameya on 19/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BLENDIN,              
	GROW,
	BOTH
} AnimationType;


@protocol DropDownViewDelegate

@required

-(void)dropDownCellSelected:(NSInteger)returnIndex;
-(void)dropDownCellDeselected:(NSInteger)returnIndex;

@end

@protocol snoozeDelegate

@required
-(void)snoozeCellSelected:(NSInteger)returnIndex;
@end

@protocol UserSettingsTechDelegate
@required
//-(void)userSettingsTechListSelected:(NSArray *) techList;
@end

@protocol UserSettingsSnoozeIntervalDelegate
@required
-(void)userSettingsSnoozeIntervalSelected:(NSInteger)returnIndex;
@end

@protocol DailyRecapDelegate

@required
-(void)dailyRecapCellSelected:(NSInteger)returnIndex;
-(void)dailyRecapCellDselected:(NSInteger)returnIndex;

@end

@interface DropDownView : UIViewController<UITableViewDelegate,UITableViewDataSource> {

	UITableView *uiTableView;
	
	NSArray *arrayData;
	
	CGFloat heightOfCell;
	
	CGFloat paddingLeft;
	
	CGFloat paddingRight;
	
	CGFloat paddingTop;
	
	CGFloat heightTableView;
	
	UIView *refView;
	
	id<DropDownViewDelegate>__unsafe_unretained delegate;
	
    id<snoozeDelegate> snoozedelegate;
    
    id<UserSettingsTechDelegate> userSettingsTechDelegate;

    id<UserSettingsSnoozeIntervalDelegate> userSettingsSnoozeIntervalDelegate;
   
    id<DailyRecapDelegate>dailyRecapDelegate;

	NSInteger animationType;
	
	CGFloat open;
	
	CGFloat close;
  
    NSMutableArray *selectedIndexes;
    
    NSMutableArray *selectedIndexPath;
   }

@property (nonatomic,assign) id<DropDownViewDelegate> delegate;

@property (nonatomic,strong) id<DailyRecapDelegate>dailyRecapDelegate;

@property (nonatomic,strong) id<snoozeDelegate> snoozedelegate;

@property (nonatomic,strong) id<UserSettingsTechDelegate> userSettingsTechDelegate;

@property (nonatomic,strong) id<UserSettingsSnoozeIntervalDelegate> userSettingsSnoozeIntervalDelegate;

@property (nonatomic,retain)UITableView *uiTableView;

@property (nonatomic,retain) NSArray *arrayData;

@property (nonatomic) CGFloat heightOfCell;

@property (nonatomic) CGFloat paddingLeft;

@property (nonatomic) CGFloat paddingRight;

@property (nonatomic) CGFloat paddingTop;

@property (nonatomic) CGFloat heightTableView;

@property (nonatomic,retain)UIView *refView;

@property (nonatomic) CGFloat open;

@property (nonatomic) CGFloat close;
 
@property (retain) NSMutableArray* selectedIndexPath;

- (id)initWithArrayData:(NSArray*)data cellHeight:(CGFloat)cHeight heightTableView:(CGFloat)tHeightTableView paddingTop:(CGFloat)tPaddingTop paddingLeft:(CGFloat)tPaddingLeft paddingRight:(CGFloat)tPaddingRight refView:(UIView*)rView animation:(AnimationType)tAnimation  openAnimationDuration:(CGFloat)openDuration closeAnimationDuration:(CGFloat)closeDuration;

-(void)closeAnimation;

-(void)openAnimation;

-(NSArray *)donePressed;

@end
