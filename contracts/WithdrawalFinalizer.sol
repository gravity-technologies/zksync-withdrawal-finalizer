// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@matterlabs/zksync-contracts/l1/contracts/bridge/interfaces/IL1Bridge.sol";
import "./UncheckedMath.sol";
import {IL1SharedBridge} from "./IL1SharedBridge.sol";

contract WithdrawalFinalizer {
    using UncheckedMath for uint256;
    uint256 constant chainId = $(CHAIN_ID);
    IL1Bridge constant L1_SHARED_BRIDGE = IL1SharedBridge($(L1_SHARED_BRIDGE_ADDRESS));

    struct RequestFinalizeWithdrawal {
        uint256 _l2BatchNumber;
        uint256 _l2MessageIndex;
        uint16 _l2TxNumberInBatch;
        bytes _message;
        bytes32[] _merkleProof;
        uint256 _gas;
    }

    struct Result {
        uint256 _l2BatchNumber;
        uint256 _l2MessageIndex;
        uint256 _gas;
        bool success;
    }

    function finalizeWithdrawals(
        RequestFinalizeWithdrawal[] calldata requests
    ) external returns (Result[] memory) {
        uint256 requestsLength = requests.length;
        Result[] memory results = new Result[](requestsLength);
        for (uint256 i = 0; i < requestsLength; i = i.uncheckedInc()) {
            require(gasleft() >= ((requests[i]._gas * 64) / 63) + 500, "i");
            uint256 gasBefore = gasleft();
            try
                L1_SHARED_BRIDGE.finalizeWithdrawal{gas: requests[i]._gas}(
                    chainId,
                    requests[i]._l2BatchNumber,
                    requests[i]._l2MessageIndex,
                    requests[i]._l2TxNumberInBatch,
                    requests[i]._message,
                    requests[i]._merkleProof
                )
            {
                results[i] = Result({
                    _l2BatchNumber: requests[i]._l2BatchNumber,
                    _l2MessageIndex: requests[i]._l2MessageIndex,
                    _gas: gasBefore - gasleft(),
                    success: true
                });
            } catch {
                results[i] = Result({
                    _l2BatchNumber: requests[i]._l2BatchNumber,
                    _l2MessageIndex: requests[i]._l2MessageIndex,
                    _gas: 0,
                    success: false
                });
            }
        }
        return results;
    }
}
