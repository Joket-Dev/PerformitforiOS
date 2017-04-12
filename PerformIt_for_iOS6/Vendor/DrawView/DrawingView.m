#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "DrawingView.h"
#import "AppDelegate.h"



//CLASS IMPLEMENTATIONS:

// A class extension to declare private methods
@interface DrawingView (private)

- (BOOL)createFramebuffer;
- (void)destroyFramebuffer;

@end

@implementation DrawingView
@synthesize delegate;
@synthesize  location;
@synthesize  previousLocation;
@synthesize  recordedPath;

@synthesize brushColor, brushName, brushSize, isErased, bgColor;
@synthesize scaleFactor;
@synthesize endThread;
@synthesize pointIndex;
@synthesize bufferCount;

// Implement this to override the default layer class (which is [CALayer class]).
// We do this so that our view will be backed by a layer that is capable of OpenGL ES rendering.
+ (Class) layerClass
{
	return [CAEAGLLayer class];
}

// The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder
{
	CGImageRef		brushImage;
	CGContextRef	brushContext;
	GLubyte			*brushData;
	size_t			width, height;
    
    if ((self = [super initWithCoder:coder]))
    {
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		
		eaglLayer.opaque = YES;
		// In this application, we want to retain the EAGLDrawable contents after a call to presentRenderbuffer.
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
		if (!context || ![EAGLContext setCurrentContext:context])
        {
//			[self release];
			return nil;
		}
		
		// Create a texture from an image
		// First create a UIImage object from the data in a image file, and then extract the Core Graphics image
		brushImage = [UIImage imageNamed:@"Particle.png"].CGImage;
		
		// Get the width and height of the image
		width = CGImageGetWidth(brushImage);
		height = CGImageGetHeight(brushImage);
		
		// Texture dimensions must be a power of 2. If you write an application that allows users to supply an image,
		// you'll want to add code that checks the dimensions and takes appropriate action if they are not a power of 2.
		
		// Make sure the image exists
		if(brushImage)
        {
			// Allocate  memory needed for the bitmap context
			brushData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
			// Use  the bitmatp creation function provided by the Core Graphics framework. 
			brushContext = CGBitmapContextCreate(brushData, width, height, 8, width * 4, CGImageGetColorSpace(brushImage), kCGImageAlphaPremultipliedLast);
			// After you create the context, you can draw the  image to the context.
			CGContextDrawImage(brushContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), brushImage);
			// You don't need the context at this point, so you need to release it to avoid memory leaks.
			CGContextRelease(brushContext);
			// Use OpenGL ES to generate a name for the texture.
			glGenTextures(1, &brushTexture);
			// Bind the texture name. 
			glBindTexture(GL_TEXTURE_2D, brushTexture);
			// Set the texture parameters to use a minifying filter and a linear filer (weighted average)
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			// Specify a 2D texture image, providing the a pointer to the image data in memory
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, brushData);
			// Release  the image data; it's no longer needed
            free(brushData);
		}

		// Setup OpenGL states
		glMatrixMode(GL_PROJECTION);
        CGRect frame;

        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

        if ([appDelegate isIPHONE5])
            frame = CGRectMake(0, 0, 312, 360);
		else
            frame = self.bounds;
        
        // Set the view's scale factor
		self.contentScaleFactor = 1;
//        if(frame.size.height == 243)
//        {
//            //frame.size = CGSizeMake(260, 243);
//            //self.contentScaleFactor = 1;
//        }
        
		CGFloat scale = self.contentScaleFactor;
		// Setup the view port in Pixels
		glOrthof(0, frame.size.width * scale, 0, frame.size.height * scale, -1, 1);
		glViewport(0, 0, frame.size.width * scale, frame.size.height * scale);
		glMatrixMode(GL_MODELVIEW);
		
		glDisable(GL_DITHER);
		glEnable(GL_TEXTURE_2D);
		glEnableClientState(GL_VERTEX_ARRAY);
		
	    glEnable(GL_BLEND);
		// Set a blending function appropriate for premultiplied alpha pixel data
		glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
		
		glEnable(GL_POINT_SPRITE_OES);
		glTexEnvf(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);
		glPointSize(width / kBrushScale);

		// Make sure to start with a cleared buffer
		needsErase = YES;
        
        recordedPath = [[NSMutableArray alloc]init];
	}
    endThread = NO;
	
	return self;
}

- (void)initWithScale:(float)scale_factor
{
    // Set the view's scale factor
    self.contentScaleFactor = scale_factor;
	
    // Setup OpenGL states
    glMatrixMode(GL_PROJECTION);
    CGRect frame = self.bounds;
    CGFloat scale = self.contentScaleFactor;
    // Setup the view port in Pixels
    glOrthof(0, frame.size.width * scale, 0, frame.size.height * scale, -1, 1);
    glViewport(0, 0, frame.size.width * scale, frame.size.height * scale);
    glMatrixMode(GL_MODELVIEW);
    
    glDisable(GL_DITHER);
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_VERTEX_ARRAY);
    
    glEnable(GL_BLEND);
    // Set a blending function appropriate for premultiplied alpha pixel data
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    glEnable(GL_POINT_SPRITE_OES);
    glTexEnvf(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);
    //glPointSize(width / kBrushScale);
}

// If our view is resized, we'll be asked to layout subviews.
// This is the perfect opportunity to also update the framebuffer so that it is
// the same size as our display area.
-(void)layoutSubviews
{
	[EAGLContext setCurrentContext:context];
	[self destroyFramebuffer];
	[self createFramebuffer];
	
	// Clear the framebuffer the first time it is allocated
	if (needsErase)
    {
		[self eraseAllLines:NO];
		needsErase = NO;
	}
}

- (BOOL)createFramebuffer
{
	// Generate IDs for a framebuffer object and a color renderbuffer
	glGenFramebuffersOES(1, &viewFramebuffer);
	glGenRenderbuffersOES(1, &viewRenderbuffer);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	// This call associates the storage for the current render buffer with the EAGLDrawable (our CAEAGLLayer)
	// allowing us to draw into a buffer that will later be rendered to screen wherever the layer is (which corresponds with our view).
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
	// For this sample, we also need a depth buffer, so we'll create and attach one via another renderbuffer.
	glGenRenderbuffersOES(1, &depthRenderbuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
    float screenScale = [[UIScreen mainScreen] scale];
//    glRenderbufferStorageOES(<#GLenum target#>, <#GLenum internalformat#>, <#GLsizei width#>, <#GLsizei height#>)
    
    glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, self.frame.size.width * screenScale, self.frame.size.height * screenScale);
//    gl_rend
	glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
	//glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
	
	if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
	
	return YES;
}

// Clean up any buffers we have allocated.
- (void)destroyFramebuffer
{
	glDeleteFramebuffersOES(1, &viewFramebuffer);
	viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &viewRenderbuffer);
	viewRenderbuffer = 0;
	
	if(depthRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &depthRenderbuffer);
		depthRenderbuffer = 0;
	}
}

- (void) dealloc
{
//    [recordedPath release];
	if (brushTexture)
	{
		glDeleteTextures(1, &brushTexture);
		brushTexture = 0;
	}
	
	if([EAGLContext currentContext] == context)
	{
		[EAGLContext setCurrentContext:nil];
	}
	
//	[context release];
    
    // Destroy framebuffers and renderbuffers
    if (viewFramebuffer) {
        glDeleteFramebuffersOES(1, &viewFramebuffer);
        viewFramebuffer = 0;
    }
    if (viewRenderbuffer) {
        glDeleteRenderbuffersOES(1, &viewRenderbuffer);
        viewRenderbuffer = 0;
    }
    if (depthRenderbuffer)
    {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
    
    //[recordedPath release];
//    [brushColor release];
//    [brushName release];
//    [bgColor release];
//    [super dealloc];

    NSLog(@"draw dealloc");
//    
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    notification.fireDate = [NSDate date];
//    notification.alertBody = @"draw dealloc";
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGRect bounds = [self bounds];
    UITouch* touch = [[event touchesForView:self] anyObject];
	firstTouch = YES;
    touchMoved = NO;
	// Convert touch point from UIView referential to OpenGL one (upside-down flip)
    previousLocation = [touch previousLocationInView:self];
    previousLocation.y = bounds.size.height - previousLocation.y;
	location = [touch locationInView:self];
	location.y = bounds.size.height - location.y;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGRect bounds = [self bounds];
	UITouch* touch = [[event touchesForView:self] anyObject];
		
    touchMoved = YES;
	// Convert touch point from UIView referential to OpenGL one (upside-down flip)
	
    previousLocation = [touch previousLocationInView:self];
    previousLocation.y = bounds.size.height - previousLocation.y;
    
    location = [touch locationInView:self];
    location.y = bounds.size.height - location.y;

    if (firstTouch)
    {
		firstTouch = NO;
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        [recordedPath addObject:tempArray];
//        [tempArray release];
	}
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:[NSValue valueWithCGPoint:previousLocation] forKey:@"point"];
    [dict setValue:brushColor forKey:@"brush-color"];
    [dict setValue:brushName forKey:@"brush-name"];
    [dict setValue:[NSNumber numberWithInt:brushSize] forKey:@"brush-size"];
    [dict setValue:[NSNumber numberWithBool:isErased] forKey:@"erased"];
    [[recordedPath objectAtIndex:[recordedPath count] -1] addObject:dict];
//    [dict release];

    dict = [[NSMutableDictionary alloc]init];
    [dict setValue:[NSValue valueWithCGPoint:location] forKey:@"point"];
    [dict setValue:brushColor forKey:@"brush-color"];
    [dict setValue:brushName forKey:@"brush-name"];
    [dict setValue:[NSNumber numberWithBool:isErased] forKey:@"erased"];
    [dict setValue:[NSNumber numberWithInt:brushSize] forKey:@"brush-size"];
    [[recordedPath objectAtIndex:[recordedPath count] -1] addObject:dict];
//    [dict release];
    
	// Render the stroke
    [self renderFromPoint:previousLocation ToPoint:location WithColor:brushColor WithBrush:brushName WithBrushSize:brushSize Step:kBrushPixelStep Instant:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGRect bounds = [self bounds];
    UITouch* touch = [[event touchesForView:self] anyObject];

    previousLocation = [touch previousLocationInView:self];
    previousLocation.y = bounds.size.height - previousLocation.y;
    location = [touch locationInView:self];
    location.y = bounds.size.height - location.y;
    
    if(!touchMoved)
    {
        if (firstTouch)
        {
            firstTouch = NO;
            NSMutableArray *tempArray = [[NSMutableArray alloc]init];
            [recordedPath addObject:tempArray];
//            [tempArray release];
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:[NSValue valueWithCGPoint:previousLocation] forKey:@"point"];
        [dict setValue:brushColor forKey:@"brush-color"];
        [dict setValue:brushName forKey:@"brush-name"];
        [dict setValue:[NSNumber numberWithInt:brushSize] forKey:@"brush-size"];
        [dict setValue:[NSNumber numberWithBool:isErased] forKey:@"erased"];
        [[recordedPath objectAtIndex:[recordedPath count] -1] addObject:dict];
//        [dict release];
        
        dict = [[NSMutableDictionary alloc]init];
        [dict setValue:[NSValue valueWithCGPoint:location] forKey:@"point"];
        [dict setValue:brushColor forKey:@"brush-color"];
        [dict setValue:brushName forKey:@"brush-name"];
        [dict setValue:[NSNumber numberWithInt:brushSize] forKey:@"brush-size"];
        [dict setValue:[NSNumber numberWithBool:isErased] forKey:@"erased"];
        [[recordedPath objectAtIndex:[recordedPath count] -1] addObject:dict];
//        [dict release];
        
//        dict = [[NSMutableDictionary alloc]init];
//        [dict setValue:[NSValue valueWithCGPoint:location] forKey:@"point"];
//        [dict setValue:brushColor forKey:@"brush-color"];
//        [dict setValue:brushName forKey:@"brush-name"];
//        [dict setValue:[NSNumber numberWithInt:brushSize] forKey:@"brush-size"];
//        [dict setValue:[NSNumber numberWithBool:isErased] forKey:@"erased"];
//        [[recordedPath objectAtIndex:[recordedPath count] -1] addObject:dict];
//        [dict release];
//        
//        dict = [[NSMutableDictionary alloc]init];
//        [dict setValue:[NSValue valueWithCGPoint:location] forKey:@"point"];
//        [dict setValue:brushColor forKey:@"brush-color"];
//        [dict setValue:brushName forKey:@"brush-name"];
//        [dict setValue:[NSNumber numberWithInt:brushSize] forKey:@"brush-size"];
//        [dict setValue:[NSNumber numberWithBool:isErased] forKey:@"erased"];
//        [[recordedPath objectAtIndex:[recordedPath count] -1] addObject:dict];
//        [dict release];
    }
//    if(CGPointEqualToPoint(previousLocation, location))
//    {
//        NSLog(@"equal points");
//        for (int i = 0; i < 10; i++)
//            [self renderFromPoint:previousLocation ToPoint:location WithColor:brushColor WithBrush:brushName WithBrushSize:brushSize Step:kBrushPixelStep Instant:YES];
//        [self renderFromPoint:previousLocation ToPoint:location WithColor:brushColor WithBrush:brushName WithBrushSize:brushSize Step:kBrushPixelStep Instant:NO];
//    }else
        [self renderFromPoint:previousLocation ToPoint:location WithColor:brushColor WithBrush:brushName WithBrushSize:brushSize Step:kBrushPixelStep Instant:NO];
    [[self delegate] linedrawed];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)eraseAllLines:(BOOL)instant
{
    [self setPointIndex:0];
    [self setBufferCount:0];
    [EAGLContext setCurrentContext:context];
	
	// Clear the buffer
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glClearColor([[bgColor objectForKey:@"red"]floatValue],
                 [[bgColor objectForKey:@"green"]floatValue],
                 [[bgColor objectForKey:@"blue"]floatValue],
                 1.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
    if(!instant)
    {
        // Display the buffer
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
        [context presentRenderbuffer:GL_RENDERBUFFER_OES];
    }
}

- (void)playRecordedPath:(NSMutableArray*)path Instant:(BOOL)instant
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    int l = 0;
    int p = 0;
    if(path != NULL)
    {
        for(l = 0; l < [path count]; l++)
        {
            if(self.endThread)
                return;
            while (appDelegate.gamePaused)
            {
                usleep(1000*500);
            }
            //instant = YES;
            if([[path objectAtIndex:l]count] == 1)
            {
                if([[[[path objectAtIndex:l]objectAtIndex:0]objectForKey:@"erased"]boolValue])
                {
                    [self renderFromPoint:[[[[path objectAtIndex:l]objectAtIndex:0]objectForKey:@"point"]CGPointValue]
                                  ToPoint:[[[[path objectAtIndex:l]objectAtIndex:0]objectForKey:@"point"]CGPointValue]
                                WithColor:bgColor
                                WithBrush:[[[path objectAtIndex:l]objectAtIndex:0]objectForKey:@"brush-name"]
                            WithBrushSize:[[[[path objectAtIndex:l]objectAtIndex:0]objectForKey:@"brush-size"]intValue]
                                     Step:kBrushPixelStep
                                  Instant:instant];
                }else
                {
                    [self renderFromPoint:[[[[path objectAtIndex:l]objectAtIndex:0]objectForKey:@"point"]CGPointValue]
                                  ToPoint:[[[[path objectAtIndex:l]objectAtIndex:0]objectForKey:@"point"]CGPointValue]
                                WithColor:[[[path objectAtIndex:l]objectAtIndex:0]objectForKey:@"brush-color"]
                                WithBrush:[[[path objectAtIndex:l]objectAtIndex:0]objectForKey:@"brush-name"]
                            WithBrushSize:[[[[path objectAtIndex:l]objectAtIndex:0]objectForKey:@"brush-size"]intValue]
                                     Step:kBrushPixelStep
                                  Instant:instant];
                }
            }else
            {
                //replays my writRay -1 because of location point
                for(p = 0; p < [[path objectAtIndex:l]count] -1; p ++)
                {
                    if(self.endThread)
                        return;
                    while (appDelegate.gamePaused)
                    {
                        usleep(1000*500);
                    }
                    if(!context)
                    {
                        
                    }
                        //instant = YES;
                    if([[[[path objectAtIndex:l]objectAtIndex:p]objectForKey:@"erased"]boolValue])
                    {
                        [self renderFromPoint:[[[[path objectAtIndex:l]objectAtIndex:p]objectForKey:@"point"]CGPointValue]
                                      ToPoint:[[[[path objectAtIndex:l]objectAtIndex:p+1]objectForKey:@"point"]CGPointValue]
                                    WithColor:bgColor
                                    WithBrush:[[[path objectAtIndex:l]objectAtIndex:p]objectForKey:@"brush-name"]
                                WithBrushSize:[[[[path objectAtIndex:l]objectAtIndex:p]objectForKey:@"brush-size"]intValue]
                                         Step:kBrushPixelStep
                                      Instant:instant];
                    }else
                    {
                        [self renderFromPoint:[[[[path objectAtIndex:l]objectAtIndex:p]objectForKey:@"point"]CGPointValue]
                                      ToPoint:[[[[path objectAtIndex:l]objectAtIndex:p+1]objectForKey:@"point"]CGPointValue]
                                    WithColor:[[[path objectAtIndex:l]objectAtIndex:p]objectForKey:@"brush-color"]
                                    WithBrush:[[[path objectAtIndex:l]objectAtIndex:p]objectForKey:@"brush-name"]
                                WithBrushSize:[[[[path objectAtIndex:l]objectAtIndex:p]objectForKey:@"brush-size"]intValue]
                                         Step:kBrushPixelStep
                                      Instant:instant];
                    }
                }
            }
        }
        if(instant)
        {
            // Display the buffer
            glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
            [context presentRenderbuffer:GL_RENDERBUFFER_OES];
        }
    }
}

- (void)eraseLastLineFrom:(NSMutableArray*)path
{
    
}

- (void)renderFromPoint:(CGPoint)start ToPoint:(CGPoint)end WithColor:(NSDictionary*)color_dict WithBrush:(NSString*)brush_name WithBrushSize:(float)brush_size Step:(float)step Instant:(BOOL)instant
{
    if (brushTexture)
	{
		glDeleteTextures(1, &brushTexture);
		brushTexture = 0;
	}

    CGImageRef		brushImage;
	CGContextRef	brushContext;
	GLubyte			*brushData;
	size_t			width, height;
    
    brushImage = [UIImage imageNamed:brush_name].CGImage;
    width = CGImageGetWidth(brushImage);
    height = CGImageGetHeight(brushImage);
    if(brushImage)
    {
        // Allocate  memory needed for the bitmap context
        brushData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
        // Use  the bitmatp creation function provided by the Core Graphics framework.
        CGImageGetColorSpace(brushImage);
        
        brushContext = CGBitmapContextCreate(brushData, width, height, 8, width * 4, CGImageGetColorSpace(brushImage), kCGImageAlphaPremultipliedLast);
        // After you create the context, you can draw the  image to the context.
        CGContextDrawImage(brushContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), brushImage);
        // You don't need the context at this point, so you need to release it to avoid memory leaks.
        CGContextRelease(brushContext);
        // Use OpenGL ES to generate a name for the texture.
        glGenTextures(1, &brushTexture);
        // Bind the texture name.
        glBindTexture(GL_TEXTURE_2D, brushTexture);
        // Set the texture parameters to use a minifying filter and a linear filer (weighted average)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        // Specify a 2D texture image, providing the a pointer to the image data in memory
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, brushData);
        // Release  the image data; it's no longer needed
        free(brushData);
    }
    
    glColor4f([[color_dict objectForKey:@"red"]floatValue]*kBrushOpacity,
			  [[color_dict objectForKey:@"green"]floatValue]* kBrushOpacity,
			  [[color_dict objectForKey:@"blue"]floatValue]* kBrushOpacity,
			  kBrushOpacity);
    
    static GLfloat*		vertexBuffer = NULL;
	static NSUInteger	vertexMax = 64;
	NSUInteger			vertexCount = 0, count, i;
	
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
	// Convert locations from Points to Pixels
	CGFloat scale = self.contentScaleFactor;
	start.x *= scale;
	start.y *= scale;
	end.x *= scale;
	end.y *= scale;
	
	// Allocate vertex array buffer
	if(vertexBuffer == NULL)
		vertexBuffer = malloc(vertexMax * 2 * sizeof(GLfloat));
	
	// Add points to the buffer so there are drawing points every X pixels
	count = MAX(ceilf(sqrtf((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y))/step), 1);
	for(i = 0; i < count; ++i)
    {
		if(vertexCount == vertexMax)
        {
			vertexMax = 2 * vertexMax;
			vertexBuffer = realloc(vertexBuffer, vertexMax * 2 * sizeof(GLfloat));
		}
		
		vertexBuffer[2 * vertexCount + 0] = start.x + (end.x - start.x) * ((GLfloat)i / (GLfloat)count);
		vertexBuffer[2 * vertexCount + 1] = start.y + (end.y - start.y) * ((GLfloat)i / (GLfloat)count);
		vertexCount += 1;
	}
	
    glPointSize(brush_size);
    glEnable (GL_LINE_SMOOTH);
    
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	// Render the vertex array
	glVertexPointer(2, GL_FLOAT, 0, vertexBuffer);
	glDrawArrays(GL_POINTS, 0, vertexCount);
	//
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);

    if(!instant)
    {
        // Display the buffer
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
        [context presentRenderbuffer:GL_RENDERBUFFER_OES];
    }
}

- (UIImage *)imageRepresentation
{
	int width = CGRectGetWidth([self bounds]);
	int height = CGRectGetHeight([self bounds]);
    
    NSInteger myDataLength = width * height * 4;
    
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y <height; y++)
    {
        for(int x = 0; x <width * 4; x++)
        {
            buffer2[(height - 1 - y) * width * 4 + x] = buffer[y * 4 * width + x];
        }
    }
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    return myImage;
}

void drawSmoothLine(CGPoint *pos1, CGPoint *pos2, float width)
{
    GLfloat lineVertices[12], curc[4];
    GLint   ir, ig, ib, ia;
    CGPoint dir, tan;
    
    width = width*8;
    dir.x = pos2->x - pos1->x;
    dir.y = pos2->y - pos1->y;
    float len = sqrtf(dir.x*dir.x+dir.y*dir.y);
    if(len<0.00001)
        return;
    dir.x = dir.x/len;
    dir.y = dir.y/len;
    tan.x = -width*dir.y;
    tan.y = width*dir.x;
    
    lineVertices[0] = pos1->x + tan.x;
    lineVertices[1] = pos1->y + tan.y;
    lineVertices[2] = pos2->x + tan.x;
    lineVertices[3] = pos2->y + tan.y;
    lineVertices[4] = pos1->x;
    lineVertices[5] = pos1->y;
    lineVertices[6] = pos2->x;
    lineVertices[7] = pos2->y;
    lineVertices[8] = pos1->x - tan.x;
    lineVertices[9] = pos1->y - tan.y;
    lineVertices[10] = pos2->x - tan.x;
    lineVertices[11] = pos2->y - tan.y;
    
    glGetFloatv(GL_CURRENT_COLOR,curc);
    ir = 255.0*curc[0];
    ig = 255.0*curc[1];
    ib = 255.0*curc[2];
    ia = 255.0*curc[3];
    
    const GLubyte lineColors[] = {
        ir, ig, ib, 0,
        ir, ig, ib, 0,
        ir, ig, ib, ia,
        ir, ig, ib, ia,
        ir, ig, ib, 0,
        ir, ig, ib, 0,
    };
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, lineVertices);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, lineColors);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 6);
    glDisableClientState(GL_COLOR_ARRAY);
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
{
    return YES;
}

- (void)playRecordedPathOnTime:(NSMutableArray*)path DisplayCount:(int)buffer_count
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(buffer_count > 0)
        bufferPageSize = buffer_count;
    else
        buffer_count = bufferCount;
    
    int k = bufferCount;
    int p = 0;//pointIndex;
    for(p = pointIndex; p < [path count] -1; p++)
    {
        if(self.endThread)
            return;
//        if(appDelegate.gamePaused)
//        {
//            NSLog(@"re-drawing pused");
//            pointIndex = p;
//            bufferCount = k;
//            return;
//        }
        while (appDelegate.gamePaused)
        {
            usleep(2*0.5*1000);
        }
        if([[[path objectAtIndex:p]objectForKey:@"line"]intValue] == [[[path objectAtIndex:p+1]objectForKey:@"line"]intValue])
        {
            k++;
            if([[[path objectAtIndex:p]objectForKey:@"erased"]boolValue])
            {
                [self renderFromPoint:[[[path objectAtIndex:p]objectForKey:@"point"]CGPointValue]
                              ToPoint:[[[path objectAtIndex:p+1]objectForKey:@"point"]CGPointValue]
                            WithColor:bgColor
                            WithBrush:[[path objectAtIndex:p]objectForKey:@"brush-name"]
                        WithBrushSize:[[[path objectAtIndex:p]objectForKey:@"brush-size"]intValue]
                                 Step:kBrushPixelStep
                              Instant:YES];
            }else
            {
                [self renderFromPoint:[[[path objectAtIndex:p]objectForKey:@"point"]CGPointValue]
                              ToPoint:[[[path objectAtIndex:p+1]objectForKey:@"point"]CGPointValue]
                            WithColor:[[path objectAtIndex:p]objectForKey:@"brush-color"]
                            WithBrush:[[path objectAtIndex:p]objectForKey:@"brush-name"]
                        WithBrushSize:[[[path objectAtIndex:p]objectForKey:@"brush-size"]intValue]
                                 Step:kBrushPixelStep
                              Instant:YES];
            }
        }
        if(k >= buffer_count)
        {
            //NSLog(@"display buffer");
            k = 0;
//            if(appDelegate.gamePaused)
//            {
//                NSLog(@"re-drawing pused");
//                pointIndex = p;
//                bufferCount = k;
//                return;
//            }
            // Display the buffer
            glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
            [context presentRenderbuffer:GL_RENDERBUFFER_OES];
            //[NSThread sleepForTimeInterval:1.0/15.0];
            if(buffer_count == 1)
                usleep(2*0.5*1000);
            else
                usleep((1.0/15.0)*1000);//1 milisecond
        }
    }
    if(k > 0)
    {
        k = 0;
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
        [context presentRenderbuffer:GL_RENDERBUFFER_OES];
    }
}
@end
