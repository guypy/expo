 #import "RNGestureHandlerEvents.h"

@implementation RNGestureHandlerEventExtraData

- (instancetype)initWithData:(NSDictionary *)data;
{
    if ((self = [super init])) {
        _data = data;
    }
    return self;
}

+ (RNGestureHandlerEventExtraData *)forPosition:(CGPoint)position
{
    return [[RNGestureHandlerEventExtraData alloc]
            initWithData:@{ @"x": @(position.x), @"y": @(position.y) }];
}

+ (RNGestureHandlerEventExtraData *)forPan:(CGPoint)position withTranslation:(CGPoint)translation withVelocity:(CGPoint)velocity
{
    return [[RNGestureHandlerEventExtraData alloc]
            initWithData:@{
                           @"x": @(position.x),
                           @"y": @(position.y),
                           @"translationX": @(translation.x),
                           @"translationY": @(translation.y),
                           @"velocityX": @(velocity.x),
                           @"velocityY": @(velocity.y)}];
}

+ (RNGestureHandlerEventExtraData *)forPinch:(CGFloat)scale withVelocity:(CGFloat)velocity
{
    return [[RNGestureHandlerEventExtraData alloc]
            initWithData:@{@"scale": @(scale), @"velocity": @(velocity)}];
}

+ (RNGestureHandlerEventExtraData *)forRotation:(CGFloat)rotation withVelocity:(CGFloat)velocity
{
    return [[RNGestureHandlerEventExtraData alloc]
            initWithData:@{@"rotation": @(rotation), @"velocity": @(velocity)}];
}

+ (RNGestureHandlerEventExtraData *)forPointerInside:(BOOL)pointerInside;
{
    return [[RNGestureHandlerEventExtraData alloc] initWithData:@{@"pointerInside": @(pointerInside)}];
}

@end


@implementation RNGestureHandlerEvent
{
    NSNumber *_handlerTag;
    RNGestureHandlerState _state;
    RNGestureHandlerEventExtraData *_extraData;
}

@synthesize viewTag = _viewTag;
@synthesize coalescingKey = _coalescingKey;

- (instancetype)initWithRactTag:(NSNumber *)reactTag
                     handlerTag:(NSNumber *)handlerTag
                          state:(RNGestureHandlerState)state
                      extraData:(RNGestureHandlerEventExtraData *)extraData
{
    static uint16_t coalescingKey = 0;
    if ((self = [super init])) {
        _viewTag = reactTag;
        _handlerTag = handlerTag;
        _state = state;
        _extraData = extraData;
        _coalescingKey = coalescingKey++;
    }
    return self;
}

RCT_NOT_IMPLEMENTED(- (instancetype)init)

- (NSString *)eventName
{
    return @"onGestureHandlerEvent";
}

- (BOOL)canCoalesce
{
    // TODO: event coalescing
    return NO;
}

- (id<RCTEvent>)coalesceWithEvent:(id<RCTEvent>)newEvent;
{
    return newEvent;
}

+ (NSString *)moduleDotMethod
{
    return @"RCTEventEmitter.receiveEvent";
}

- (NSArray *)arguments
{
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:_extraData.data];
    [body setObject:_viewTag forKey:@"target"];
    [body setObject:_handlerTag forKey:@"handlerTag"];
    [body setObject:@(_state) forKey:@"state"];
    return @[self.viewTag, @"topGestureHandlerEvent", body];
}

@end


@implementation RNGestureHandlerStateChange
{
    NSNumber *_handlerTag;
    RNGestureHandlerState _state;
    RNGestureHandlerState _prevState;
    RNGestureHandlerEventExtraData *_extraData;
}

@synthesize viewTag = _viewTag;
@synthesize coalescingKey = _coalescingKey;

- (instancetype)initWithRactTag:(NSNumber *)reactTag
                     handlerTag:(NSNumber *)handlerTag
                          state:(RNGestureHandlerState)state
                      prevState:(RNGestureHandlerState)prevState
                      extraData:(RNGestureHandlerEventExtraData *)extraData
{
    static uint16_t coalescingKey = 0;
    if ((self = [super init])) {
        _viewTag = reactTag;
        _handlerTag = handlerTag;
        _state = state;
        _prevState = prevState;
        _extraData = extraData;
        _coalescingKey = coalescingKey++;
    }
    return self;
}

RCT_NOT_IMPLEMENTED(- (instancetype)init)

- (NSString *)eventName
{
    return @"onGestureHandlerStateChange";
}

- (BOOL)canCoalesce
{
    // TODO: event coalescing
    return NO;
}

- (id<RCTEvent>)coalesceWithEvent:(id<RCTEvent>)newEvent;
{
    return newEvent;
}

+ (NSString *)moduleDotMethod
{
    return @"RCTEventEmitter.receiveEvent";
}

- (NSArray *)arguments
{
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:_extraData.data];
    [body setObject:_viewTag forKey:@"target"];
    [body setObject:_handlerTag forKey:@"handlerTag"];
    [body setObject:@(_state) forKey:@"state"];
    [body setObject:@(_prevState) forKey:@"oldState"];
    return @[self.viewTag, @"topGestureHandlerStateChange", body];
}

@end
