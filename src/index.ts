/* globals __labelImage */
import type { Frame } from 'react-native-vision-camera';

interface DetectedObject {
  /**
   * A CGRect indicating the position of the object in the image.
   */
  frame: string;
  /**
   * An integer that identifies the object across images, or `nil` in single image mode.
   */
  trackingId: number;
  /**
   * An array of labels describing the object returned by the detector. The property is empty if the detector option shouldEnableClassification is set to false.
   */
  labels: string[];
}

/**
 * Returns an array of matching `ImageLabel`s for the given frame.
 *
 * This algorithm executes within **~60ms**, so a frameRate of **16 FPS** perfectly allows the algorithm to run without dropping a frame. Anything higher might make video recording stutter, but works too.
 */
export function detectObjects(frame: Frame): DetectedObject[] {
  'worklet';
  // @ts-expect-error Frame Processors are not typed.
  return __detectObjects(frame);
}
