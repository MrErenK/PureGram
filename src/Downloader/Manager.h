#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol PGDownloadDelegateProtocol <NSObject>

// Methods
- (void)downloadDidStart;
- (void)downloadDidCancel;
- (void)downloadDidProgress:(float)progress;
- (void)downloadDidFinishWithError:(NSError *)error;
- (void)downloadDidFinishWithFileURL:(NSURL *)fileURL;

@end

@interface PGDownloadManager : NSObject <NSURLSessionDownloadDelegate>

// Properties
@property (nonatomic, weak) id<PGDownloadDelegateProtocol> delegate;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, strong) NSString *fileExtension;

// Methods
- (instancetype)initWithDelegate:(id<PGDownloadDelegateProtocol>)downloadDelegate;

- (void)downloadFileWithURL:(NSURL *)url fileExtension:(NSString *)fileExtension;

- (void)cancelDownload;

- (NSURL *)moveFileToCacheDir:(NSURL *)oldPath;

@end