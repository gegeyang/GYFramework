//
//  UIButton+GYExtend.m
//  GYFramework
//
//  Created by Yang Ge on 2020/12/3.
//  Copyright © 2020 GeYang. All rights reserved.
//

#import "UIButton+GYExtend.h"

@implementation UIButton (GYExtend)

- (CGFloat)gy_navigationWidth:(CGFloat)maxWidth {
    if (self.hidden) {
        return 0;
    }
    CGFloat btnWidth = self.imageView.image.size.width;
    NSString *content = [self titleForState:(self.isSelected ? UIControlStateSelected : (self.isEnabled ? UIControlStateNormal : UIControlStateDisabled))];
    if (content.length > 0) {
        btnWidth += ceilf([content boundingRectWithSize:CGSizeMake(maxWidth, 30.0f)
                                                options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                             attributes:@{NSFontAttributeName: self.titleLabel.font}
                                                context:nil].size.width);
    }
    return btnWidth + self.contentEdgeInsets.left + self.contentEdgeInsets.right + self.imageEdgeInsets.left + self.imageEdgeInsets.right + self.titleEdgeInsets.left + self.titleEdgeInsets.right;
}

- (CGFloat)gy_contentWidth:(CGFloat)maxWidth
                   spacing:(CGFloat)spacing {
    CGFloat btnWidth = self.imageView.image.size.width;
    NSString *content = [self titleForState:(self.isSelected ? UIControlStateSelected : (self.isEnabled ? UIControlStateNormal : UIControlStateDisabled))];
    if (content.length == 0) {
        [self titleForState:UIControlStateNormal];
    }
    if (content.length > 0) {
        if (btnWidth > 0) {
            btnWidth += spacing;
        }
        btnWidth += ceilf([content boundingRectWithSize:CGSizeMake(maxWidth - btnWidth, 30.0f)
                                                options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                             attributes:@{NSFontAttributeName: self.titleLabel.font}
                                                context:nil].size.width);
    }
    return btnWidth;
}

@end
