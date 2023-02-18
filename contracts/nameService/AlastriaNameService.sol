// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract AlastriaNameService {
    struct Record {
        address owner;
        address resolver;
        uint64 ttl;
    }

    mapping(bytes32=>Record) records;

    event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
    event Transfer(bytes32 indexed node, address owner);
    event NewResolver(bytes32 indexed node, address resolver);

    modifier only_owner(bytes32 node) {
        if(records[node].owner != msg.sender) revert("Only owner can manage node");
        _;
    }

    constructor(address _owner) {
        records[0].owner = _owner;
    }

    function owner(bytes32 node) public view returns (address) {
        return records[node].owner;
    }

    function resolver(bytes32 node) public view returns (address) {
        return records[node].resolver;
    }

    function ttl(bytes32 node) public view returns (uint64) {
        return records[node].ttl;
    }

    function setOwner(bytes32 node, address _owner) public only_owner(node) {
        emit Transfer(node, _owner);
        records[node].owner = _owner;
    }

    function setSubnodeOwner(bytes32 node, bytes32 label, address _owner) public only_owner(node) {
        bytes32 subnode = keccak256(abi.encode(node, label));
        emit NewOwner(node, label, _owner);
        records[subnode].owner = _owner;
    }

    function setResolver(bytes32 node, address _resolver) public only_owner(node) {
        emit NewResolver(node, _resolver);
        records[node].resolver = _resolver;
    }

    function setTTL(bytes32 node, uint64 _ttl) public only_owner(node) {
        records[node].ttl = _ttl;
    }
}