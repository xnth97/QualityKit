//
//  ExportManager.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/21.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "QKExportManager.h"
#import "data.h"

@implementation QKExportManager

+ (UIImage *)imageFromView:(UIView *)view {
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0f);
    } else {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (void)createPDFReportWithFileName:(NSString *)name successBlock:(void (^)())success {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *pdfPath = [path stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"pdf"]];
        UIGraphicsBeginPDFContextToFile(pdfPath, CGRectMake(0, 0, 612, 792), NULL);
        UIGraphicsBeginPDFPage();
        
        NSString *title = [NSString stringWithFormat:@"%@过程能力分析报告", [data shareInstance].title];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
        paragraph.alignment = NSTextAlignmentCenter;
        NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:20],
                               NSParagraphStyleAttributeName: paragraph,
                               NSForegroundColorAttributeName: [UIColor blackColor]};
        [title drawInRect:CGRectMake(0, 40, 612, 20) withAttributes:dict];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, 0.5);
        CGContextSetAllowsAntialiasing(context, YES);
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
        
        
        if ([data shareInstance].chartView != nil && [data shareInstance].subChartView == nil) {
            // 只有一个图
            UIImage *chartImg = [self imageFromView:[data shareInstance].chartView];
            [chartImg drawInRect:CGRectMake(26, 78+18, 560, 347)];
            
            CGContextBeginPath(context);
            
            //横线
            
            CGContextMoveToPoint(context, 26, 78);
            CGContextAddLineToPoint(context, 26+560, 78);
            
            CGContextMoveToPoint(context, 26, 78+18);
            CGContextAddLineToPoint(context, 26+560, 78+18);
            
            CGContextMoveToPoint(context, 26, 78+18+347);
            CGContextAddLineToPoint(context, 26+560, 78+18+347);
            
            // 竖线
            
            CGContextMoveToPoint(context, 26, 78);
            CGContextAddLineToPoint(context, 26, 78+18+347);
            
            CGContextMoveToPoint(context, 26+560, 78);
            CGContextAddLineToPoint(context, 26+560, 78+18+347);
            
            CGContextStrokePath(context);
            
            NSDictionary *subDict = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                      NSParagraphStyleAttributeName: paragraph,
                                      NSForegroundColorAttributeName: [UIColor blackColor]};
            [[data shareInstance].chartTitle drawInRect:CGRectMake(26, 78, 560, 18) withAttributes:subDict];
            
        } else if ([data shareInstance].chartView != nil && [data shareInstance].subChartView != nil) {
            // 有两个图
            
            UIImage *chartImg = [self imageFromView:[data shareInstance].chartView];
            UIImage *subChartImg = [self imageFromView:[data shareInstance].subChartView];
            
            [chartImg drawInRect:CGRectMake(26, 78+18, 560, 192)];
            [subChartImg drawInRect:CGRectMake(26, 78+18+192+18, 560, 192)];
            
            CGContextBeginPath(context);
            
            //横线
            
            CGContextMoveToPoint(context, 26, 78);
            CGContextAddLineToPoint(context, 26+560, 78);
            
            CGContextMoveToPoint(context, 26, 78+18);
            CGContextAddLineToPoint(context, 26+560, 78+18);
            
            CGContextMoveToPoint(context, 26, 78+18+192);
            CGContextAddLineToPoint(context, 26+560, 78+18+192);
            
            CGContextMoveToPoint(context, 26, 78+18+192+18);
            CGContextAddLineToPoint(context, 26+560, 78+18+192+18);
            
            CGContextMoveToPoint(context, 26, 78+18+192+18+192);
            CGContextAddLineToPoint(context, 26+560, 78+18+192+18+192);
            
            CGContextMoveToPoint(context, 26, 78+18+192+18+192+18);
            CGContextAddLineToPoint(context, 26+560, 78+18+192+18+192+18);
            
            CGContextMoveToPoint(context, 26, 78+18+192+18+192+18+24);
            CGContextAddLineToPoint(context, 26+560, 78+18+192+18+192+18+24);
            
            CGContextMoveToPoint(context, 26, 78+18+192+18+192+18+48);
            CGContextAddLineToPoint(context, 26+560, 78+18+192+18+192+18+48);
            
            //竖线
            CGContextMoveToPoint(context, 26, 78);
            CGContextAddLineToPoint(context, 26, 78+18+192+18+192+18+48);
            
            CGContextMoveToPoint(context, 26+560, 78);
            CGContextAddLineToPoint(context, 26+560, 78+18+192+18+192+18+48);
            
            CGContextStrokePath(context);
            
            NSDictionary *subDict = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                      NSParagraphStyleAttributeName: paragraph,
                                      NSForegroundColorAttributeName: [UIColor blackColor]};
            [[data shareInstance].chartTitle drawInRect:CGRectMake(26, 78, 560, 18) withAttributes:subDict];
            [[data shareInstance].subChartTitle drawInRect:CGRectMake(26, 78+18+192, 560, 192) withAttributes:subDict];
            [@"过程能力参数" drawInRect:CGRectMake(26, 78+18+192+18+192, 560, 18) withAttributes:subDict];
            
        }
        
        UIGraphicsEndPDFContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            success();
        });
    });
    
}

@end
