//
//  MGFashionMenuView.h
//  MGFashionMenu
//
//  Created by Matteo Gobbi on 05/07/2014.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MGAnimationType) {
    MGAnimationTypeBounce,
    MGAnimationTypeSoftBounce,
    MGAnimationTypeHardBounce,
    MGAnimationTypeWave
};

@interface MGFashionMenuView : UIView

@property (atomic, assign, readonly) BOOL isShown;
@property (atomic, assign, readonly) BOOL isAnimating;

- (instancetype)initWithMenuView:(UIView *)menuView;
- (instancetype)initWithMenuView:(UIView *)menuView animationType:(MGAnimationType)animationType;

- (void)show;
- (void)showWithCompletition:(void (^)(void))completion;
- (void)hide;
- (void)hideWithCompletition:(void (^)(void))completion;

@end
