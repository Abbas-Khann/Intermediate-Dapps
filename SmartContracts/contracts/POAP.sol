// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC1155Drop.sol";
import "@thirdweb-dev/contracts/base/ERC1155SignatureMint.sol";

/*
Building a mintKudos clone contract as it will be released via Publish
=> The contract should consist of lazyMinting where a person will be able to create a POAP
=> After that each tokenId should have it's own owner and only that particular owner should be able to make changes to the token (aka setup claimConditions)
=> Next the contract should have the Soulbound NFT where users are only able to burn their tokens but unable to sell or transfer their tokens to another wallet or a contract
=> Write tests FFS
*/

contract POAP is ERC1155Drop {
    mapping(uint256 => address) public tokenOwner;

    constructor(
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps,
        address _primarySaleRecipient
    )
        ERC1155Drop(
            _name,
            _symbol,
            _royaltyRecipient,
            _royaltyBps,
            _primarySaleRecipient
        )
    {}

    /*
    @dev Make the NFT non-transferable(Souldbound token)
    */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public override {
        require(from == address(0), "SBTs are non transferable");
        super.safeTransferFrom(from, to, id, amount, data);
    }

    function lazyMint(
        uint256 _amount,
        string calldata _baseURIForTokens,
        bytes calldata _data
    ) public virtual override returns (uint256 batchId) {
        super.lazyMint(_amount, _baseURIForTokens, _data);
        return LazyMint.lazyMint(_amount, _baseURIForTokens, _data);
    }

    // Perform overriding for other functions next
    function _canSetClaimConditions()
        internal
        view
        virtual
        override
        returns (bool)
    {
        return true;
    }

    function _canLazyMint() internal view virtual override returns (bool) {
        return true;
    }
}
