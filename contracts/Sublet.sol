// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";

contract Sublet {
    using SafeMath for uint256;

    enum SubletProposalStatus {PENDING, SIGNED, OPEN, CLOSED}

    struct SubletProposal {
        address to;
        uint256 subleaseLength;
        uint256 subleaseFixedAmt;
        uint256 subleaseFixedDeposit;
        mapping(address => bool) signed;
        SubletProposalStatus status;
    }

    struct Parties {
        address owner;
        address sublette;
    }

    Parties public signers;
    SubletProposal[] public subletProposals;

    function createSublease(address _owner, address _subletee) public {
        signers = Parties({owner: _owner, sublette: _subletee});
    }

    event Received(address, uint256);

    function () external payable {
        emit Received(msg.sender, msg.value);
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }

    modifier isOwner() {
        require(msg.sender == signers.owner, "Only owner can do so");
        _;
    }

    modifier isValidSigner(address user) {
        require(
            user == signers.owner || user == signers.sublette,
            "Not from valid involved party"
        );
        _;
    }

    modifier subletProposalExists(uint256 proposalIndex) {
        require(proposalIndex >= 0);
        require(proposalIndex < subletProposals.length);
        _;
    }

    function submitProposal(
        address ownerAddress,
        uint256 subleaseLength,
        uint256 subleaseFixedAmt,
        uint256 subleaseFixedDeposit
    ) public isOwner {
        subletProposals.push(
            SubletProposal({
                to: ownerAddress,
                subleaseLength: subleaseLength,
                subleaseFixedAmt: subleaseFixedAmt,
                subleaseFixedDeposit: subleaseFixedDeposit,
                status: SubletProposalStatus.PENDING
            })
        );
    }

    function signProposal(uint256 proposalIndex)
        public
        subletProposalExists(proposalIndex)
        isValidSigner(msg.sender)
    {
        subletProposals[proposalIndex].signed[msg.sender] = true;
    }

    function allProposalPartiesSigned(uint256 proposalIndex)
        public
        subletProposalExists(proposalIndex)
        returns (bool)
    {
        bool allPartiesSigned = false;
        for (uint256 i = 0; i < subletProposals.length; i++) {
            allPartiesSigned =
                subletProposals[proposalIndex].signed[signers.owner] &&
                subletProposals[proposalIndex].signed[signers.sublette];
        }
        if (allPartiesSigned == true) {
            subletProposals[proposalIndex].status = SubletProposalStatus.SIGNED;
        }
        return allPartiesSigned;
    }

    modifier isFullySigned(uint256 proposalIndex) {
        require(allProposalPartiesSigned(proposalIndex));
        _;
    }

    function finalizeProposal(uint256 proposalIndex)
        public
        isFullySigned(proposalIndex)
        isValidSigner(msg.sender)
    {
        require(
            address(this).balance >=
                subletProposals[proposalIndex].subleaseFixedDeposit
        );
        require(
            subletProposals[proposalIndex].status == SubletProposalStatus.SIGNED
        );
        subletProposals[proposalIndex].status = SubletProposalStatus.OPEN;
    }

    function proposalStatus(uint256 proposalIndex)
        public
        view
        subletProposalExists(proposalIndex)
        returns (SubletProposalStatus)
    {
        return subletProposals[proposalIndex].status;
    }

    event Withdraw(address, uint256);
    event Transfer(address indexed from, address indexed to, uint256 value);

    function withdraw(
        address payable to,
        uint256 withdrawAmount,
        uint256 proposalIndex
    ) public isOwner {
        require(
            subletProposals[proposalIndex].status == SubletProposalStatus.OPEN
        );
        require(
            (
                address(this).balance.sub(
                    subletProposals[proposalIndex].subleaseFixedDeposit
                )
            ) <= withdrawAmount
        );
        emit Transfer(address(this), to, withdrawAmount);
        to.transfer(withdrawAmount);
        emit Withdraw(address(this), withdrawAmount);
    }
}
