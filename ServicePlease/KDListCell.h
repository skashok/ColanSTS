//
//  KDListCell.h
//  ServiceTech
//
//  Created by Bala Subramaniyan on 19/09/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTTAttributedLabel;

@interface KDListCell : UITableViewCell
{
    NSString *descriptionString;
    IBOutlet TTTAttributedLabel *solutionTextLbl;;
}
@property (nonatomic ,strong) IBOutlet UILabel *tittleLbl;
@property (nonatomic ,strong) IBOutlet TTTAttributedLabel *solutionTextLbl;
@property (nonatomic ,strong) IBOutlet UILabel *likeDisLikeLbl;

@property (nonatomic, copy) NSString *solutionText;
@property (nonatomic, copy) NSString *descriptionString;


@end
