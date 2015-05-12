//
//  ControlChartView.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "ControlChartView.h"

@implementation ControlChartView

@synthesize dataArr;
@synthesize indexesOfErrorPoints;
@synthesize UCLValue;
@synthesize LCLValue;
@synthesize CLValue;

- (void)strokeControlChart {
    [self drawRect:self.frame];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 绘制坐标轴
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 50, 15);
    CGContextAddLineToPoint(context, 50, height - 30);
    CGContextMoveToPoint(context, 50, height - 30);
    CGContextAddLineToPoint(context, width - 60, height - 30);
    
    CGContextStrokePath(context);
    
    // 绘制 CL
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
    CGContextBeginPath(context);
    
    float CLHeight = 15 + 0.5 * (height - 15 - 30);
    CGContextMoveToPoint(context, 50, CLHeight);
    CGContextAddLineToPoint(context, width - 60, CLHeight);
    CGContextStrokePath(context);
    
    // 确定 y 轴上下限及单位高度
    float maxValue = [dataArr[0] floatValue];
    float minValue = [dataArr[0] floatValue];
    for (NSNumber *tmpNum in dataArr) {
        float tmpFloat = [tmpNum floatValue];
        if (tmpFloat >= maxValue) {
            maxValue = tmpFloat;
        }
        if (tmpFloat <= minValue) {
            minValue = tmpFloat;
        }
    }
    if (maxValue <= UCLValue) {
        maxValue = UCLValue;
    }
    if (minValue >= LCLValue) {
        minValue = LCLValue;
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
    
    // 绘制 UCL 和 LCL
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 50, zeroHeight - UCLValue * unitHeight);
    CGContextAddLineToPoint(context, width - 60, zeroHeight - UCLValue * unitHeight);
    
    CGContextMoveToPoint(context, 50, zeroHeight - LCLValue * unitHeight);
    CGContextAddLineToPoint(context, width - 60, zeroHeight - LCLValue * unitHeight);
    
    CGContextStrokePath(context);
    
    // 确定每点坐标
    float unitWidth = (width - 50 - 60)/(dataArr.count + 1);
    NSMutableArray *coordinatesArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataArr.count; i ++) {
        float tmpFloat = [(NSNumber *)dataArr[i] floatValue];
        CGPoint point = CGPointMake(50 + (i + 1) * unitWidth, zeroHeight - tmpFloat * unitHeight);
        [coordinatesArr addObject:[NSValue valueWithCGPoint:point]];
    }
    
    // 绘制折线图
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
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
}

@end
