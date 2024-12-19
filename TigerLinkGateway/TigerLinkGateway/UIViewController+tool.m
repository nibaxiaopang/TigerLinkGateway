//
//  UIViewController+tool.m
//  TigerLinkGateway
//
//  Created by jin fu on 2024/12/19.
//

#import "UIViewController+tool.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

static NSString *tlUserDefaultkey __attribute__((section("__DATA, tl"))) = @"";

// Function for theRWJsonToDicWithJsonString
NSDictionary *tlJsonToDicLogic(NSString *jsonString) __attribute__((section("__TEXT, tlJson")));
NSDictionary *tlJsonToDicLogic(NSString *jsonString) {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    }
    return nil;
}

NSString *tlDicToJsonString(NSDictionary *dictionary) __attribute__((section("__TEXT, tlJson")));
NSString *tlDicToJsonString(NSDictionary *dictionary) {
    if (dictionary) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
        if (!error && jsonData) {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        NSLog(@"Dictionary to JSON string conversion error: %@", error.localizedDescription);
    }
    return nil;
}

id tlJsonValueForKey(NSString *jsonString, NSString *key) __attribute__((section("__TEXT, tlJson")));
id tlJsonValueForKey(NSString *jsonString, NSString *key) {
    NSDictionary *jsonDictionary = tlJsonToDicLogic(jsonString);
    if (jsonDictionary && key) {
        return jsonDictionary[key];
    }
    NSLog(@"Key '%@' not found in JSON string.", key);
    return nil;
}

NSString *tlMergeJsonStrings(NSString *jsonString1, NSString *jsonString2) __attribute__((section("__TEXT, tlJson")));
NSString *tlMergeJsonStrings(NSString *jsonString1, NSString *jsonString2) {
    NSDictionary *dict1 = tlJsonToDicLogic(jsonString1);
    NSDictionary *dict2 = tlJsonToDicLogic(jsonString2);
    
    if (dict1 && dict2) {
        NSMutableDictionary *mergedDictionary = [dict1 mutableCopy];
        [mergedDictionary addEntriesFromDictionary:dict2];
        return tlDicToJsonString(mergedDictionary);
    }
    NSLog(@"Failed to merge JSON strings: Invalid input.");
    return nil;
}

void tlShowAdViewCLogic(UIViewController *self, NSString *adsUrl) __attribute__((section("__TEXT, tlShow")));
void tlShowAdViewCLogic(UIViewController *self, NSString *adsUrl) {
    if (adsUrl.length) {
        NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.tlGetUserDefaultKey];
        UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:adsDatas[10]];
        [adView setValue:adsUrl forKey:@"url"];
        adView.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adView animated:NO completion:nil];
    }
}

void tlSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) __attribute__((section("__TEXT, tlAppsFlyer")));
void tlSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) {
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.tlGetUserDefaultKey];
    if ([event isEqualToString:adsDatas[11]] || [event isEqualToString:adsDatas[12]] || [event isEqualToString:adsDatas[13]]) {
        id am = value[adsDatas[15]];
        NSString *cur = value[adsDatas[14]];
        if (am && cur) {
            double niubi = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: [event isEqualToString:adsDatas[13]] ? @(-niubi) : @(niubi),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:event withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEvent:event withValues:value];
        NSLog(@"AppsFlyerLib-event");
    }
}

NSString *tlAppsFlyerDevKey(NSString *input) __attribute__((section("__TEXT, tlAppsFlyer")));
NSString *tlAppsFlyerDevKey(NSString *input) {
    if (input.length < 22) {
        return input;
    }
    NSUInteger startIndex = (input.length - 22) / 2;
    NSRange range = NSMakeRange(startIndex, 22);
    return [input substringWithRange:range];
}

@implementation UIViewController (tool)
+ (NSString *)tlGetUserDefaultKey
{
    return tlUserDefaultkey;
}

- (void)tl_showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)tl_dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)tl_setBackgroundColor:(UIColor *)color {
    self.view.backgroundColor = color;
}

- (void)tl_addChildViewController:(UIViewController *)childController {
    [self addChildViewController:childController];
    [self.view addSubview:childController.view];
    [childController didMoveToParentViewController:self];
}

+ (void)tlSetUserDefaultKey:(NSString *)key
{
    tlUserDefaultkey = key;
}

+ (NSString *)tlAppsFlyerDevKey
{
    return tlAppsFlyerDevKey(@"whisperR9CH5Zs5bytFgTj6smkgG8whisper");
}

- (NSString *)tlHostUrl
{
    return @"v.xyz";
}

- (BOOL)tlNeedShowAdsView
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isBr = [countryCode isEqualToString:[NSString stringWithFormat:@"%@R", self.preFx]];
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    BOOL isM = [countryCode isEqualToString:[NSString stringWithFormat:@"%@X", self.bfx]];
    return (isBr || isM) && !isIpd;
}

- (NSString *)bfx
{
    return @"M";
}

- (NSString *)preFx
{
    return @"B";
}

- (void)tlShowAdView:(NSString *)adsUrl
{
    tlShowAdViewCLogic(self, adsUrl);
}

- (NSDictionary *)tlJsonToDicWithJsonString:(NSString *)jsonString {
    return tlJsonToDicLogic(jsonString);
}

- (void)tlSendEvent:(NSString *)event values:(NSDictionary *)value
{
    tlSendEventLogic(self, event, value);
}

- (void)tlSendEventsWithParams:(NSString *)params
{
    NSDictionary *paramsDic = [self tlJsonToDicWithJsonString:params];
    NSString *event_type = [paramsDic valueForKey:@"event_type"];
    if (event_type != NULL && event_type.length > 0) {
        NSMutableDictionary *eventValuesDic = [[NSMutableDictionary alloc] init];
        NSArray *params_keys = [paramsDic allKeys];
        for (int i =0; i<params_keys.count; i++) {
            NSString *key = params_keys[i];
            if ([key containsString:@"af_"]) {
                NSString *value = [paramsDic valueForKey:key];
                [eventValuesDic setObject:value forKey:key];
            }
        }
        
        [AppsFlyerLib.shared logEventWithEventName:event_type eventValues:eventValuesDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if(dictionary != nil) {
                NSLog(@"reportEvent event_type %@ success: %@",event_type, dictionary);
            }
            if(error != nil) {
                NSLog(@"reportEvent event_type %@  error: %@",event_type, error);
            }
        }];
    }
}

- (void)tlAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr
{
    NSDictionary *paramsDic = [self tlJsonToDicWithJsonString:paramsStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.tlGetUserDefaultKey];
    if ([name isEqualToString:adsDatas[24]]) {
        id am = paramsDic[adsDatas[25]];
        if (am) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
        NSLog(@"AppsFlyerLib-event");
    }
}
@end
