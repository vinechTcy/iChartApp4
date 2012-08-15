//
//  LineChartModel.h
//  chartee
//
//  Created by zzy on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#define CATEGORY_X 230
#define CATEGORY_Y 26
#define CATEGORY_1_X 155
#define CATEGORY_1_Y 210
#define CATEGORY_2_X 65
#define CATEGORY_3_X 25
#import <Foundation/Foundation.h>
#import "ChartModel.h"
#import "YAxis.h"
#import "Chart.h"

@interface AreaChartModel : ChartModel
@property (nonatomic,assign)int taps;
@end
