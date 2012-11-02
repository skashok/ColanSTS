//
//  customCell.h
//  ServiceTech
//
//  Created by Ashokkumar Kandaswamy on 08/08/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//


#import <UIKit/UIKit.h> 

@class customCell;

@protocol customProblemTabelViewCellDelegate 

@optional

-(void)problemcustomCellBtnPressed:(id)sender cell:(customCell *)cell;

@end

@interface customCell : UITableViewCell

@property (nonatomic,strong) IBOutlet  UILabel *tittleLabel;
@property (nonatomic,strong) IBOutlet  UILabel *detailLabel;
@property (nonatomic,strong) IBOutlet  UIButton *CellBtn;
@property (nonatomic,retain) IBOutlet id cellDelegate;

-(IBAction)CellBtnPressed:(id)sender;

@end