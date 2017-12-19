//
//  JavaScriptTalkWKNativeEasy.h
//  JavaScriptTalkNativeEasy
//
//  Created by JMan on 15/12/2017.
//  Copyright © 2017 Donter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "JavaScriptTalkNativeEasyProtocol.h"

@interface JavaScriptTalkWKNativeEasy : NSObject
@property(weak,nonatomic)id<NSObject>delegate;
+(instancetype)jsTNEasy:(WKWebView *)webView;
@end
