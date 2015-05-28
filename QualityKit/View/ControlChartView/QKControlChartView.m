//
//  ControlChartView.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "QKControlChartView.h"
#import "QKDef.h"

#define uclAndLclAreNSNumbers [_UCLValue isKindOfClass:[NSNumber class]] && [_LCLValue isKindOfClass:[NSNumber class]]
#define uclAndLclAreNSArrays [_UCLValue isKindOfClass:[NSArray class]] && [_LCLValue isKindOfClass:[NSArray class]]

@implementation QKControlChartView {
    float UCLFloatValue;
    float LCLFloatValue;
    
    NSArray *UCLArray;
    NSArray *LCLArray;
}

@synthesize dataArr;
@synthesize indexesOfErrorPoints;
@synthesize CLValue;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    // NSLog(@"%f", rect.size.width);
    if (dataArr != nil && dataArr.count > 0) {
        float width = rect.size.width;
        float height = rect.size.height;
        
        if (uclAndLclAreNSNumbers) {
            UCLFloatValue = [_UCLValue floatValue];
            LCLFloatValue = [_LCLValue floatValue];
        } else if (uclAndLclAreNSArrays) {
            UCLArray = [_UCLValue copy];
            LCLArray = [_LCLValue copy];
        }
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // 绘制坐标轴
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, 0.5);
        CGContextSetAllowsAntialiasing(context, YES);
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextBeginPath(context);
        
        CGContextMoveToPoint(context, 50, 15);
        CGContextAddLineToPoint(context, 50, height - 30);
        CGContextMoveToPoint(context, 50, height - 30);
        CGContextAddLineToPoint(context, width - 100, height - 30);
        
        CGContextStrokePath(context);
        
        // 绘制 CL
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, 0.5);
        CGContextSetAllowsAntialiasing(context, YES);
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.000 green:0.400 blue:0.000 alpha:1.000].CGColor);
        CGContextBeginPath(context);
        
        float CLHeight = 15 + 0.5 * (height - 15 - 30);
        CGContextMoveToPoint(context, 50, CLHeight);
        CGContextAddLineToPoint(context, width - 100, CLHeight);
        CGContextStrokePath(context);
        
        // 确定 y 轴上下限及单位高度
        float maxValue = [QKStatisticalFoundations maximumValueOfArray:dataArr];
        float minValue = [QKStatisticalFoundations minimumValueOfArray:dataArr];
        if (uclAndLclAreNSNumbers) {
            if (maxValue <= UCLFloatValue) {
                maxValue = UCLFloatValue;
            }
            if (minValue >= LCLFloatValue) {
                minValue = LCLFloatValue;
            }
        } else if (uclAndLclAreNSArrays) {
            float maxUCLValue = [QKStatisticalFoundations maximumValueOfArray:UCLArray];
            float minLCLValue = [QKStatisticalFoundations minimumValueOfArray:LCLArray];
            if (maxValue <= maxUCLValue) {
                maxValue = maxUCLValue;
            }
            if (minValue >= minLCLValue) {
                minValue = minLCLValue;
            }
        }
        
        // 绘图上下限
        float upperLimit;
        float lowerLimit;
        if (fabs(maxValue - CLValue) >= fabs(CLValue - minValue)) {
            upperLimit = maxValue;
            lowerLimit = CLValue - fabs(maxValue - CLValue);
        } else {
            lowerLimit = minValue;
            upperLimit = CLValue + fabs(CLValue - minValue);
        }
        // 单位高度
        float unitHeight = (height - 15 - 30 - 2 * 20)/(upperLimit - lowerLimit);
        // 0 位置 y 坐标
        float zeroHeight = CLHeight + CLValue * unitHeight;
        
        // 确定每点坐标
        float unitWidth = (width - 50 - 100)/(dataArr.count + 1);
        NSMutableArray *coordinatesArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < dataArr.count; i ++) {
            float tmpFloat = [(NSNumber *)dataArr[i] floatValue];
            CGPoint point = CGPointMake(50 + (i + 1) * unitWidth, zeroHeight - tmpFloat * unitHeight);
            [coordinatesArr addObject:[NSValue valueWithCGPoint:point]];
        }
        
        // 绘制折线图
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, 1.0);
        CGContextSetAllowsAntialiasing(context, YES);
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextSetLineDash(context, 0, 0, 0);
        CGContextBeginPath(context);
        
        for (int i = 0; i < coordinatesArr.count; i ++) {
            CGPoint tmpPoint = [coordinatesArr[i] CGPointValue];
            if (i == 0) {
                CGContextMoveToPoint(context, tmpPoint.x, tmpPoint.y);
            } else if (i != coordinatesArr.count - 1) {
                CGContextAddLineToPoint(context, tmpPoint.x, tmpPoint.y);
                CGContextMoveToPoint(context, tmpPoint.x, tmpPoint.y);
            } else {
                CGContextAddLineToPoint(context, tmpPoint.x, tmpPoint.y);
            }
        }
        CGContextStrokePath(context);
        
        // 绘制点
        float pointRadius = 8.0;
        for (NSValue *tmpValue in coordinatesArr) {
            CGPoint tmpPoint = [tmpValue CGPointValue];
            CGContextAddEllipseInRect(context, CGRectMake(tmpPoint.x - 0.5 * pointRadius, tmpPoint.y - 0.5 * pointRadius, pointRadius, pointRadius));
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextFillPath(context);
        }
        
        // 绘制出错点
        for (NSNumber *tmpIndex in indexesOfErrorPoints) {
            NSInteger tIndex = [tmpIndex integerValue];
            CGPoint tmpPoint = [(NSValue *)coordinatesArr[tIndex] CGPointValue];
            CGContextAddEllipseInRect(context, CGRectMake(tmpPoint.x - 0.5 * pointRadius, tmpPoint.y - 0.5 * pointRadius, pointRadius, pointRadius));
            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            CGContextFillPath(context);
        }
        
        // 绘制 UCL 和 LCL
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, 0.5);
        CGContextSetAllowsAntialiasing(context, YES);
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGFloat lengths[] = {10, 3};
        CGContextSetLineDash(context, 0, lengths, 2);
        CGContextBeginPath(context);
        
        if (uclAndLclAreNSNumbers) {
            
            CGContextMoveToPoint(context, 50, zeroHeight - UCLFloatValue * unitHeight);
            CGContextAddLineToPoint(context, width - 100, zeroHeight - UCLFloatValue * unitHeight);
            
            CGContextMoveToPoint(context, 50, zeroHeight - LCLFloatValue * unitHeight);
            CGContextAddLineToPoint(context, width - 100, zeroHeight - LCLFloatValue * unitHeight);
            
        } else if (uclAndLclAreNSArrays) {
            
            NSMutableArray *uclPointsArr = [[NSMutableArray alloc] init];
            NSMutableArray *lclPointsArr = [[NSMutableArray alloc] init];
            for (int i = 0; i < UCLArray.count; i ++) {
                
                float tmpUCLValue = [UCLArray[i] floatValue];
                float tmpLCLValue = [LCLArray[i] floatValue];
                
                if (i == 0) {
                    [uclPointsArr addObject:[NSValue valueWithCGPoint:CGPointMake(50, zeroHeight - tmpUCLValue * unitHeight)]];
                    [uclPointsArr addObject:[NSValue valueWithCGPoint:CGPointMake(50 + 1.5 * unitWidth, zeroHeight - tmpUCLValue * unitHeight)]];
                    [lclPointsArr addObject:[NSValue valueWithCGPoint:CGPointMake(50, zeroHeight - tmpLCLValue * unitHeight)]];
                    [lclPointsArr addObject:[NSValue valueWithCGPoint:CGPointMake(50 + 1.5 * unitWidth, zeroHeight - tmpLCLValue * unitHeight)]];
                } else {
                    [uclPointsArr addObject:[NSValue valueWithCGPoint:CGPointMake(50 + (i + 0.5) * unitWidth, zeroHeight - tmpUCLValue * unitHeight)]];
                    [uclPointsArr addObject:[NSValue valueWithCGPoint:CGPointMake(50 + (i + 1.5) * unitWidth, zeroHeight - tmpUCLValue * unitHeight)]];
                    [lclPointsArr addObject:[NSValue valueWithCGPoint:CGPointMake(50 + (i + 0.5) * unitWidth, zeroHeight - tmpLCLValue * unitHeight)]];
                    [lclPointsArr addObject:[NSValue valueWithCGPoint:CGPointMake(50 + (i + 1.5) * unitWidth, zeroHeight - tmpLCLValue * unitHeight)]];
                }
                
            }
            
            for (int j = 0; j < uclPointsArr.count - 1; j ++) {
                CGPoint point1 = [uclPointsArr[j] CGPointValue];
                CGPoint point2 = [uclPointsArr[j + 1] CGPointValue];
                CGContextMoveToPoint(context, point1.x, point1.y);
                CGContextAddLineToPoint(context, point2.x, point2.y);
                
                CGPoint point01 = [lclPointsArr[j] CGPointValue];
                CGPoint point02 = [lclPointsArr[j + 1] CGPointValue];
                CGContextMoveToPoint(context, point01.x, point01.y);
                CGContextAddLineToPoint(context, point02.x, point02.y);
            }
        }
        
        CGContextStrokePath(context);
        
        // 绘制 x 坐标值
        
        
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = NSTextAlignmentCenter;
        NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                               NSParagraphStyleAttributeName: paragraph,
                               NSForegroundColorAttributeName: [UIColor blackColor]};
        for (int i = 0; i < coordinatesArr.count; i ++) {
            NSString *tStr = [NSString stringWithFormat:@"%d", i + 1];
            CGPoint tmpPoint = [coordinatesArr[i] CGPointValue];
            [tStr drawInRect:CGRectMake(tmpPoint.x - 0.5 * 20, height - 26, 20, 20) withAttributes:dict];
        }
        
        // 绘制 UCL, LCL, CL 值
        
        NSMutableParagraphStyle *paragraph2 = [[NSMutableParagraphStyle alloc] init];
        paragraph2.alignment = NSTextAlignmentLeft;
        NSDictionary *dict2 = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                NSParagraphStyleAttributeName: paragraph2,
                                NSForegroundColorAttributeName: [UIColor redColor]};
        NSString *tStr2;
        
        if (uclAndLclAreNSNumbers) {
            tStr2 = [NSString stringWithFormat:@"UCL=%.3f", UCLFloatValue];
            [tStr2 drawInRect:CGRectMake(width - 92, zeroHeight - UCLFloatValue * unitHeight - 0.5 * 20, 90, 20) withAttributes:dict2];
            
            tStr2 = [NSString stringWithFormat:@"LCL=%.3f", LCLFloatValue];
            [tStr2 drawInRect:CGRectMake(width - 92, zeroHeight - LCLFloatValue * unitHeight - 0.5 * 20, 90, 20) withAttributes:dict2];
        } else {
            tStr2 = [NSString stringWithFormat:@"UCL=%.3f", [[UCLArray lastObject] floatValue]];
            [tStr2 drawInRect:CGRectMake(width - 92, zeroHeight - [[UCLArray lastObject] floatValue] * unitHeight - 0.5 * 20, 90, 20) withAttributes:dict2];
            
            tStr2 = [NSString stringWithFormat:@"LCL=%.3f", [[LCLArray lastObject] floatValue]];
            [tStr2 drawInRect:CGRectMake(width - 92, zeroHeight - [[LCLArray lastObject] floatValue] * unitHeight - 0.5 * 20, 90, 20) withAttributes:dict2];
        }
        
        NSDictionary *dict3 = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                NSParagraphStyleAttributeName: paragraph2,
                                NSForegroundColorAttributeName: [UIColor colorWithRed:0.000 green:0.400 blue:0.000 alpha:1.000]};
        tStr2 = [NSString stringWithFormat:@"CL=%.3f", CLValue];
        [tStr2 drawInRect:CGRectMake(width - 92, zeroHeight - CLValue * unitHeight - 0.5 * 20, 90, 20) withAttributes:dict3];
    }
    
    [super drawRect:rect];
    
}

@end
