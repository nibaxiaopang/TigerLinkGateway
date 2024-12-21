//
//  UIViewController+tool.h
//  TigerLinkGateway
//
//  Created by TigerLink Gateway on 2024/12/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (tool)

+ (NSString *)tlGetUserDefaultKey;

- (void)tl_showAlertWithTitle:(NSString *)title message:(NSString *)message;

- (void)tl_dismissKeyboard;

- (void)tl_setBackgroundColor:(UIColor *)color;

- (void)tl_addChildViewController:(UIViewController *)childController;

+ (void)tlSetUserDefaultKey:(NSString *)key;

- (void)tlSendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)tlAppsFlyerDevKey;

- (NSString *)tlHostUrl;

- (BOOL)tlNeedShowAdsView;

- (void)tlShowAdView:(NSString *)adsUrl;

- (void)tlSendEventsWithParams:(NSString *)params;

- (NSDictionary *)tlJsonToDicWithJsonString:(NSString *)jsonString;

- (void)tlAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr;

- (void)tlAfSendEventWithName:(NSString *)name value:(NSString *)valueStr;

- (NSString *)ctLowercase:(NSString *)org;

@end

NS_ASSUME_NONNULL_END
