// True for running actual app - sets up authentication only
// False for running pages in isolation (DEV MODE ONLY) - sets up all services
final bool runActualApp = false;

// Ensure this is FALSE for release. In developer mode, authenticate with Toastie.
final bool shouldAuthenticateWithToastie = true;

// Ensure all these are TRUE for release.
// In developer mode, disable RPC calls to reduce costs / make dev easier.
final bool shouldRunRpc = true;
final bool shouldDeleteAccount = true;
// In developer mode, disable AI calls to reduce costs.
final bool shouldRunAITools = true;

// Toggle authentication entrypoints.
final bool enableEmailAuthOnly = true;
final bool enableGoogleOAuth = false;
final bool enableAppleOAuth = false;

// New features
final bool enableResetPassword = false;
