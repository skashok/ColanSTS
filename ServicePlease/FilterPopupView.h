//
//  MyPopOverView.h
//  iPadTutorial
//
//  Created by Jannis Nikoy on 4/3/10.
//  Copyright 2010 Jannis Nikoy. All rights reserved.
//


@class FilterPopupView;

#import "Tech.h"

@protocol TMFilterResponseDelegate <NSObject>
@required
-(void)filterServiceFinished:(NSString *)Ids;
-(void)showallFilterServiceFinished:(NSString *)Ids;
@end

@protocol CatsResponseDelegate <NSObject>
@required
-(void)CatsSelected:(NSString *)catId;
-(void)TechSelected:(Tech *)tech;
@end
@protocol TechResponseDelegate <NSObject>
@required
-(void)TechSelected:(Tech *)tech;
@end


#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ServiceTechConstants.h"

@interface FilterPopupView : UIViewController <UITableViewDataSource>
{
    IBOutlet UITableView *tableView;
    NSMutableArray *listArray;
    NSMutableArray *selectedIndexes;
    UIPopoverController *rootPopUpViewController;
    IBOutlet UIView *popupView;
    IBOutlet UIView *tableViewContainer;
    IBOutlet UIView *titleView;
    id <TMFilterResponseDelegate> filterDelegate;
    id <CatsResponseDelegate> CatDelegate;
    id <TechResponseDelegate> TechDelegate;
    int roleType;
    BOOL donePressed;
    int position;
    int lastIndexpath;
}

@property(nonatomic,retain) id <TMFilterResponseDelegate> filterDelegate;
@property(nonatomic,retain) id <CatsResponseDelegate> CatDelegate;
@property(nonatomic,retain) id <TechResponseDelegate> TechDelegate;

@property(nonatomic,retain) IBOutlet UIView *tableViewContainer;
@property(nonatomic,retain) IBOutlet UIView *popupView;
@property(nonatomic,retain) NSMutableArray *selectedIndexes;
@property(nonatomic,retain)IBOutlet UITableView *tableView;
@property(nonatomic,retain)IBOutlet UIButton *done;
@property(nonatomic,retain)IBOutlet UILabel *titleLabel;
@property(nonatomic,retain)IBOutlet UIView *titleView;

@property(nonatomic,retain) UIPopoverController *rootPopUpViewController;

@property (strong, nonatomic) AppDelegate *appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  array:(NSMutableArray *)list;

-(int)UserRole;

@end
