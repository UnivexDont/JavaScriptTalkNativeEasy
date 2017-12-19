//
//  JavaScriptTalkWKNativeEasy.m
//  JavaScriptTalkNativeEasy
//
//  Created by JMan on 15/12/2017.
//  Copyright © 2017 Donter. All rights reserved.
//
#import "JavaScriptTalkWKNativeEasy.h"
#import "JavaScriptTalkNativeMethodHandler.h"

@interface JavaScriptTalkWKNativeEasy()<WKScriptMessageHandler>
@property(nonatomic)NSMutableDictionary *protocolMethods;
@property(nonatomic, weak)WKWebView *webView;

@end

@implementation JavaScriptTalkWKNativeEasy

-(instancetype)init{
    if (self = [super init]) {
        _protocolMethods = [NSMutableDictionary dictionary];
    }
    return self;
}

+(instancetype)jsTNEasy:(WKWebView *)webView{
    JavaScriptTalkWKNativeEasy *jsTNEasy = [[self alloc] init];
    jsTNEasy.webView = webView;
    return jsTNEasy;
}

-(void)setDelegate:(id<NSObject>)delegate{
    _delegate = delegate;
    if (_delegate) {
        [self _setUpScriptMessageHandler];
    }
}

-(void)_setUpScriptMessageHandler{
    if (_webView && _webView.configuration) {
        WKUserContentController *userContentController = _webView.configuration.userContentController;
        if (userContentController) {
            [self _getProtocolMethods];
            NSArray *methods = [_protocolMethods allKeys];
            for (NSString *method in methods) {
                [userContentController addScriptMessageHandler:self name:method];
            }
        }
    }
}

-(void)_getProtocolMethods{
    
    unsigned int delegateProtocolCount;
    Protocol * __unsafe_unretained _Nonnull * _Nullable  protocolList = [JavaScriptTalkNativeMethodHandler getObjcProtocol:[_delegate class] count:&delegateProtocolCount];
    for (int indexProtocol = 0; indexProtocol < delegateProtocolCount; indexProtocol++) {
        Protocol *delegateProtocol = protocolList[indexProtocol];
        unsigned int methodCount;
        struct objc_method_description * _Nullable methodDes = protocol_copyMethodDescriptionList(delegateProtocol, YES, YES, &methodCount);
        for (int index = 0; index<methodCount; index++) {
            struct objc_method_description method_des  = methodDes[index];
            SEL selector = method_des.name;
            NSString *selectorName = NSStringFromSelector(selector);
            selectorName = [[selectorName componentsSeparatedByString:@":"] objectAtIndex:0];
            if (selectorName.length>0 && selector) {
                [_protocolMethods setObject:NSStringFromSelector(selector) forKey:selectorName];
                
            }
        }
        if (methodDes) {
            free(methodDes);
            methodDes = NULL;

        }
    }
    if (protocolList) {
        free(protocolList);
        protocolList = NULL;
    }
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSString *selectorName = [_protocolMethods objectForKey:message.name];
    if (selectorName) {
        SEL selector = NSSelectorFromString(selectorName);
        NSMethodSignature *signature = [[_delegate class] instanceMethodSignatureForSelector:selector];
        id returnValue;
        if (signature) {
            
            Method method = class_getInstanceMethod([_delegate class], selector);
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            NSString *jsCallBack = [self _jsCallBackFromNatvie:message];
            if (jsCallBack) {
                NSMutableDictionary *arguments = [[message body] mutableCopy];
                [arguments removeObjectForKey:@"callBackFromNative"];
                _handleJSArgument(arguments, method, invocation);
            }else{
                _handleJSArgument(message.body, method, invocation);
            }
            [invocation setSelector:selector];
            [invocation invokeWithTarget:_delegate];
            [invocation getReturnValue:&returnValue];
            
            if (jsCallBack && returnValue) {
                [_webView evaluateJavaScript:[NSString stringWithFormat:@"%@('%@')",jsCallBack,returnValue] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                }];
            }
        }
        
    }

}

void _handleJSArgument(id arguments,Method method, NSInvocation *invocation){
    
    unsigned int argmnetsCount = method_getNumberOfArguments(method);
    if (argmnetsCount < 3 || !arguments) {
        return;
    }
    if (argmnetsCount == 3) {
        char * cType = method_copyArgumentType(method, 2);
        [JavaScriptTalkNativeMethodHandler wkAddArgument:arguments type:cType toInvocation:invocation atIndex:2];
        if (cType) {
            free(cType);
            cType = NULL;
        }
    }else{
        _handleMutipleArguments(arguments, method, invocation);
    }
}

void _handleMutipleArguments(id arguments, Method method, NSInvocation *invocation){
    unsigned int argmnetsCount = method_getNumberOfArguments(method);
    if ([[JavaScriptTalkNativeMethodHandler allArrayType] containsObject:NSStringFromClass([arguments class])]) {
        NSArray *argumentArray = [arguments copy];
        for (unsigned int index = argumentStartIndex; index < argmnetsCount; index++) {
            char * cType = method_copyArgumentType(method, index);
            unsigned int jsIndex = index - argumentStartIndex;
            if (jsIndex<argumentArray.count) {
                [JavaScriptTalkNativeMethodHandler wkAddArgument:[argumentArray objectAtIndex:jsIndex] type:cType toInvocation:invocation atIndex:index];
            }
            if (cType) {
                free(cType);
                cType = NULL;
            }

        }
    }else if([[JavaScriptTalkNativeMethodHandler allDictionaryType] containsObject:NSStringFromClass([arguments class])]){
        NSDictionary *argumentDic = (NSDictionary *)[arguments copy];
        NSArray *argumentArray = [argumentDic allKeys];
        for (unsigned int index = argumentStartIndex; index < argmnetsCount; index++) {
            char * cType = method_copyArgumentType(method, index);
            unsigned int jsIndex = index - argumentStartIndex;
            if (jsIndex<argumentArray.count) {
                id argumentFromJs = [argumentDic objectForKey:[argumentArray objectAtIndex:jsIndex]];
                [JavaScriptTalkNativeMethodHandler wkAddArgument:argumentFromJs type:cType toInvocation:invocation atIndex:index];
            }
            if (cType) {
                free(cType);
                cType = NULL;
            }
            
        }
    }
}


-(NSString *)_jsCallBackFromNatvie:(WKScriptMessage *)messge{
    
    if ([NSStringFromClass([messge.body class]) isEqualToString:@"__NSFrozenDictionaryM"] || [[messge.body class] isKindOfClass:[NSDictionary class]]) {
        return messge.body[@"callBackFromNative"];
    }
    return nil;
}

@end
