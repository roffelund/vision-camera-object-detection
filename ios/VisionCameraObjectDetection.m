//
//  VisionCameraObjectDetection.m
//  VisionCameraExample
//
//  Created by Marc Rousavy on 06.05.21.
//

#import <VisionCamera/FrameProcessorPlugin.h>
#import <VisionCamera/Frame.h>
#import <MLKit.h>

// Example for an Objective-C Frame Processor plugin

@interface QRCodeFrameProcessorPluginObjC : NSObject

+ (MLKObjectDetector*) detector;

@end

@implementation QRCodeFrameProcessorPluginObjC

+ (MLKObjectDetector*) detector {
  static MLKObjectDetector* detector = nil;
  if (detector == nil) {
    MLKObjectDetectorOptions* options = [[MLKObjectDetectorOptions alloc] init];
    detector = [MLKObjectDetector objectDetectorWithOptions:options];
  }
  return detector;
}

static inline id detectObjects(Frame* frame, NSArray* arguments) {
  MLKVisionImage *image = [[MLKVisionImage alloc] initWithBuffer:frame.buffer];
  image.orientation = frame.orientation; // <-- TODO: is mirrored?

  NSError* error;
  NSArray<MLKObject*>* objects = [[QRCodeFrameProcessorPluginObjC detector] resultsInImage:image error:&error];

  NSMutableArray* results = [NSMutableArray arrayWithCapacity:objects.count];
  for (MLKObject* objext in objects) {
    CGRect frame = object.frame;
    NSNumber* trackingID = object.trackingID;

    NSMutableArray* labels = [NSMutableArray arrayWithCapacity:labels.count];
    for (MLKObjectLabel* label in object.labels) {
      [labels addObject:@{
        @"label": label.text,
        @"confidence": [NSNumber numberWithFloat:label.confidence]
      }];
    }
 
    [results addObject:@{
      @"frame": @{
        @"x": [NSNumber numberWithFloat: frame.minX],
        @"y": [NSNumber numberWithFloat: frame.minY],
        @"height": [NSNumber numberWithFloat: frame.height],
        @"width": [NSNumber numberWithFloat: frame.height],
      },
      @"trackingId": trackingID,
      @"labels": labels
    }];

  }

  return results;
}

VISION_EXPORT_FRAME_PROCESSOR(detectObjects)

@end
