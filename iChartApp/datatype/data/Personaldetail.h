//
//  Personaldetail.h
//  iChartApp
//
//  Created by bin huang on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//newsssss

#import <Foundation/Foundation.h>

@interface Personaldetail : NSObject

@property(nonatomic,strong)NSString *productname;
@property(nonatomic,strong)NSString *open;
@property(nonatomic,strong)NSString *high;
@property(nonatomic,strong)NSString *low;
@property(nonatomic,strong)NSString *volume;
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *time;


-(Personaldetail *)initWithproductname:(NSString *)theproductname open:(NSString *)theopen high:(NSString *)thehigh low:(NSString *)thelow volume:(NSString *)thevolume id:(NSString *)theid time:(NSString *)thetime;

+(NSMutableArray *)findall;
+(Personaldetail *)findpersonaldetailwithproductname:(NSString *)theproductname;
+(int)upDateWithOpen:(NSString *)theOpen High:(NSString *)theHigh Low:(NSString *)theLow Vlume:(NSString *)theVolume Time:(NSString *)theTime fromid:(NSString *)theid;
+(int)addproductname:(NSString *)theproductname open:(NSString *)theopen high:(NSString *)thehigh low:(NSString *)thelow volume:(NSString *)thevolume id:(NSString *)theid time:(NSString *)thetime;
+(int)addproductname:(NSString *)theproductname  id:(NSString *)theid type:(NSString *)thetype;

@end
