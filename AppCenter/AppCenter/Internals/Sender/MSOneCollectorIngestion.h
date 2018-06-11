#import "MSHttpSender.h"

extern NSString *const kMSOneCollectorApiKey;
extern NSString *const kMSOneCollectorApiPath;
extern NSString *const kMSOneCollectorApiVersion;

/**
 * Assign value in header to avoid "format is not a string literal" warning.
 * The convention for this format string is <sdktype>-<platform>-<language>-<projection>-<version>-<tag>.
 */
static NSString *const kMSOneCollectorClientVersionFormat = @"ACS-iOS-ObjectiveC-no-%@-no";
extern NSString *const kMSOneCollectorClientVersionKey;
extern NSString *const kMSOneCollectorContentType;
extern NSString *const kMSOneCollectorLogSeparator;
extern NSString *const kMSOneCollectorUploadTimeKey;

@interface MSOneCollectorIngestion : MSHttpSender

/**
 * Initialize the Sender.
 *
 * @param baseUrl Base url.
 *
 * @return A sender instance.
 */
- (id)initWithBaseUrl:(NSString *)baseUrl;

@end
