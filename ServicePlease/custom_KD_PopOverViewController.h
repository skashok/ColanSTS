//
//  custom_KD_PopOverViewController.h
//  ServiceTech
//
//  Created by karthik keyan on 19/09/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DropDownView.h"
#import "DCRoundSwitch.h"
#import "ServiceHelper.h"
#import "KDListViewController.h"
@class  KDListViewController;

@interface custom_KD_PopOverViewController : UIViewController<DropDownViewDelegate,UITextFieldDelegate>{
    
    AppDelegate *appDelegate;
    DropDownView *dropwDownCustomTableView;
    DCRoundSwitch *helpDocSwitch;
    KDListViewController *KDListVC;
    
    int locationSelectBtnToggle;
    int CategorySelectBtnToggle;
    
    NSMutableString *locationString;
    NSMutableString *categoriesString;
    NSMutableArray  *locationarray;
    NSMutableArray  *categoryarray;
    NSMutableArray  *categoryNameList;
    NSMutableArray  *selectectedCategories;
    NSMutableArray  *locationNameList;
    NSMutableArray  *selectectedLocationes;
    NSString        *selectedLocation;
    
    NSMutableArray *locationIds;
    NSMutableArray *categoryIds;
    
    NSMutableArray *selectedLocationIds;
    NSMutableArray *selectedCategoryIds;
    
    int helpDocValue;
    int integervalueCheckDropDownSelection;
}

@property (nonatomic ,retain) DropDownView *dropwDownCustomTableView;
@property (nonatomic ,retain) AppDelegate *appDelegate;
@property (nonatomic ,retain)  ServiceHelper *serviceHelper;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextField *categoryTextField;
@property (strong, nonatomic) IBOutlet UIButton *locationSelectBtn;
@property (strong, nonatomic) IBOutlet UIButton *categorySelectBtn;
@property (strong, nonatomic) IBOutlet UITextView *describtionTextView;
@property (strong, nonatomic) IBOutlet UIButton *helpDocYesBtn;
@property (strong, nonatomic) IBOutlet UIButton *helpDocNoBtn;
@property (strong, nonatomic) IBOutlet UIButton *helpDocOnlyBtn;

- (IBAction)cancelBtnPressed:(id)sender;

- (IBAction)searchBtnPressed:(id)sender;

- (IBAction)locationSelectButtonPressed:(id)sender;

- (IBAction)categorySelectedBtnPressed:(id)sender;

- (IBAction)helpDocCheckBoxBtnPressed:(id)sender;

- (IBAction)clearBtnPressed:(id)sender;

@end

