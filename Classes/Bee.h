//
//  Bee.h
//  evil-bees
//
//  Created by gareth stokes on 4/11/10.
//  Copyright 2010 digital five. All rights reserved.
//

#import "cocos2d.h"


@interface Bee : NSObject {
  CCSprite* sprite;
  CCAnimation* animation;
  CCSpriteSheet* sheet;
  CCAnimate* action;
  NSString* status;
}

@property(nonatomic, retain) CCSprite* sprite;
@property(nonatomic, retain) CCAnimation* animation;
@property(nonatomic, retain) CCSpriteSheet* sheet;
@property(nonatomic, retain) CCAnimate* action;
@property(nonatomic, retain) NSString* status;

- (void) explore;
- (void) moveTo:(CGPoint) point;

@end
