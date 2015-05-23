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
            [chartImg drawInRect:CGRectMake(26, 78+30, 560, 347)];
            
            CGContextBeginPath(context);
            
            //横线
            
            CGContextMoveToPoint(context, 26, 78);
            CGContextAddLineToPoint(context, 26+560, 78);
            
            CGContextMoveToPoint(context, 26, 78+30);
            CGContextAddLineToPoint(context, 26+560, 78+30);
            
            CGContextMoveToPoint(context, 26, 78+30+347);
            CGContextAddLineToPoint(context, 26+560, 78+30+347);
            
            CGContextMoveToPoint(context, 26, 78+30+347+30);
            CGContextAddLineToPoint(context, 26+560, 78+30+347+30);
            
            CGContextMoveToPoint(context, 26, 78+30+347+30+24);
            CGContextAddLineToPoint(context, 26+560, 78+30+347+30+24);
            
            // 竖线
            
            CGContextMoveToPoint(context, 26, 78);
            CGContextAddLineToPoint(context, 26, 78+30+347+30+24);
            
            CGContextMoveToPoint(context, 26+560, 78);
            CGContextAddLineToPoint(context, 26+560, 78+30+347+30+24);
            
            CGContextMoveToPoint(context, 26+560/2, 78+30+347+30);
            CGContextAddLineToPoint(context, 26+560/2, 78+30+347+30+24);
            
            CGContextStrokePath(context);
            
            NSDictionary *subDict = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                      NSParagraphStyleAttributeName: paragraph,
                                      NSForegroundColorAttributeName: [UIColor blackColor]};
            [[data shareInstance].chartTitle drawInRect:CGRectMake(26, 78+6, 560, 30) withAttributes:subDict];
            [@"过程能力指数" drawInRect:CGRectMake(26, 78+30+347+6, 560, 30) withAttributes:subDict];
            NSString *tmpKey = [data shareInstance].parameters.allKeys[0];
            [tmpKey drawInRect:CGRectMake(26, 78+30+347+30+6, 560/2, 30) withAttributes:subDict];
            [([data shareInstance].parameters)[tmpKey] drawInRect:CGRectMake(26+560/2, 78+30+347+30+6, 560/2, 30) withAttributes:subDict];
            
        } else if ([data shareInstance].chartView != nil && [data shareInstance].subChartView != nil) {
            // 有两个图
            
            UIImage *chartImg = [self imageFromView:[data shareInstance].chartView];
            UIImage *subChartImg = [self imageFromView:[data shareInstance].subChartView];
            
            [chartImg drawInRect:CGRectMake(26, 78+30, 560, 192)];
            [subChartImg drawInRect:CGRectMake(26, 78+30+192+30, 560, 192)];
            
            CGContextBeginPath(context);
            
            //横线
            
            CGContextMoveToPoint(context, 26, 78);
            CGContextAddLineToPoint(context, 26+560, 78);
            
            CGContextMoveToPoint(context, 26, 78+30);
            CGContextAddLineToPoint(context, 26+560, 78+30);
            
            CGContextMoveToPoint(context, 26, 78+30+192);
            CGContextAddLineToPoint(context, 26+560, 78+30+192);
            
            CGContextMoveToPoint(context, 26, 78+30+192+30);
            CGContextAddLineToPoint(context, 26+560, 78+30+192+30);
            
            CGContextMoveToPoint(context, 26, 78+30+192+30+192);
            CGContextAddLineToPoint(context, 26+560, 78+30+192+30+192);
            
            CGContextMoveToPoint(context, 26, 78+30+192+30+192+30);
            CGContextAddLineToPoint(context, 26+560, 78+30+192+30+192+30);
            
            CGContextMoveToPoint(context, 26, 78+30+192+30+192+30+24);
            CGContextAddLineToPoint(context, 26+560, 78+30+192+30+192+30+24);
            
            CGContextMoveToPoint(context, 26, 78+30+192+30+192+30+48);
            CGContextAddLineToPoint(context, 26+560, 78+30+192+30+192+30+48);
            
            //竖线
            CGContextMoveToPoint(context, 26, 78);
            CGContextAddLineToPoint(context, 26, 78+30+192+30+192+30+48);
            
            CGContextMoveToPoint(context, 26+560, 78);
            CGContextAddLineToPoint(context, 26+560, 78+30+192+30+192+30+48);
            
            for (int i = 0; i < 5; i ++) {
                CGContextMoveToPoint(context, 26+(i + 1) * 93, 78+30+192+30+192+30);
                CGContextAddLineToPoint(context, 26+(i + 1) * 93, 78+30+192+30+192+30+48);
            }
            
            CGContextStrokePath(context);
            
            NSDictionary *subDict = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                      NSParagraphStyleAttributeName: paragraph,
                                      NSForegroundColorAttributeName: [UIColor blackColor]};
            [[data shareInstance].chartTitle drawInRect:CGRectMake(26, 78+6, 560, 30) withAttributes:subDict];
            [[data shareInstance].subChartTitle drawInRect:CGRectMake(26, 78+30+192+6, 560, 192) withAttributes:subDict];
            [@"过程能力参数" drawInRect:CGRectMake(26, 78+30+192+30+192+6, 560, 30) withAttributes:subDict];
            
            NSDictionary *parameters = [data shareInstance].parameters;
            NSArray *parametersArr = @[@"USL", @"LSL", @"CP", @"CPu", @"CPl", @"CPk"];
            for (int i = 0; i < parametersArr.count; i ++) {
                NSString *tmpKey = parametersArr[i];
                [tmpKey drawInRect:CGRectMake(26+i*560/parametersArr.count, 78+30+192+30+192+6+24+6, 93, 24) withAttributes:subDict];
                [parameters[tmpKey] drawInRect:CGRectMake(26+i*560/parametersArr.count, 78+30+192+6+30+192+24+24+6, 93, 24) withAttributes:subDict];
            }
            
        }
        
        UIGraphicsEndPDFContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            success();
        });
    });
    
}

@end
