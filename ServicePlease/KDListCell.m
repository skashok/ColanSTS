//
//  KDListCell.m
//  ServiceTech
//
//  Created by Bala Subramaniyan on 19/09/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "KDListCell.h"
#import <QuartzCore/QuartzCore.h>
#import "TTTAttributedLabel.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"


static CGFloat const kEspressoDescriptionTextFontSize = 14;
static CGFloat const kAttributedTableViewCellVerticalMargin = 20.0f;

static NSRegularExpression *__nameRegularExpression;
static inline NSRegularExpression * NameRegularExpression() {
    if (!__nameRegularExpression) {
        __nameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"^\\w+" options:NSRegularExpressionCaseInsensitive error:nil];
    }
    
    return __nameRegularExpression;
}

static NSRegularExpression *__parenthesisRegularExpression;
static inline NSRegularExpression * ParenthesisRegularExpression() {
    if (!__parenthesisRegularExpression) {
        __parenthesisRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"\\([^\\(\\)]+\\)" options:NSRegularExpressionCaseInsensitive error:nil];
    }
    
    return __parenthesisRegularExpression;
}

@implementation KDListCell
@synthesize tittleLbl,likeDisLikeLbl;

@synthesize solutionText = _solutionText;
@synthesize solutionTextLbl = _solutionTextLbl;
@synthesize descriptionString = _descriptionString;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.solutionTextLbl = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.solutionTextLbl.font = [UIFont systemFontOfSize:kEspressoDescriptionTextFontSize];
    self.solutionTextLbl.textColor = [UIColor blackColor];
    self.solutionTextLbl.lineBreakMode = UILineBreakModeWordWrap;
    self.solutionTextLbl.numberOfLines = 0;
    self.solutionTextLbl.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:(id)[[UIColor redColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableActiveLinkAttributes setValue:(id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.1f] CGColor] forKey:(NSString *)kTTTBackgroundFillColorAttributeName];
    [mutableActiveLinkAttributes setValue:(id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.25f] CGColor] forKey:(NSString *)kTTTBackgroundStrokeColorAttributeName];
    [mutableActiveLinkAttributes setValue:(id)[NSNumber numberWithFloat:1.0f] forKey:(NSString *)kTTTBackgroundLineWidthAttributeName];
    [mutableActiveLinkAttributes setValue:(id)[NSNumber numberWithFloat:5.0f] forKey:(NSString *)kTTTBackgroundCornerRadiusAttributeName];
    self.solutionTextLbl.activeLinkAttributes = mutableActiveLinkAttributes;
    
    
    self.solutionTextLbl.highlightedTextColor = [UIColor whiteColor];
    self.solutionTextLbl.shadowColor = [UIColor colorWithWhite:0.87 alpha:1.0];
    self.solutionTextLbl.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.solutionTextLbl.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
   // self.solutionTextLbl.frame = CGRectOffset(CGRectInset(self.bounds, 20.0f, 5.0f), -10.0f, 0.0f);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        self.solutionTextLbl.frame = CGRectMake(7,23,250,44);
    }
    else
    {
        self.solutionTextLbl.frame = CGRectMake(6,30,693,55);
    }
    [self.contentView addSubview:self.solutionTextLbl];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)ViewDidLoad {
    
    
}

- (void)setSolutionText:(NSString *)text
{
    
    [self willChangeValueForKey:@"summaryText"];
    _solutionText = [text copy];
    [self didChangeValueForKey:@"summaryText"];
    
    NSLog(@"_solutionText = %@",_solutionText);

    NSLog(@"descriptionString = %@",self.descriptionString);

    [self.solutionTextLbl setText:_solutionText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSLog(@"[mutableAttributedString length] = %d",[mutableAttributedString length]);

        NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);
        
        NSLog(@"%@",[mutableAttributedString string]);
        
        NSRange nameRange;
        NSRegularExpression *regexp;
        
        NSArray *SearchTerms = [self.descriptionString componentsSeparatedByString:@","];
        for (int i = 0; i < [SearchTerms count]; i++)
        {
            NSLog(@"SearchTerms = %@",[SearchTerms objectAtIndex:i]);
        
           // if ( [[[mutableAttributedString string] lowercaseString] rangeOfString:@"solution"].location != NSNotFound )
            if ( [[[mutableAttributedString string] lowercaseString] rangeOfString:[[SearchTerms objectAtIndex:i] lowercaseString]].location != NSNotFound )
            {
                NSLog(@"solution not found");
                
                
                regexp = [NSRegularExpression
                          regularExpressionWithPattern:[[SearchTerms objectAtIndex:i] lowercaseString] //@"solution"
                          options:NSRegularExpressionAllowCommentsAndWhitespace
                          error:nil];
                
                nameRange = [regexp rangeOfFirstMatchInString:[[mutableAttributedString string] lowercaseString] options:0 range:stringRange];
                
                NSLog(@"nameRange = %@",NSStringFromRange(nameRange));
                
                UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:kEspressoDescriptionTextFontSize];
                CTFontRef boldFont = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
                if (boldFont)
                {
                    [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:nameRange];
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)boldFont range:nameRange];
                    [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor blackColor] CGColor] range:nameRange];
                    CFRelease(boldFont);
                }
                
                [mutableAttributedString replaceCharactersInRange:nameRange withString:[[mutableAttributedString string] substringWithRange:nameRange] ];
                
            }
        }
        
        regexp = ParenthesisRegularExpression();
        [regexp enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            UIFont *italicSystemFont = [UIFont italicSystemFontOfSize:kEspressoDescriptionTextFontSize];
            CTFontRef italicFont = CTFontCreateWithName((__bridge CFStringRef)italicSystemFont.fontName, italicSystemFont.pointSize, NULL);
            if (italicFont) {
                [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)italicFont range:result.range];
                CFRelease(italicFont);
                
                [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor blackColor] CGColor] range:result.range];
            }
        }];
        
        return mutableAttributedString;
    }];
}


@end
