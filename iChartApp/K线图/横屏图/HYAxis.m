//
//  HYAxis.m
//  chartee
//
//  Created by Tcy vinech on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HYAxis.h"

@implementation HYAxis

@synthesize isUsed;
@synthesize frame;
@synthesize max;
@synthesize min;
@synthesize ext;
@synthesize baseValue;
@synthesize baseValueSticky;
@synthesize symmetrical;
@synthesize paddingTop;
@synthesize tickInterval;
@synthesize pos;
@synthesize decimal;

- (id)init{
	self = [super init];
    if (self) {
		[self reset];
    }
	return self;
}

-(void)reset{
	self.isUsed = NO;
	self.min = MAXFLOAT;
	self.max = MAXFLOAT;
	self.ext = 0;
	self.baseValue = 0;
	self.symmetrical = NO;
	self.baseValueSticky = NO;
	self.paddingTop=15;
	self.tickInterval = 6;
	self.pos = 0;
	self.decimal = 2;
}

@end
