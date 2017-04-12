
#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

//CONSTANTS:

//#define kBrushOpacity		(1.0 / 1.0)
//#define kBrushPixelStep		0.5
//#define kBrushScale			20//5
//#define kLuminosity			0.4
//#define kSaturation			2.0

#define kBrushOpacity		1.0
#define kBrushPixelStep		1//0.5
#define kBrushScale			2//0.25//1
#define kLuminosity			0.75
#define kSaturation			1.0

@protocol DrawingViewDelegate <NSObject>
- (void) linedrawed;
@end

@interface DrawingView : UIView
{
    id <DrawingViewDelegate> delegate;
@private
	// The pixel dimensions of the backbuffer
	GLint backingWidth;
	GLint backingHeight;
	
	EAGLContext *context;
	
	// OpenGL names for the renderbuffer and framebuffers used to render to this view
	GLuint viewRenderbuffer, viewFramebuffer;
	
	// OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist)
	GLuint depthRenderbuffer;
	
	GLuint	brushTexture;
	CGPoint	location;
	CGPoint	previousLocation;
	Boolean	firstTouch;
	Boolean needsErase;
    Boolean touchMoved;
    float scaleFactor;
    BOOL endThread;
    
    int pointIndex;
    int bufferCount;
    int bufferPageSize;
}

@property(nonatomic, readwrite) CGPoint location;
@property(nonatomic, readwrite) CGPoint previousLocation;
@property (nonatomic, strong) NSMutableArray *recordedPath;

@property (nonatomic, strong) NSMutableDictionary *brushColor;
@property (nonatomic, assign) int brushSize;
@property (nonatomic, strong) NSString *brushName;
@property (nonatomic, assign) BOOL isErased;
@property (nonatomic, strong) NSMutableDictionary *bgColor;
@property (nonatomic, assign) float scaleFactor;
@property (nonatomic, assign) BOOL endThread;
@property (nonatomic, assign) int pointIndex;
@property (nonatomic, assign) int bufferCount;

@property (nonatomic, retain) id <DrawingViewDelegate> delegate;

- (void)eraseAllLines:(BOOL)instant;
- (void)playRecordedPath:(NSMutableArray*)path Instant:(BOOL)instant;
- (void)eraseLastLineFrom:(NSMutableArray*)path;
- (void)renderFromPoint:(CGPoint)start ToPoint:(CGPoint)end WithColor:(NSDictionary*)color_dict WithBrush:(NSString*)brush_name WithBrushSize:(float)brush_size Step:(float)step Instant:(BOOL)instant;
- (UIImage *)imageRepresentation;
- (void)initWithScale:(float)scale_factor;

- (void)playRecordedPathOnTime:(NSMutableArray*)path DisplayCount:(int)buffer_count;

@end
