//
//  JavaScriptTalkNativeEasy.h
//  JavaScriptTalkNativeEasy
//
//  Created by Univex on 11/12/2017.
//  Copyright © 2017 Donter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JavaScriptTalkNativeEasyProtocol.h"
@interface JavaScriptTalkNativeEasy : NSObject
@property(weak,nonatomic)id<NSObject>delegate;
+(instancetype)jsTNEasy:(UIWebView *)webView;
@end
