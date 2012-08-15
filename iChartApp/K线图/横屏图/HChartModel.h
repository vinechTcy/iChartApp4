//
//  HChartModel.h
//  chartee
//
//  Created by Tcy vinech on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HChart;


@interface HChartModel : NSObject
-(void)drawSerie:(HChart *)chart serie:(NSMutableDictionary *)serie;
-(void)setValuesForYAxis:(HChart *)chart serie:(NSDictionary *)serie;
-(void)setLabel:(HChart *)chart label:(NSMutableArray *)label forSerie:(NSMutableDictionary *) serie;
-(void)drawTips:(HChart *)chart serie:(NSMutableDictionary *)serie;

@end
