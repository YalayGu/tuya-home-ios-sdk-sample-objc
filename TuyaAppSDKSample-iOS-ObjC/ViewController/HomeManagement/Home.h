//
//  Home.h
//  ThingAppSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Thing Inc. (https://developer.tuya.com/)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Home : NSObject
+ (ThingSmartHomeModel *)getCurrentHome;
+ (void)setCurrentHome:(nullable ThingSmartHomeModel *)homeModel;
@end

NS_ASSUME_NONNULL_END
