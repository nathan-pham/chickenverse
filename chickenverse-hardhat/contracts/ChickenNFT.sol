// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ChickenNFT is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping(string => bool) existingURIs;
    mapping(address => uint256) nftHolders;

    constructor() ERC721("ChickenNFT", "CV") {
        _tokenIdCounter.increment();
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function getNFT(address recipient) public view returns (uint256) {
        return nftHolders[recipient];
    }

    function isContentOwned(string memory uri) public view returns (bool) {
        return existingURIs[uri];
    }

    function payMint(address recipient, string memory metadataURI)
        public
        payable
        returns (uint256)
    {
        require(!existingURIs[metadataURI], "Content already owned");
        require(
            msg.value >= 0.001 ether,
            "Payment must be at least 0.001 ether"
        );

        // only allow 1 mint per address
        require(nftHolders[recipient] == 0, "Already minted");

        uint256 newItemId = _tokenIdCounter.current();

        require(newItemId > 0 && newItemId < 1000, "Too many items created");

        _tokenIdCounter.increment();
        existingURIs[metadataURI] = true;
        nftHolders[recipient] = newItemId;

        _mint(recipient, newItemId);
        _setTokenURI(newItemId, metadataURI);

        return newItemId;
    }

    function count() public view returns (uint256) {
        return _tokenIdCounter.current();
    }
}
