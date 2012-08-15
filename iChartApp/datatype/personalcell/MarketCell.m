//
//  MarketCell.m
//  iChart
//
//  Created by bin huang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MarketCell.h"

@implementation MarketCell
@synthesize label1 = _label1, label2 = _label2, label3 = _label3, label4 = _label4, label5 = _label5;
- (UILabel *) initwithLabelFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor tag:(int)tag  superview:(UIView *)theview 
{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = backgroundColor;
    label.tag = tag;
    label.textAlignment = UITextAlignmentCenter;
    //判断黑白
//    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
//    NSString * string = [user objectForKey:@"style"];
//    NSLog(@"string = %@",string);
//    if ([string isEqualToString:@"dark"]==YES) {
//        label.textColor = [UIColor whiteColor];
//        NSLog(@"调用了这个方法dark风格");
//    }
//    else {
//        label.textColor = [UIColor blackColor];
//        NSLog(@"调用了这个方法white风格");
//
//
//    }
    
    //label.textColor = [UIColor whiteColor];
    
    
    [theview addSubview:label];
    return label;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.label1 = [self initwithLabelFrame:CGRectMake(  0, 5, 90, 40) backgroundColor:[UIColor clearColor]  tag:101 superview:self.contentView];
        self.label2 = [self initwithLabelFrame:CGRectMake(100, 5, 100, 40) backgroundColor:[UIColor clearColor] tag:102 superview:self.contentView];
        self.label3 = [self initwithLabelFrame:CGRectMake(210, 5, 100, 40) backgroundColor:[UIColor clearColor] tag:103 superview:self.contentView];
        self.label4 = [self initwithLabelFrame:CGRectMake(320, 5, 100, 40) backgroundColor:[UIColor  clearColor] tag:104 superview:self.contentView];
        self.label5 = [self initwithLabelFrame:CGRectMake(430, 5, 110, 40) backgroundColor:[UIColor   clearColor]  tag:105 superview:self.contentView];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
