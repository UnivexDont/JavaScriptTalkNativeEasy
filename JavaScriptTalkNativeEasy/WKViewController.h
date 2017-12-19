//
//  WKViewController.h
//  JavaScriptTalkNativeEasy
//
//  Created by JMan on 13/12/2017.
//  Copyright © 2017 Donter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JavaScriptTalkWKNativeEasy.h"

@protocol wkWebJSEasyProtocol<JavaScriptTalkNativeEasyProtocol>
-(NSString*)showName:(BOOL)isTrue arg2:(NSNumber*)arg2;
@end

@interface WKViewController : UIViewController

@end
