//
//  JavaScriptTalkNativeMethodHandler.m
//  JavaScriptTalkNativeEasy
//
//  Created by Univex on 11/12/2017.
//  Copyright © 2017 Donter. All rights reserved.
//

#import "JavaScriptTalkNativeMethodHandler.h"
@implementation JavaScriptTalkNativeMethodHandler
+(Protocol * __unsafe_unretained _Nonnull * _Nullable)getObjcProtocol:(id _Nullable ) objc count:(unsigned int *_Nullable)outCount{
    unsigned int protocolCount;
    Protocol * __unsafe_unretained *protocolList = class_copyProtocolList([objc class], &protocolCount);
    Protocol *__unsafe_unretained _Nonnull *returnProtocolList = (Protocol *__unsafe_unretained _Nonnull *)malloc(sizeof(Protocol*)*1);
    
    unsigned int outCountTem = 0;
    for (int index = 0; index < protocolCount; index++) {
        Protocol *protocol_t = protocolList[index];
        unsigned int superProtocolCount=0;
        Protocol * __unsafe_unretained *superProtocolList = protocol_copyProtocolList(protocol_t, &superProtocolCount);
        for (int index = 0; index < superProtocolCount; index++) {
            Protocol *super_protocol_t = superProtocolList[index];
            if ([NSStringFromProtocol(super_protocol_t) isEqualToString:@"JavaScriptTalkNativeEasyProtocol"]) {
                outCountTem++;
                returnProtocolList[index] = protocol_t;
                break;
            }
        }
        if (superProtocolList) {
            free(superProtocolList);
            superProtocolList = NULL;
        }
    }
    if (protocolList) {
        free(protocolList);
        protocolList = NULL;
    }
    *outCount = outCountTem;
    return returnProtocolList;
}

+(void)addArgument:(JSValue *)jsvalue type:(const char *)cType toInvocation:(NSInvocation*)invocation atIndex:(unsigned int)idx{
    
    if (!jsvalue.isNull && !jsvalue.isUndefined ) {
        switch (*cType) {
            case '@':{
                id value = [jsvalue toObject];
                if (value) {
                    [invocation setArgument:&value atIndex:idx];
                }
            }
                
                break;
            case 'i':
            case 'l':
            case 'q':
            case 'L':
            case 'Q':
            case 's':
            case 'C':
            case 'I':
            case 'c':
            case 'S':{
               long long value = jsvalue.isNumber?((NSNumber *)[jsvalue toObject]).longLongValue:0;
                [invocation setArgument:&value atIndex:idx];

            }break;
            case 'f':
            case 'd':{
                double value = jsvalue.isNumber?((NSNumber*)[jsvalue toObject]).doubleValue:0.0;
                [invocation setArgument:&value atIndex:idx];
            }break;
            case 'B':{
                BOOL value = jsvalue.isBoolean?jsvalue.toBool:NO;
                [invocation setArgument:&value atIndex:idx];

            }break;
            default:
                break;
        }

    }
    
}

+(void)wkAddArgument:(id)jsvalue type:(const char *)cType toInvocation:(NSInvocation* )invocation atIndex:(unsigned int)idx{
    
    switch (*cType) {
        case '@':{
            __autoreleasing id value = nil;
            value = jsvalue;
            if (value) {
                [invocation setArgument:&value atIndex:idx];
            }
        }
            
            break;
        case 'i':
        case 'l':
        case 'q':
        case 'L':
        case 'Q':
        case 's':
        case 'C':
        case 'I':
        case 'c':
        case 'S':{
            long long value = 0;
            if([[self allDictionaryType] containsObject:NSStringFromClass([jsvalue class])]){
                NSArray *allKeys = [jsvalue allKeys];
                if (allKeys > 0) {
                    id firstValue = jsvalue[allKeys[0]];
                    value = ([[firstValue class] isSubclassOfClass:[NSNumber class]] || [[firstValue class] isKindOfClass:[NSNumber class]])?((NSNumber*)firstValue).longLongValue:0;
                    
                }
            }else{
                value = ([[jsvalue class] isSubclassOfClass:[NSNumber class]] || [[jsvalue class] isKindOfClass:[NSNumber class]])?((NSNumber *)jsvalue).longLongValue:0;
            }
            [invocation setArgument:&value atIndex:idx];
            
        }break;
        case 'f':
        case 'd':{
            double value = 0.0;
            if([[self allDictionaryType] containsObject:NSStringFromClass([jsvalue class])]){
                NSArray *allKeys = [jsvalue allKeys];
                if (allKeys > 0) {
                    id firstValue = jsvalue[allKeys[0]];
                    value = ([[firstValue class] isSubclassOfClass:[NSNumber class]] || [[firstValue class] isKindOfClass:[NSNumber class]])?((NSNumber*)firstValue).doubleValue:0.0;
                    
                }
            }else{
                value = ([[jsvalue class] isSubclassOfClass:[NSNumber class]] || [[jsvalue class] isKindOfClass:[NSNumber class]])?((NSNumber*)jsvalue).doubleValue:0.0;
            }
            value = ([[jsvalue class] isSubclassOfClass:[NSNumber class]] || [[jsvalue class] isKindOfClass:[NSNumber class]])?((NSNumber*)jsvalue).doubleValue:0.0;
            [invocation setArgument:&value atIndex:idx];
        }break;
        case 'B':{
            BOOL value = NO;
            if([[self allDictionaryType] containsObject:NSStringFromClass([jsvalue class])]){
                NSArray *allKeys = [jsvalue allKeys];
                if (allKeys > 0) {
                    id firstValue = jsvalue[allKeys[0]];
                    value = ([firstValue isKindOfClass:NSClassFromString(@"__NSCFBoolean")] ||[[firstValue class] isSubclassOfClass:[NSNumber class]] ||
                             [[firstValue class] isKindOfClass:[NSNumber class]])?((NSNumber*)firstValue).boolValue:NO;

                }
            }else{
                value = ([jsvalue isKindOfClass:NSClassFromString(@"__NSCFBoolean")] ||[[jsvalue class] isSubclassOfClass:[NSNumber class]] ||
                         [[jsvalue class] isKindOfClass:[NSNumber class]])?((NSNumber*)jsvalue).boolValue:NO;
            }
            [invocation setArgument:&value atIndex:idx];
            
        }break;
        default:
            break;
    }
}

+(id)getReturnValue:(Method) method invocation:(NSInvocation *)invocation{
    char *returnCType =  method_copyReturnType(method);
    switch (*returnCType) {
        case '@':{
            __autoreleasing id returnValue = nil;
            [invocation getReturnValue:&returnValue];
            free(returnCType);
            returnCType = nil;
            return returnValue;
        }
        case 'i':
        case 'l':
        case 'q':
        case 'L':
        case 'Q':
        case 's':
        case 'C':
        case 'I':
        case 'c':
        case 'S':{
            long long returnValue;
            [invocation getReturnValue:&returnValue];
            free(returnCType);
            returnCType = nil;
            return [NSNumber numberWithLongLong:returnValue];
        }break;
        case 'f':
        case 'd':{
            double returnValue;
            [invocation getReturnValue:&returnValue];
            free(returnCType);
            returnCType = nil;
            return [NSNumber numberWithDouble:returnValue];
        }break;
        case 'B':{
            BOOL returnValue;
            [invocation getReturnValue:&returnValue];
            free(returnCType);
            returnCType = nil;
            return returnValue?@"true":@"false";
        }
        default:
            free(returnCType);
            returnCType = nil;
            return nil;
    }
    
}

+(NSArray *)allDictionaryType{
    return @[@"__NSFrozenDictionaryM",@"__NSDictionaryM",@"__NSDictionaryI",@"NSDictionary",@"NSMutableDictionary"];
    
    
}
+(NSArray *)allArrayType{
    return @[@"__NSArrayI",@"__NSArrayM",@"NSArray",@"NSMutableArray"];
    
}

@end
