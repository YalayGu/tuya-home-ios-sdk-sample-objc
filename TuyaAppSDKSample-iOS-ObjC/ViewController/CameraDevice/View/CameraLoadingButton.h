//
//  CameraLoadingButton.h
//  TuyaAppSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2023 Tuya Inc. (https://developer.tuya.com/)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CameraLoadingButton : UIButton

- (void)startLoading;
- (void)startLoadingWithEnabled:(BOOL)isEnabled;

- (void)stopLoading;
- (void)stopLoadingWithEnabled:(BOOL)isEnabled;

@end

NS_ASSUME_NONNULL_END
