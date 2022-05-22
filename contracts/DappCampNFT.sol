// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// TODO: Only deployment part left


contract DappCampNFT is ERC721Enumerable, Ownable {
    uint256 public MAX_MINTABLE_TOKENS = 5;

    constructor() ERC721("DappCamp NFT", "DCAMP") Ownable() {}

    string[] private collection = [
        "1",
        "2",
        "3",
        "4",
        "5"
    ];

    function random(string memory input) internal pure returns (uint256) {
        // the random function should always map to the same output for the same input
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked(keyPrefix, Strings.toString(tokenId))));
        string memory output = collection[rand % collection.length];
        return output;
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        string[4] memory parts;
        string memory keyPrefix = "Numbers";

        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 100 100"><rect width="100" height="100" fill="blue" /></svg>';
        parts[1] = pluck(tokenId, keyPrefix, collection);
        parts[2] = '</text></svg>';

        string memory svg = string(
            abi.encodePacked(parts[0], parts[1], parts[2])
        );

        string memory json = Base64.encode(bytes(string(abi.encodePacked(
        '{"name": "Tokens", "description": "Numbers", "image": "data:image/svg+xml;base64,',
        Base64.encode(bytes(svg)), '"}'))));
        string memory output = string(abi.encodePacked('data:application/json;base64,', json));
        return output;
    }

    function claim(uint256 tokenId) public {
        require(tokenId > 0 && tokenId < MAX_MINTABLE_TOKENS, "Token ID invalid");
        _safeMint(_msgSender(), tokenId);
    }
}