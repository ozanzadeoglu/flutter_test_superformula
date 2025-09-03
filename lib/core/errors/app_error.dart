/// Application-wide error types
/// 
/// These represent all possible error states that can occur
/// throughout the application.
enum AppError {
  // Network related
  noNetworkConnection,
  serverUnavailable,
  requestTimeout,
  
  // Authentication & Authorization
  unauthorized,
  sessionExpired,
  
  // Data related
  notFound,
  invalidResponse,
  parsingError,
  
  // Cache & Storage
  cacheReadFailed,
  cacheWriteFailed,
  storagePermissionDenied,
  
  // User actions
  requestCancelled,
  
  // Search specific
  noOfflineSearch,
  searchTermTooShort,
  
  // Generic
  unknown,
}