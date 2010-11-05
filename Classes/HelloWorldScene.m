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
#import "Bee.h"

CCLabel* status;


// HelloWorld implementation
@implementation HelloWorld

@synthesize path=_path;
@synthesize bee=_bee;

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
    self.bee = [[Bee alloc] init];
    self.path = [[NSMutableArray alloc] init];

    
		// Add the sprite as a child of the sheet, so that it knows where to get its image data.
    [self addChild:[_bee sheet]];
    
    // create and initialize a Label
		status = [CCLabel labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:16];
    
		// position the label on the center of the screen
		status.position = ccp(350, 20);
		
		// add the label as a child to this Layer
		[self addChild: status];
  }
	return self;
}

-(void) draw
{
  [status setString:[_bee status]];

  for (int i = 0; i < [_path count]; i++) {
    NSValue* val = [_path objectAtIndex:i];
    CGPoint p = [val CGPointValue];
    ccDrawPoint(p);
  }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  [_path removeAllObjects];
  return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
  CGPoint point = [touch locationInView:[touch view]];
  id p = [NSValue valueWithCGPoint:CGPointMake(point.y, point.x)];
  [_path addObject:p];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
  if ([_path count] < 1) {
    return;
  }

  [self move];
}

- (void)move {
  CCFiniteTimeAction *prev = [CCMoveTo actionWithDuration:0.1 position:[(NSValue *)[_path objectAtIndex:0] CGPointValue]];
  CCFiniteTimeAction *now;
  NSLog(@"how long is the sequence %d", [_path count]);

  CGPoint p;
  
  do {
    [_path removeObjectAtIndex:0];
    p = [(NSValue *)[_path objectAtIndex:0] CGPointValue];
		now = [CCMoveTo actionWithDuration:3 position:p];
		prev = [CCSequence actionOne:prev two: now];

  } while ([_path count] != 0);

  [[_bee sprite] runAction: prev];
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
