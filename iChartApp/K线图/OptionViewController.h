//
//  OptionViewController.h
//  chartee
//
//  Created by Tcy vinech on 12-7-25.
//  Copyright 2011 vinech_Tcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionViewController : UIViewController
{
    BOOL isEdit;
    char isChecked1[255];
    UILabel * label;
    UITableView * tabV;
}
@property(nonatomic,strong)NSArray *arrTitle;
@property(nonatomic,strong)NSMutableArray * arrCheck;
@property(nonatomic,strong)NSMutableArray * arrValue;
@property (nonatomic,strong)NSString * segmentTitle;
@end
