//
//  JavaScriptTalkNativeMethodHandler.h
//  JavaScriptTalkNativeEasy
//
//  Created by Univex on 11/12/2017.
//  Copyright © 2017 Donter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
static const int argumentStartIndex = 2;

@interface JavaScriptTalkNativeMethodHandler : NSObject
NS_ASSUME_NONNULL_BEGIN

+(Protocol * __unsafe_unretained _Nonnull * _Nullable)getObjcProtocol:(id _Nullable ) objc count:(unsigned int *_Nullable)outCount;

+(void)addArgument:(JSValue * )jsvalue type:(const char *)cType toInvocation:(NSInvocation* )invocation atIndex:(unsigned int)idx;

+(void)wkAddArgument:(id)jsvalue type:(const char *)cType toInvocation:(NSInvocation* )invocation atIndex:(unsigned int)idx;
+(NSArray *)allDictionaryType;
+(NSArray *)allArrayType;

NS_ASSUME_NONNULL_END
@end

