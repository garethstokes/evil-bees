//
//  Bee.h
//  evil-bees
//
//  Created by gareth stokes on 4/11/10.
//  Copyright 2010 digital five. All rights reserved.
//

#import "cocos2d.h"
#import "Flower.h"


@interface Bee : NSObject {
  CCAnimation* animation;
  CCSpriteSheet* sheet;
  CCAnimate* action;
  NSString* status;
@private
  CCSprite* _sprite;
  CCIntervalAction *_startSequence;
  CCSequence *_sequence;
  NSMutableArray *_path;
}

@property(nonatomic, retain) CCSprite* sprite;
@property(nonatomic, retain) CCAnimation* animation;
@property(nonatomic, retain) CCSpriteSheet* sheet;
@property(nonatomic, retain) CCAnimate* action;
@property(nonatomic, retain) NSString* status;
@property(nonatomic, retain) NSMutableArray* path;

- (void) explore;
- (void) startPoint:(CGPoint)startPoint;
- (void) addPoint:(CGPoint)nextPoint;
- (void) move;
- (CCSequence *)generateDelegateSequence:(CGPoint)point;
- (BOOL) isAbove: (Flower *) flower;

@end
