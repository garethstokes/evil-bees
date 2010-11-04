//
//  HelloWorldLayer.m
//  evil-bees
//
//  Created by gareth stokes on 3/11/10.
//  Copyright digital five 2010. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "CCTouchDispatcher.h"

CCSprite* bee;
CCAnimation* idleAnimation;
CCSpriteSheet *sheet;
CCAnimate* idleAction;
CCCallFunc *playIdleAction;
NSMutableArray* path; 


// HelloWorld implementation
@implementation HelloWorld

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
	
    // register to receive targeted touch events
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                     priority:0
                                              swallowsTouches:YES];
    
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    path = [[NSMutableArray alloc] init];
    
		// Create a SpriteSheet -- just a big image which is prepared to 
    // be carved up into smaller images as needed
    sheet = [CCSpriteSheet spriteSheetWithFile:@"bees.png" capacity:50];
    
    // Load sprite frames, which are just a bunch of named rectangle 
    // definitions that go along with the image in a sprite sheet
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bees.plist"];
    
    // Finally, create a sprite, using the name of a frame in our frame cache.
    bee = [CCSprite spriteWithSpriteFrameName:@"bee1.png"];
    bee.position = ccp( s.width/2-80, s.height/2);
    
    // Add the sprite as a child of the sheet, so that it knows where to get its image data.
    [sheet addChild:bee];
    
    // Add sprite sheet to parent (it won't draw anything itself, but 
    // needs to be there so that it's in the rendering pipeline)
    [self addChild:sheet];
    
    NSMutableArray* idleFrames = [NSMutableArray array];
    [idleFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bee1.png"]];
    [idleFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bee2.png"]];
    
    idleAnimation = [CCAnimation animationWithName:@"dance" delay:0.1f frames:idleFrames];
    
    idleAction = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:idleAnimation]] retain];
    playIdleAction = [[CCCallFunc actionWithTarget:self selector:@selector(playIdle:)] retain];
    
		[bee runAction:[CCRepeatForever actionWithAction: idleAction]];
    [self move];
  }
	return self;
}

-(void) draw
{
  //ccDrawPoint(ccp(50, 50));
  //ccDrawLine(ccp(50, 50), ccp(100, 100));
  for (int i = 0; i < [path count]; i++) {
    //NSValue* val = [path objectAtIndex:i];
    //CGPoint p = [val CGPointValue];
    //ccDrawPoint(ccp(p.y, p.x));
  }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  [path removeAllObjects];
  return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
  CGPoint point = [touch locationInView:[touch view]];
  id p = [NSValue valueWithCGPoint:point];
  [path addObject:p];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
  if ([path count] < 1) {
    return;
  }
  
  NSValue* val = [path objectAtIndex:0];
  CGPoint p = [val CGPointValue];
  
  CGPoint startingPoint;
  startingPoint.x = p.y;
  startingPoint.y = p.x;
  
  id action = [CCMoveTo actionWithDuration:0.5 position:startingPoint];
  id m = [[CCCallFunc actionWithTarget:self selector:@selector(move)] retain];
  [bee runAction: [CCSequence actions:action, m, nil]];
  [m release];
}

- (void)move {
  CGPoint currentPosition = [bee position];
  
  if ([path count] == 0) {
    CGPoint random_point = ccp(rand() % 480, rand() % 320);
    
    [bee setFlipX:currentPosition.x > random_point.x];
       
    id action = [CCMoveTo actionWithDuration:2 position:random_point];
    id m = [[CCCallFunc actionWithTarget:self selector:@selector(move)] retain];
    [bee runAction: [CCSequence actions:action, m, nil]];
    [m release];
    return;
  }
  
  [path removeObjectAtIndex:0];
   
  NSValue* val = [path objectAtIndex:0];
  CGPoint p = [val CGPointValue];
  CGPoint startingPoint;
  startingPoint.x = p.y;
  startingPoint.y = p.x;
  
  //NSLog(@"currentPosition.x: )
  [bee setFlipX:currentPosition.x > p.y];
 
  id action = [CCMoveTo actionWithDuration:0.1 position:startingPoint];
  id m = [[CCCallFunc actionWithTarget:self selector:@selector(move)] retain];
  [bee runAction: [CCSequence actions:action, m, nil]];
  [m release];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
