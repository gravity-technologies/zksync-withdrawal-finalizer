//! ABI wrappers for `L1SharedBridge` contract.

#[allow(missing_docs)]
pub mod codegen {
    use ethers::prelude::abigen;

    abigen!(
        IBaseToken,
        "$CARGO_MANIFEST_DIR/src/contracts/IBaseToken.json"
    );
}
