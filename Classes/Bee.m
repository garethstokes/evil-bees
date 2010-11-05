//
//  Bee.m
//  evil-bees
//
//  Created by gareth stokes on 4/11/10.
//  Copyright 2010 digital five. All rights reserved.
//

#import "Bee.h"


@implementation Bee

@synthesize sprite=_sprite;
@synthesize animation;
@synthesize sheet;
@synthesize action;
@synthesize status;
@synthesize path=_path;

- (id) init {
  CGSize s = [[CCDirector sharedDirector] winSize];
  
  // Create a SpriteSheet -- just a big image which is prepared to 
  // be carved up into smaller images as needed
  sheet = [CCSpriteSheet spriteSheetWithFile:@"bees.png" capacity:50];
  
  // Load sprite frames, which are just a bunch of named rectangle 
  // definitions that go along with the image in a sprite sheet
  [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bees.plist"];
  
  // Finally, create a sprite, using the name of a frame in our frame cache.
  _sprite = [CCSprite spriteWithSpriteFrameName:@"bee1.png"];
  _sprite.position = ccp(rand() % 480, rand() % 320);
  
  NSMutableArray* idleFrames = [NSMutableArray array];
  [idleFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bee1.png"]];
  [idleFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bee2.png"]];
  
  animation = [CCAnimation animationWithName:@"dance" delay:0.1f frames:idleFrames];
  
  action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]] retain];
  //playIdleAction = [[CCCallFunc actionWithTarget:self selector:@selector(action)] retain];
  
  _path = [[NSMutableArray alloc] init];
  
  [sheet addChild:_sprite];  
  [_sprite runAction:[CCRepeatForever actionWithAction: action]];
  [self explore];
  
  return [super init];
}

- (void) explore {
  status = @"exploring...";
  
  CGPoint currentPosition = [_sprite position];
  CGPoint random_point = ccp(rand() % 480, rand() % 320);
  
  [_sprite setFlipX:currentPosition.x > random_point.x];
  
  id a = [CCMoveTo actionWithDuration:5 position:random_point];
  id m = [[CCCallFunc actionWithTarget:self selector:@selector(explore)] retain];
  [_sprite runAction: [CCSequence actions:a, m, nil]];
  [m release];
}

- (void)startPoint:(CGPoint)startPoint {
  if (_sequence != nil) {
    [_sequence stop];
    [_sequence release];
    _sequence = nil;
  }
  [_path removeAllObjects];
  
  [_path addObject:[NSValue valueWithCGPoint:startPoint]];
  
  [_sprite stopAllActions];
  [_sprite runAction:[CCRepeatForever actionWithAction: action]];
  
  CCIntervalAction *nextAction = [CCMoveTo actionWithDuration:0.1 position:startPoint];
  CCIntervalAction *movedDelegate = [CCCallFunc actionWithTarget:self selector:@selector(moved)];
  _startSequence = [[CCSequence actions:nextAction, movedDelegate, nil] retain];
}

- (void)addPoint:(CGPoint)nextPoint {
  CCIntervalAction *nextAction = [CCMoveTo actionWithDuration:0.1 position:nextPoint];
  CCIntervalAction *nextMovedDelegate = [CCCallFunc actionWithTarget:self selector:@selector(moved)];
  CCIntervalAction *nextSequence = [CCSequence actions:nextAction, nextMovedDelegate, nil];
  
  // for tracing the path
  [_path addObject:[NSValue valueWithCGPoint:nextPoint]];
                                    
  CCIntervalAction *prevAction;

  if (_sequence == nil) {
    prevAction = _startSequence;
  } else {
    prevAction = _sequence;
  }
  
  _sequence = [[CCSequence actionOne:prevAction two: nextSequence] retain];
}

- (void)move {
  if (_sequence != nil) {
    [_sprite runAction: _sequence];
  }
}

- (void)moved {
  [_path removeObjectAtIndex:0];
  if ([_path count] == 0) {
    [self explore];
    return;
  }
  CGPoint lastPosition = [(NSValue *)[_path objectAtIndex:0] CGPointValue];
  CGPoint currentPosition = [_sprite position];
  
  //NSLog(@"currentPosition.x: %f, lastPosition.x: %f", 
  
  [_sprite setFlipX:currentPosition.x > lastPosition.x];
}

@end
