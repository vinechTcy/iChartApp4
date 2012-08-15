//
//  HBarChartModel.m
//  chartee
//
//  Created by Tcy vinech on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HBarChartModel.h"

@implementation HBarChartModel

-(void)drawSerie:(HChart *)chart serie:(NSMutableDictionary *)serie{    
    
    [serie setObject:@"254,0,50" forKey:@"negativeColor"];
    [serie setObject:@"41,0,255" forKey:@"color"];
    // [serie setObject:@"176,52,52" forKey:@"color"];//红色蜡烛颜色
    //[serie setObject:@"77,13,2" forKey:@"negativeColor"];//绿色蜡烛颜色
    [serie setObject:@"254,0,50" forKey:@"negativeSelectedColor"];
    [serie setObject:@"41,0,255" forKey:@"selectedColor"];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, NO);
    CGContextSetLineWidth(context, 0.5f);
    
    NSMutableArray *data          = [serie objectForKey:@"data"];
    int            yAxis          = [[serie objectForKey:@"yAxis"] intValue];
    int            section        = [[serie objectForKey:@"section"] intValue];
    NSString       *color         = [serie objectForKey:@"color"];
    NSString       *negativeColor = [serie objectForKey:@"negativeColor"];
    NSString       *selectedColor = [serie objectForKey:@"selectedColor"];
    NSString       *negativeSelectedColor = [serie objectForKey:@"negativeSelectedColor"];
    
    float R   = [[[color componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
    float G   = [[[color componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
    float B   = [[[color componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;
    float NR  = [[[negativeColor componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
    float NG  = [[[negativeColor componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
    float NB  = [[[negativeColor componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;
    float SR  = [[[selectedColor componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
    float SG  = [[[selectedColor componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
    float SB  = [[[selectedColor componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;
    float NSR = [[[negativeSelectedColor componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
    float NSG = [[[negativeSelectedColor componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
    float NSB = [[[negativeSelectedColor componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;
    
    HSection *sec = [chart.sections objectAtIndex:section];
    for(int i=chart.rangeFrom;i<chart.rangeTo;i++){
        if(i == data.count){
            break;
        }
        if([data objectAtIndex:i] == nil){
            continue;
        }
        
        float high  = [[[data objectAtIndex:i] objectAtIndex:2] floatValue];
        float low   = [[[data objectAtIndex:i] objectAtIndex:3] floatValue];
        float open  = [[[data objectAtIndex:i] objectAtIndex:0] floatValue];
        float close = [[[data objectAtIndex:i] objectAtIndex:1] floatValue];
        
        float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
        float iNx = sec.frame.origin.x+sec.paddingLeft+(i+1-chart.rangeFrom)*chart.plotWidth;
        float iyo = [chart getLocalY:open withSection:section withAxis:yAxis];
        float iyc = [chart getLocalY:close withSection:section withAxis:yAxis];
        float iyh = [chart getLocalY:high withSection:section withAxis:yAxis];
        float iyl = [chart getLocalY:low withSection:section withAxis:yAxis];
        
        if(i == chart.selectedIndex && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
            //            CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor);
            //指标线颜色
            CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:111/255.0f green:234/255.0f blue:52/255.0f alpha:0.8].CGColor);
            CGContextMoveToPoint(context, ix+chart.plotWidth/2, sec.frame.origin.y+sec.paddingTop);
            CGContextAddLineToPoint(context,ix+chart.plotWidth/2,sec.frame.size.height+sec.frame.origin.y);
            CGContextStrokePath(context);
        }
        
        if(close == open){
            if(i == chart.selectedIndex){
                CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:SR green:SG blue:SB alpha:1.0].CGColor);
            }else{
                CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:R green:G blue:B alpha:1.0].CGColor);
            }
        }else{
            if(close < open){
                if(i == chart.selectedIndex){
                    CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:NSR green:NSG blue:NSB alpha:1.0].CGColor);
                    CGContextSetRGBFillColor(context, NSR, NSG, NSB, 1.0); 
                }else{
                    CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:NR green:NG blue:NB alpha:1.0].CGColor);
                    CGContextSetRGBFillColor(context, NR, NG, NB, 1.0); 
                }
            }else{
                if(i == chart.selectedIndex){
                    CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:SR green:SG blue:SB alpha:1.0].CGColor);
                    CGContextSetRGBFillColor(context, SR, SG, SB, 1.0); 
                }else{
                    CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:R green:G blue:B alpha:1.0].CGColor);
                    CGContextSetRGBFillColor(context, R, G, B, 1.0); 
                } 
            }
        }
        
        if(close == open){
            CGContextMoveToPoint(context, ix+chart.plotPadding, iyo);
            CGContextAddLineToPoint(context, iNx-chart.plotPadding,iyo);
            CGContextStrokePath(context);
            
        }else{
            if(close < open){
                //  CGContextFillRect (context, CGRectMake (ix+chart.plotPadding, iyo, chart.plotWidth-2*chart.plotPadding,iyc-iyo)); 
                CGContextFillRect (context, CGRectMake (ix+chart.plotPadding+(chart.plotWidth-2*chart.plotPadding)/2, iyc, (chart.plotWidth-2*chart.plotPadding)/2,1)); 
                CGContextFillRect (context, CGRectMake (ix+chart.plotPadding-1, iyo, (chart.plotWidth-2*chart.plotPadding)/2+1,1.0)); 
                
                
            }else{
                // CGContextFillRect (context, CGRectMake (ix+chart.plotPadding, iyc, chart.plotWidth-2*chart.plotPadding, iyo-iyc));
                //                CGContextFillRect (context, CGRectMake (ix+chart.plotPadding, iyo, (chart.plotWidth-2*chart.plotPadding)/2, 1.0)); 
                CGContextFillRect (context, CGRectMake (ix+chart.plotPadding+(chart.plotWidth-2*chart.plotPadding)/2+1, iyc, (chart.plotWidth-2*chart.plotPadding)/2+1, 1)); 
                
            }
        }
        
        CGContextMoveToPoint(context, ix+chart.plotWidth/2, iyh);
        CGContextAddLineToPoint(context,ix+chart.plotWidth/2,iyl);
        CGContextStrokePath(context);
    }
}

-(void)setValuesForYAxis:(HChart *)chart serie:(NSDictionary *)serie{
    if([[serie objectForKey:@"data"] count] == 0){
		return;
	}
	
	NSMutableArray *data    = [serie objectForKey:@"data"];
	NSString       *yAxis   = [serie objectForKey:@"yAxis"];
	NSString       *section = [serie objectForKey:@"section"];
	
	HYAxis *yaxis = [[[chart.sections objectAtIndex:[section intValue]] yAxises] objectAtIndex:[yAxis intValue]];
	
    float high = [[[data objectAtIndex:chart.rangeFrom] objectAtIndex:2] floatValue];
    float low = [[[data objectAtIndex:chart.rangeFrom] objectAtIndex:3] floatValue];
    
    if(!yaxis.isUsed){
        [yaxis setMax:high];
        [yaxis setMin:low];
        yaxis.isUsed = YES;
    }
    
    for(int i=chart.rangeFrom;i<chart.rangeTo;i++){
        if(i == data.count){
            break;
        }
        if([data objectAtIndex:i] == nil){
            continue;
        }
        
        float high = [[[data objectAtIndex:i] objectAtIndex:2] floatValue];
        float low = [[[data objectAtIndex:i] objectAtIndex:3] floatValue];
        if(high > [yaxis max])
            [yaxis setMax:high];
        if(low < [yaxis min])
            [yaxis setMin:low];
    }
}

-(void)setLabel:(HChart *)chart label:(NSMutableArray *)label forSerie:(NSMutableDictionary *) serie{
    if([serie objectForKey:@"data"] == nil || [[serie objectForKey:@"data"] count] == 0){
	    return;
	}
	
	NSMutableArray *data          = [serie objectForKey:@"data"];
	NSString       *color         = [serie objectForKey:@"color"];
	NSString       *negativeColor = [serie objectForKey:@"negativeColor"];
	
	float R   = [[[color componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
	float G   = [[[color componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
	float B   = [[[color componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;
	float NR  = [[[negativeColor componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
	float NG  = [[[negativeColor componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
	float NB  = [[[negativeColor componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;
	
	float ZR  = 1;
	float ZG  = 1;
	float ZB  = 1;
    
	
    if(chart.selectedIndex!=-1 && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
        float high  = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:2] floatValue];
        float low   = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:3] floatValue];
        float open  = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:0] floatValue];
        float close = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:1] floatValue];
        float inc   =  (close-open)*100/open;
        
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
        NSMutableString *l = [[NSMutableString alloc] init];
        [l appendFormat:@"Open:%.2f",open];
        [tmp setObject:l forKey:@"text"];
        
        NSMutableString *clr = [[NSMutableString alloc] init];
        [clr appendFormat:@"%f,",ZR];
        [clr appendFormat:@"%f,",ZG];
        [clr appendFormat:@"%f",ZB];
        [tmp setObject:clr forKey:@"color"];
        [label addObject:tmp];
        
        
        tmp = [[NSMutableDictionary alloc] init];
        l = [[NSMutableString alloc] init];
        [l appendFormat:@"Close:%.2f",close];
        [tmp setObject:l forKey:@"text"];
        clr = [[NSMutableString alloc] init];
        if(close>open){
            [clr appendFormat:@"%f,",R];
            [clr appendFormat:@"%f,",G];
            [clr appendFormat:@"%f",B];
        }else if (close < open) {
            [clr appendFormat:@"%f,",NR];
            [clr appendFormat:@"%f,",NG];
            [clr appendFormat:@"%f",NB];
        }else{
            [clr appendFormat:@"%f,",ZR];
            [clr appendFormat:@"%f,",ZG];
            [clr appendFormat:@"%f",ZB];
        }
        [tmp setObject:clr forKey:@"color"];
        
        [label addObject:tmp];
        
        tmp = [[NSMutableDictionary alloc] init];
        l = [[NSMutableString alloc] init];
        [l appendFormat:@"High:%.2f",high];
        [tmp setObject:l forKey:@"text"];
        
        clr = [[NSMutableString alloc] init];
        if(high>open){
            [clr appendFormat:@"%f,",R];
            [clr appendFormat:@"%f,",G];
            [clr appendFormat:@"%f",B];
        }else{
            [clr appendFormat:@"%f,",ZR];
            [clr appendFormat:@"%f,",ZG];
            [clr appendFormat:@"%f",ZB];
        }
        [tmp setObject:clr forKey:@"color"];
        
        [label addObject:tmp];
        
        
        tmp = [[NSMutableDictionary alloc] init];
        l = [[NSMutableString alloc] init];
        [l appendFormat:@"Low:%.2f ",low];
        [tmp setObject:l forKey:@"text"];
        
        clr = [[NSMutableString alloc] init];
        if(low>open){
            [clr appendFormat:@"%f,",R];
            [clr appendFormat:@"%f,",G];
            [clr appendFormat:@"%f",B];
        }else if(low<open){
            [clr appendFormat:@"%f,",NR];
            [clr appendFormat:@"%f,",NG];
            [clr appendFormat:@"%f",NB];
        }else{
            [clr appendFormat:@"%f,",ZR];
            [clr appendFormat:@"%f,",ZG];
            [clr appendFormat:@"%f",ZB];
        }
        
        [tmp setObject:clr forKey:@"color"];
        [label addObject:tmp];
        
        
        tmp = [[NSMutableDictionary alloc] init];
        l = [[NSMutableString alloc] init];
        [l appendFormat:@"Change:%.2f%@  ",inc,@"%"];
        [tmp setObject:l forKey:@"text"];
        
        clr = [[NSMutableString alloc] init];
        if(inc > 0){
            [clr appendFormat:@"%f,",R];
            [clr appendFormat:@"%f,",G];
            [clr appendFormat:@"%f",B];
        }else if(inc < 0){
            [clr appendFormat:@"%f,",NR];
            [clr appendFormat:@"%f,",NG];
            [clr appendFormat:@"%f",NB];
        }else{
            [clr appendFormat:@"%f,",ZR];
            [clr appendFormat:@"%f,",ZG];
            [clr appendFormat:@"%f",ZB];
        }
        
        [tmp setObject:clr forKey:@"color"];
        [label addObject:tmp];
    }
}
-(void)drawTips:(HChart *)chart serie:(NSMutableDictionary *)serie{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(context, NO);
	CGContextSetLineWidth(context, 0.5f);
	
	NSMutableArray *data          = [serie objectForKey:@"data"];
	NSString       *type          = [serie objectForKey:@"type"];
	NSString       *name          = [serie objectForKey:@"name"];
	int            section        = [[serie objectForKey:@"section"] intValue];
	NSMutableArray *category      = [serie objectForKey:@"category"];
	HSection *sec = [chart.sections objectAtIndex:section];
	
	if([type isEqualToString:@"candle"]){
		for(int i=chart.rangeFrom;i<chart.rangeTo;i++){
			if(i == data.count){
				break;
			}
			if([data objectAtIndex:i] == nil){
			    continue;
			}
			
            //	float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
			if(i == chart.selectedIndex && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
				
				CGContextSetShouldAntialias(context, YES);
                //指标线上的显示背景
                //				CGContextSetRGBFillColor(context, 0/255.0f, 167/255.0f, 142/255.0f, 0.5);
                
                CGContextSetRGBFillColor(context,0/255.0f, 0/255.0f, 0/255.0f, 1); 
				CGSize size = [[category objectAtIndex:chart.selectedIndex] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
				
				//int x = ix+chart.plotWidth/2;
                int x = CATEGORY_X;
				int y = sec.frame.origin.y+sec.paddingTop-CATEGORY_Y;
				if(x+size.width > sec.frame.size.width+sec.frame.origin.x){
					x= x-(size.width+4);
				}
				CGContextFillRect (context, CGRectMake (x, y, size.width+10,size.height+2));
                
				CGContextSetRGBFillColor(context, 255/255.0f, 185/255.0f, 15/255.0f, 1.0);
				[[category objectAtIndex:chart.selectedIndex] drawAtPoint:CGPointMake(x+2,y+1) withFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
                [[category objectAtIndex:chart.rangeFrom] drawAtPoint:CGPointMake(x-CATEGORY_1_X ,y+CATEGORY_1_Y) withFont:[UIFont fontWithName:@"Helvetica" size:8.0]];
                [[category objectAtIndex:chart.rangeFrom+((chart.rangeTo-chart.rangeFrom)/2)] drawAtPoint:CGPointMake(x-CATEGORY_2_X,y+CATEGORY_1_Y) withFont:[UIFont fontWithName:@"Helvetica" size:8.0]];
//                NSLog(@"from = %d,To = %d",chart.rangeFrom ,chart.rangeTo);
                
                //                if (chart.rangeTo-chart.rangeFrom>35 && chart.rangeTo-chart.rangeFrom <40) {
                //                }else {
                //                    [[category objectAtIndex:chart.rangeFrom+((chart.rangeTo-chart.rangeFrom-1))] drawAtPoint:CGPointMake(x+25,y+210) withFont:[UIFont fontWithName:@"Helvetica" size:8.0]]; 
                //                    
                //                }
                if (chart.rangeTo >[category count]) {
                    continue;
                }else {
                    [[category objectAtIndex:chart.rangeFrom+((chart.rangeTo-chart.rangeFrom)-1)] drawAtPoint:CGPointMake(x+CATEGORY_3_X,y+CATEGORY_1_Y) withFont:[UIFont fontWithName:@"Helvetica" size:8.0]]; 
                    
                }
				CGContextSetShouldAntialias(context, NO);	
			}
		}
	}
	
	if([type isEqualToString:@"line"] && [name isEqualToString:@"price"]){
		for(int i=chart.rangeFrom;i<chart.rangeTo;i++){
			if(i == data.count){
				break;
			}
			if([data objectAtIndex:i] == nil){
			    continue;
			}
            
			float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
			
			if(i == chart.selectedIndex && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
				
				CGContextSetShouldAntialias(context, YES);
                //				CGContextSetRGBFillColor(context, 0.2, 0.2, 0.2, 0.8); 
				CGSize size = [[category objectAtIndex:chart.selectedIndex] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
				
				int x = ix+chart.plotWidth/2;
				int y = sec.frame.origin.y+sec.paddingTop;
				if(x+size.width > sec.frame.size.width+sec.frame.origin.x){
					x = x-(size.width+4);
				}
				CGContextFillRect (context, CGRectMake (x, y, size.width+4,size.height+2)); 
                //CGContextSetRGBFillColor(context, 0.8, 0.8, 0.8, 1.0); 
                CGContextSetRGBFillColor(context, 66/255.0f, 145/255.0f, 252/255.0f, 1);
                
                [[category objectAtIndex:chart.selectedIndex] drawAtPoint:CGPointMake(x+2,y+1) withFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
				CGContextSetShouldAntialias(context, NO);	
			}
		}
	}	
}
@end
