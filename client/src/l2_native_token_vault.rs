//! ABI wrappers for `L2NativeTokenVault` contract.
#[allow(missing_docs)]
pub mod codegen {
    use ethers::prelude::abigen;

    abigen!(
        L2NativeTokenVault,
        "$CARGO_MANIFEST_DIR/src/contracts/L2NativeTokenVault.json"
    );
}
