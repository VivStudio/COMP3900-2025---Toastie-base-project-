// True for running actual app - sets up authentication only
// False for running pages in isolation (DEV MODE ONLY) - sets up all services
final bool runActualApp = true;

// Ensure this is FALSE for release. In developer mode, authenticate with Toastie.
final bool shouldAuthenticateWithToastie = false;

// Ensure all these are TRUE for release.
// In developer mode, disable RPC calls to reduce costs / make dev easier.
final bool shouldRunRpc = true;
final bool shouldDeleteAccount = true;
// In developer mode, disable AI calls to reduce costs.
final bool shouldRunAITools = true;

// New features
final bool enableResetPassword = false;
