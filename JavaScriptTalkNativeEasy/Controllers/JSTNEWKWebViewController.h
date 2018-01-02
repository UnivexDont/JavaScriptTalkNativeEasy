//
//  WKViewController.h
//  JavaScriptTalkNativeEasy
//
//  Created by JMan on 13/12/2017.
//  Copyright © 2017 Donter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JavaScriptTalkWKNativeEasy.h"

@protocol WKWebJSEasyProtocol<JavaScriptTalkNativeEasyProtocol>
-(NSDictionary *)getUserInfo:(NSDictionary *)dic;
@end

@interface JSTNEWKWebViewController : UIViewController

@end
