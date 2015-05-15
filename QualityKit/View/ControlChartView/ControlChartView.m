//
//  ControlChartView.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "ControlChartView.h"
#import "QualityKitDef.h"

@implementation ControlChartView

@synthesize dataArr;
@synthesize indexesOfErrorPoints;
@synthesize UCLValue;
@synthesize LCLValue;
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
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGFloat lengths[] = {20, 10};
        CGContextSetLineDash(context, 0, lengths, 2);
        CGContextBeginPath(context);
        
        CGContextMoveToPoint(context, 50, zeroHeight - UCLValue * unitHeight);
        CGContextAddLineToPoint(context, width - 100, zeroHeight - UCLValue * unitHeight);
        
        CGContextMoveToPoint(context, 50, zeroHeight - LCLValue * unitHeight);
        CGContextAddLineToPoint(context, width - 100, zeroHeight - LCLValue * unitHeight);
        
        CGContextStrokePath(context);
        
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
        NSString *tStr2 = [NSString stringWithFormat:@"UCL=%.3f", UCLValue];
        NSMutableParagraphStyle *paragraph2 = [[NSMutableParagraphStyle alloc] init];
        paragraph2.alignment = NSTextAlignmentLeft;
        NSDictionary *dict2 = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                NSParagraphStyleAttributeName: paragraph2,
                                NSForegroundColorAttributeName: [UIColor redColor]};
        [tStr2 drawInRect:CGRectMake(width - 92, zeroHeight - UCLValue * unitHeight - 0.5 * 20, 90, 20) withAttributes:dict2];
        
        tStr2 = [NSString stringWithFormat:@"LCL=%.3f", LCLValue];
        [tStr2 drawInRect:CGRectMake(width - 92, zeroHeight - LCLValue * unitHeight - 0.5 * 20, 90, 20) withAttributes:dict2];
        
        NSDictionary *dict3 = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                NSParagraphStyleAttributeName: paragraph2,
                                NSForegroundColorAttributeName: [UIColor colorWithRed:0.000 green:0.400 blue:0.000 alpha:1.000]};
        tStr2 = [NSString stringWithFormat:@"CL=%.3f", CLValue];
        [tStr2 drawInRect:CGRectMake(width - 92, zeroHeight - CLValue * unitHeight - 0.5 * 20, 90, 20) withAttributes:dict3];
    }
    
    [super drawRect:rect];
    
}

@end
