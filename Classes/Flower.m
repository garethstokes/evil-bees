//
//  Flower.m
//  evil-bees
//
//  Created by gareth stokes on 6/11/10.
//  Copyright 2010 fact equals true. All rights reserved.
//

#import "Flower.h"
#import "Bee.h"
#import "cocos2d.h"

@implementation Flower

- (id) initBleh
{
  if ((self = [super initWithFile:@"flower.png"])) {
    _hasBee = NO;
    _toBeRemoved = NO;
    _hasPollen = YES;
  }
  return self;
}

- (void) add:(Bee *) bee
{
  NSLog(@"adding bee");
  _currentBee = bee;
  _hasBee = YES;
  _beeTicks = 0;
}

- (BOOL) removeBeeIfHasFinished
{
  NSLog(@"bee ticks: %d", _beeTicks);
  _hasPollen = NO;
  
  if (_beeTicks < 6) {
    ++_beeTicks;
    return NO;
  }
  
  [_currentBee explore];
  _currentBee.points++;
  _currentBee = nil;
  _hasBee = NO;
  
  return YES;
}

- (BOOL) hasBee { return _hasBee; }
- (void) markForRemoval { _toBeRemoved = YES; }
- (BOOL) toBeRemoved { return _toBeRemoved; }
- (BOOL) hasPollen { return _hasPollen; }

@end
