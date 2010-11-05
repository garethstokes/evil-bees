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

@synthesize currentBee=_currentBee;

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
    _bees = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
      Bee *bee = [[[Bee alloc] init] autorelease];
      [_bees addObject:bee];
      // Add the sprite as a child of the sheet, so that it knows where to get its image data.
      [self addChild:[bee sheet]];
    }

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
  for (Bee *bee in _bees) {
    [status setString:[bee status]];
    for (int i = 0; i < [[bee path] count]; i++) {
      NSValue* val = [[bee path] objectAtIndex:i];
      CGPoint p = [val CGPointValue];
      ccDrawPoint(p);
    }
    
    CGPoint last = ccp(0, 0);
    for (int i = 0; i < [[bee path] count]; i++) {
      NSValue* val = [[bee path] objectAtIndex:i];
      CGPoint p = [val CGPointValue];
      if (last.y == 0 && last.x == 0) {
        last = p;
      }
      ccDrawLine(ccp(last.x, last.y), ccp(p.x, p.y));
      last = p;
    }
  }

  

}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {  
  CGPoint point = [touch locationInView:[touch view]];
  NSLog(@"ccTouchBegan %f, %f", point.y, point.x);
  for (Bee *bee in _bees) {
    CCSprite *sprite = [bee sprite];

    CGPoint beePoint = [sprite convertTouchToNodeSpace:touch];
    NSLog(@"convertTouchToNodeSpace %f, %f", beePoint.x, beePoint.y);
    CGSize size = [sprite contentSize];
    
    if (beePoint.x > 0 && beePoint.x < size.width && beePoint.y > 0 && beePoint.y < size.height) {
      [bee startPoint:CGPointMake(point.y, point.x)];
      _currentBee = bee;
      break;
    }
  }

  return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
  if (_currentBee == nil) {
    return;
  }
  
  CGPoint point = [touch locationInView:[touch view]];
  //NSLog(@"ccTouchMoved %f, %f", point.y, point.x);
  
  [_currentBee addPoint:CGPointMake(point.y, point.x)];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
  NSLog(@"ccTouchEnded");
  
  [_currentBee move];
  _currentBee = nil;
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
