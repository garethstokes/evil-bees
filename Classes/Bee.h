//
//  Bee.h
//  evil-bees
//
//  Created by gareth stokes on 4/11/10.
//  Copyright 2010 fact equals true. All rights reserved.
//

#import "cocos2d.h"
#import "Flower.h"


@interface Bee : NSObject {
  CCAnimation* animation;
  CCSpriteSheet* sheet;
  CCAnimate* action;
@private
  CCSprite* _sprite;
  CCIntervalAction *_startSequence;
  CCSequence *_sequence;
  NSMutableArray *_path;
  int _points;
}

@property(nonatomic, retain) CCSprite* sprite;
@property(nonatomic, retain) CCAnimation* animation;
@property(nonatomic, retain) CCSpriteSheet* sheet;
@property(nonatomic, retain) CCAnimate* action;
@property(nonatomic, retain) NSMutableArray* path;
@property(nonatomic) int points;

- (void) explore;
- (void) startPoint:(CGPoint)startPoint;
- (void) addPoint:(CGPoint)nextPoint;
- (void) move;
- (CCSequence *)generateDelegateSequence:(CGPoint)point;
- (BOOL) isAbove: (Flower *) flower;
- (void) stop;
- (void) play;
- (void) attachTo: (Flower *) flower;

@end
