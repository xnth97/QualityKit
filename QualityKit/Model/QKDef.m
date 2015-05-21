//
//  QualityKitDef.m
//  QualityKit
//
//  Created by 秦昱博 on 15/5/12.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "QKDef.h"

@implementation QKDef

/**
 *  注意
 *
 *  以下所有常数在 n=1 时均不应有值。为方便计算，使之为 0
 *  在 n>=10 的情况并不为 0，需要进行调整
 *
 */

+ (float)QKConstant_d3:(NSInteger)n {
    NSArray *d3Arr = @[@0, @0.893, @0.888, @0.880, @0.864, @0.848, @0.833, @0.820, @0.808, @0.797];
    if (n <= 10) {
        return [d3Arr[n - 1] floatValue];
    } else {
        return 0;
    }
}

+ (float)QKConstantD3:(NSInteger)n {
    NSArray *D3Arr = @[@0, @0, @0, @0, @0, @0, @0.076, @1.136, @0.184, @0.223];
    if (n <= 10) {
        return [D3Arr[n - 1] floatValue];
    } else {
        return 0;
    }
}

+ (float)QKConstantD4:(NSInteger)n {
    NSArray *D4Arr = @[@0, @3.267, @2.579, @2.282, @2.115, @2.004, @1.924, @1.864, @1.816, @1.777];
    if (n <= 10) {
        return [D4Arr[n - 1] floatValue];
    } else {
        return 0;
    }
}

+ (float)QKConstantA2:(NSInteger)n {
    NSArray *A2Arr = @[@0, @1.88, @1.023, @0.729, @0.577, @0.483, @0.419, @0.373, @0.337, @0.308];
    if (n <= 10) {
        return [A2Arr[n - 1] floatValue];
    } else {
        return 0;
    }
}

+ (float)QKConstantA3:(NSInteger)n {
    NSArray *A3Arr = @[@0, @2.659, @1.954, @1.628, @1.427, @1.287, @1.182, @1.099, @1.032, @0.973];
    if (n <= 10) {
        return [A3Arr[n - 1] floatValue];
    } else {
        return 0;
    }
}

+ (float)QKConstantB3:(NSInteger)n {
    NSArray *B3Arr = @[@0, @0, @0, @0, @0, @0.03, @0.118, @0.185, @0.239, @0.284];
    if (n <= 10) {
        return [B3Arr[n - 1] floatValue];
    } else {
        return 0;
    }
}

+ (float)QKConstantB4:(NSInteger)n {
    NSArray *B4Arr = @[@0, @3.267, @2.568, @2.266, @2.089, @1.97, @1.882, @1.815, @1.761, @1.716];
    if (n <= 10) {
        return [B4Arr[n - 1] floatValue];
    } else {
        return 0;
    }
}

+ (float)QKConstantE2:(NSInteger)n {
    NSArray *E2Arr = @[@0, @2.66, @1.77, @1.46, @1.29, @1.18, @1.11, @1.05, @1.01, @0.98];
    if (n <= 10) {
        return [E2Arr[n - 1] floatValue];
    } else {
        return 0;
    }
}

+ (float)QKConstant_d2:(NSInteger)n {
    NSArray *d2Arr = @[@0, @1.13, @1.69, @2.06, @2.33, @2.53, @2.70, @2.85, @2.97, @3.08];
    if (n <= 10) {
        return [d2Arr[n - 1] floatValue];
    } else {
        return 0;
    }
}

+ (float)QKConstantC4:(NSInteger)n {
    NSArray *C4Arr = @[@0, @0.798, @0.886, @0.921, @0.940, @0.952, @0.959, @0.965, @0.969, @0.973];
    if (n <= 10) {
        return [C4Arr[n - 1] floatValue];
    } else {
        return 0;
    }
}

+ (float)shapiroWilkWValue:(NSInteger)n alpha:(float)alpha {
    if (alpha == 0.1) {
        NSArray *WArr = @[@0, @0, @0.787, @0.792, @0.806, @0.826, @0.838, @0.851, @0.859, @0.869, @0.876, @0.883, @0.889, @0.895, @0.901];
        if (n <= 15) {
            return [WArr[n - 1] floatValue];
        } else {
            return 0;
        }
    } else if (alpha == 0.05) {
        NSArray *WArr = @[@0, @0, @0.767, @0.748, @0.762, @0.788, @0.803, @0.818, @0.829, @0.842, @0.850, @0.859, @0.866, @0.874, @0.881];
        if (n <= 15) {
            return [WArr[n - 1] floatValue];
        } else {
            return 0;
        }
    } else if (alpha == 0.01) {
        NSArray *WArr = @[@0, @0, @0.753, @0.687, @0.686, @0.713, @0.730, @0.749, @0.764, @0.781, @0.792, @0.805, @0.814, @0.825, @0.835];
        if (n <= 15) {
            return [WArr[n - 1] floatValue];
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

+ (float)shapiroWilkAValue:(NSInteger)n {
    NSArray *aArr = @[@0.3789, @0.2604, @0.2281, @0.2045, @0.1855, @0.1693, @0.1551, @0.1423, @0.1306, @0.1197, @0.1095, @0.0998, @0.0906, @0.0817, @0.0731];
    if (n <= 15) {
        return [aArr[n - 1] floatValue];
    } else {
        return 0;
    }
}

@end
