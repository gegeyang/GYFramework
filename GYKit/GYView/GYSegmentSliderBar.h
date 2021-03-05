//
//  GYSegmentSliderBar.h
//  GYFramework
//
//  Created by Yang Ge on 2021/2/24.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GYSegmentBarContentMode) {
    GYSegmentBarContentModeDefault,  // 自适应
    GYSegmentBarContentModeFill      // 均分
};

NS_ASSUME_NONNULL_BEGIN

@interface GYSegmentSliderBar : UIView

@property (nonatomic, copy) void(^onClickSegment)(NSInteger index);
@property (nonatomic, assign) NSInteger selectedSegmentIndex;

- (instancetype)initWithFrame:(CGRect)frame
                  contentMode:(GYSegmentBarContentMode)contentMode
                selectedIndex:(NSInteger)selectedIndex
                    itemArray:(NSArray<NSString *> *)itemArray;

@end

NS_ASSUME_NONNULL_END
