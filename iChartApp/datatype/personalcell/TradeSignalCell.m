//
//  TradeSignalCell.m
//  iChart
//
//  Created by bin huang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TradeSignalCell.h"
@implementation TradeSignalCell
@synthesize label1 = _label1, label2 = _label2, label3 = _label3, label4 = _label4, label5 = _label5, label6 = _label6, label7 = _label7;
- (UILabel *) initwithLabelFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor tag:(int)tag  superview:(UIView *)theview 
{
//    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
//    NSString * string = [user objectForKey:@"style"];
//    NSLog(@"viewvillappear..string ==================== %@",string);
//    
    
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = backgroundColor;
    label.tag = tag;
    label.textAlignment = UITextAlignmentCenter;
//    if (string==nil) {
//        label.textColor = [UIColor whiteColor];
//    }
//    else {
//        if ([string isEqualToString:@"dark"]) {
//            label.textColor = [UIColor whiteColor];
//
//        }
//        else {
//            label.textColor = [UIColor blackColor];
//
//        }
//    }
    
    [theview addSubview:label];
    return label;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.label1 = [self initwithLabelFrame:CGRectMake(  0, 5, 100, 40) backgroundColor:[UIColor clearColor] tag:101 superview:self.contentView];
        self.label2 = [self initwithLabelFrame:CGRectMake(110, 5, 100, 40) backgroundColor:[UIColor clearColor] tag:102 superview:self.contentView];
        self.label3 = [self initwithLabelFrame:CGRectMake(220, 5, 100, 40) backgroundColor:[UIColor clearColor] tag:103 superview:self.contentView];
        self.label4 = [self initwithLabelFrame:CGRectMake(330, 5, 100, 40) backgroundColor:[UIColor clearColor] tag:104 superview:self.contentView];
        self.label5 = [self initwithLabelFrame:CGRectMake(440, 5, 100, 40) backgroundColor:[UIColor clearColor] tag:105 superview:self.contentView];
        self.label6 = [self initwithLabelFrame:CGRectMake(550, 5, 100, 40) backgroundColor:[UIColor clearColor] tag:106 superview:self.contentView];
        self.label7 = [self initwithLabelFrame:CGRectMake(  0,40, 200, 30) backgroundColor:[UIColor clearColor] tag:107 superview:self.contentView];
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
