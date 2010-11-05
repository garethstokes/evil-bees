//
//  Bee.m
//  evil-bees
//
//  Created by gareth stokes on 4/11/10.
//  Copyright 2010 digital five. All rights reserved.
//

#import "Bee.h"


@implementation Bee

@synthesize sprite;
@synthesize animation;
@synthesize sheet;
@synthesize action;
@synthesize status;

- (id) init {
  CGSize s = [[CCDirector sharedDirector] winSize];
  
  // Create a SpriteSheet -- just a big image which is prepared to 
  // be carved up into smaller images as needed
  sheet = [CCSpriteSheet spriteSheetWithFile:@"bees.png" capacity:50];
  
  // Load sprite frames, which are just a bunch of named rectangle 
  // definitions that go along with the image in a sprite sheet
  [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bees.plist"];
  
  // Finally, create a sprite, using the name of a frame in our frame cache.
  sprite = [CCSprite spriteWithSpriteFrameName:@"bee1.png"];
  sprite.position = ccp( s.width/2-80, s.height/2);
  
  NSMutableArray* idleFrames = [NSMutableArray array];
  [idleFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bee1.png"]];
  [idleFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bee2.png"]];
  
  animation = [CCAnimation animationWithName:@"dance" delay:0.1f frames:idleFrames];
  
  action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]] retain];
  //playIdleAction = [[CCCallFunc actionWithTarget:self selector:@selector(action)] retain];
  
  [sheet addChild:sprite];  
  [sprite runAction:[CCRepeatForever actionWithAction: action]];
  //[self explore];
  
  return [super init];
}

- (void) explore {
  status = @"exploring...";
  
  CGPoint currentPosition = [sprite position];
  CGPoint random_point = ccp(rand() % 480, rand() % 320);
  
  [sprite setFlipX:currentPosition.x > random_point.x];
  
  id a = [CCMoveTo actionWithDuration:2 position:random_point];
  id m = [[CCCallFunc actionWithTarget:self selector:@selector(explore)] retain];
  [sprite runAction: [CCSequence actions:a, m, nil]];
  [m release];
}

- (void)startPoint:(CGPoint)startPoint {
  if (_sequence != nil) {
    [_sequence stop];
    [_sequence release];
    _sequence = nil;
  }
  _startAction = [[CCMoveTo actionWithDuration:0.1 position:startPoint] retain];
}

- (void)addPoint:(CGPoint)nextPoint {
  CCIntervalAction *nextAction = [CCMoveTo actionWithDuration:0.1 position:nextPoint];

  if (_sequence == nil) {
    NSLog(@"We've don't have a sequence yet");
  } else {
    NSLog(@"We've already have a sequence");
  }

  CCIntervalAction *prevAction;

  if (_sequence == nil) {
    prevAction = _startAction;
  } else {
    prevAction = _sequence;
  }

  NSLog(@"prevAction %@", prevAction);
  _sequence = [[CCSequence actionOne:prevAction two: nextAction] retain];
}

- (void)move {
  [[self sprite] runAction: _sequence];
}

@end
