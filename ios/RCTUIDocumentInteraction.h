// RCTUIDocumentInteraction.h

#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCTUIDocumentInteraction : RCTEventEmitter <RCTBridgeModule, UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

@end

NS_ASSUME_NONNULL_END