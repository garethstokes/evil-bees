//
//  HelloWorldLayer.h
//  evil-bees
//
//  Created by gareth stokes on 3/11/10.
//  Copyright fact equals true 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class Bee;

// HelloWorld Layer
@interface HelloWorld : CCLayer {
@private
  NSMutableArray *_bees;
  NSMutableArray *_flowers;
  Bee *_currentBee;
}

@property (nonatomic, retain) Bee *currentBee;

+(id) scene;
- (void) removeFlowersMarkedForRemoval;
- (void) checkIfBeIsAboveFlower;
- (void) rollDiceToSetRandomFlower;

@end
