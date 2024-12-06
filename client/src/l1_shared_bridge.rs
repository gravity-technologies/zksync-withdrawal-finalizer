//! ABI wrappers for `L1SharedBridge` contract.

#[allow(missing_docs)]
pub mod codegen {
    use ethers::prelude::abigen;

    abigen!(
        IL1SharedBridge,
        "$CARGO_MANIFEST_DIR/src/contracts/IL1SharedBridge.json"
    );
}
