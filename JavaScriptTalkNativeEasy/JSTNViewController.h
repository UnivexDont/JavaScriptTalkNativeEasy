//
//  ViewController.h
//  JavaScriptTalkNativeEasy
//
//  Created by Univex on 09/12/2017.
//  Copyright © 2017 Donter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JavaScriptTalkNativeEasyProtocol.h"

@protocol webJSEasyProtocol<JavaScriptTalkNativeEasyProtocol>
-(NSString*)testMethod:(BOOL)string;
@end

@interface JSTNViewController : UIViewController


@end

