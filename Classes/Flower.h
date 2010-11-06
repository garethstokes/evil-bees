//
//  Flower.h
//  evil-bees
//
//  Created by gareth stokes on 6/11/10.
//  Copyright 2010 fact equals true. All rights reserved.
//

#import "cocos2d.h"

@class Bee;

@interface Flower : CCSprite {
  BOOL _hasBee;
  
@private
  Bee *_currentBee;
  BOOL _toBeRemoved;
  int _beeTicks;
  BOOL _hasPollen;
}

- (Flower *)initBleh;
- (void) add:(Bee *) bee;
- (BOOL) removeBeeIfHasFinished;
- (BOOL) hasBee;
- (void) markForRemoval;
- (BOOL) toBeRemoved;
- (BOOL) hasPollen;

@end
