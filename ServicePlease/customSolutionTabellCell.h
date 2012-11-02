//
//  customSolutionTabellCell.h
//  ServiceTech
//
//  Created by Ashokkumar Kandaswamy on 08/08/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//


#import <UIKit/UIKit.h>
@class customSolutionTabellCell;

@protocol customSolutionTabelViewCellDelegate 

@optional

-(void)customSolutionTabelCellBtnPressed:(id)sender cell:(customSolutionTabellCell *)cell;

@end

@interface customSolutionTabellCell : UITableViewCell

@property (nonatomic,strong) IBOutlet  UILabel *tittleLabel;
@property (nonatomic,strong) IBOutlet  UILabel *detailLabel;
@property (nonatomic,strong) IBOutlet  UIButton *cellBtn;
@property (nonatomic,retain) IBOutlet  id  cellDelegate;

-(IBAction)cellBtnPressed:(id)sender;

@end