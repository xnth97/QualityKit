//
//  ControlChartView.h
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QKControlChartView : UIView

@property (strong, nonatomic) NSArray *dataArr;
@property (nonatomic) id UCLValue;
@property (nonatomic) id LCLValue;
@property (nonatomic) float CLValue;
@property (strong, nonatomic) NSArray *indexesOfErrorPoints;

@end
