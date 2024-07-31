// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

interface IMagicSpend {
    /// @notice Signed withdraw request allowing accounts to withdraw funds from this contract.
    struct WithdrawRequest {
        /// @dev The signature associated with this withdraw request.
        bytes signature;
        /// @dev The asset to withdraw.
        address asset;
        /// @dev The requested amount to withdraw.
        uint256 amount;
        /// @dev Unique nonce used to prevent replays.
        uint256 nonce;
        /// @dev The maximum expiry the withdraw request remains valid for.
        uint48 expiry;
    }

    /// @notice Allows the sender to withdraw any available funds associated with their account.
    ///
    /// @dev Can be called back during the `UserOperation` execution to sponsor funds for non-gas related
    ///      use cases (e.g., swap or mint).
    function withdrawGasExcess() external;

    /// @notice Allows the caller to withdraw funds by calling with a valid `withdrawRequest`.
    ///
    /// @param withdrawRequest The withdraw request.
    function withdraw(WithdrawRequest memory withdrawRequest) external;
}

/// @title MagicSpendUtils
///
/// @notice Utilities for MagicSpend
///
/// @author Coinbase (https://github.com/coinbase/smart-wallet-periphery)
library MagicSpendUtils {
    error InvalidWithdrawToken();

    address public constant MAGIC_SPEND_ADDRESS = 0x011A61C07DbF256A68256B1cB51A5e246730aB92;

    function getWithdrawTransfer(bytes memory requestBytes) internal pure returns (address token, uint256 value) {
        IMagicSpend.WithdrawRequest memory request = abi.decode(requestBytes, (IMagicSpend.WithdrawRequest));
        return (request.asset, request.amount);
    }
}
