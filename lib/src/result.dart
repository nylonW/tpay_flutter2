/// Enum representing the possible results of a Tpay operation.
///
/// The TpayResult enum defines the following values:
/// - success: The operation was successful.
/// - backButtonPressed: The back button was pressed during the operation.
/// - sessionClosed: The session was closed during the operation.
/// - paymentRequest: A payment request was made during the operation.
/// - error: An error occurred during the operation.
enum TpayResult {
  success,
  backButtonPressed,
  sessionClosed,
  paymentRequest,
  error
}
