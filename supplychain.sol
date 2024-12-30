// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FoodSupplyChain {
    struct Material {
        string materialId;
        string materialName;
        string expiryDate;
        bool isUsed;
        address supplier;
        address chef;
        bool isSold;
    }

    struct Inspection {
        string inspectionId;
        string materialId;
        address inspector;
        uint inspectionDate;
        bool passedInspection;
    }

    address public restaurantOwner;
    mapping(string => Material) public materials; // mapping materialId to Material struct
    mapping(string => Inspection) public inspections; // mapping inspectionId to Inspection struct
    
    event MaterialPurchased(string materialId, string materialName, address supplier, string expiryDate);
    event MaterialDelivered(string materialId, address chef);
    event MaterialUsed(string materialId, address chef);
    event InspectionConducted(string inspectionId, string materialId, address inspector, bool passedInspection);
    
    modifier onlyOwner() {
        require(msg.sender == restaurantOwner, "Only the restaurant owner can perform this action");
        _;
    }

    modifier onlyChef(string memory materialId) {
        require(materials[materialId].chef == msg.sender, "Only the assigned chef can use this material");
        _;
    }
    
    modifier onlyInspector() {
        // Custom logic to define who is an inspector
        require(msg.sender != restaurantOwner && msg.sender != materials[materialId].chef, "Inspectors cannot be owners or chefs");
        _;
    }
    
    constructor() {
        restaurantOwner = msg.sender;
    }

    // Function for restaurant owner to purchase materials
    function purchaseMaterial(string memory _materialId, string memory _materialName, address _supplier, string memory _expiryDate) public onlyOwner {
        require(bytes(materials[_materialId].materialId).length == 0, "Material ID already exists");
        
        materials[_materialId] = Material({
            materialId: _materialId,
            materialName: _materialName,
            expiryDate: _expiryDate,
            isUsed: false,
            supplier: _supplier,
            chef: address(0),
            isSold: false
        });

        emit MaterialPurchased(_materialId, _materialName, _supplier, _expiryDate);
    }

    // Function for owner to assign material to chef
    function deliverMaterialToChef(string memory _materialId, address _chef) public onlyOwner {
        require(bytes(materials[_materialId].materialId).length != 0, "Material does not exist");
        require(materials[_materialId].isUsed == false, "Material already used");

        materials[_materialId].chef = _chef;

        emit MaterialDelivered(_materialId, _chef);
    }

    // Function for chef to use material
    function useMaterial(string memory _materialId) public onlyChef(_materialId) {
        require(materials[_materialId].isUsed == false, "Material already used");
        
        materials[_materialId].isUsed = true;

        emit MaterialUsed(_materialId, msg.sender);
    }

    // Inspection function to be performed by inspectors
    function conductInspection(string memory _inspectionId, string memory _materialId, bool _passedInspection) public onlyInspector {
        require(bytes(materials[_materialId].materialId).length != 0, "Material does not exist");
        require(inspections[_inspectionId].inspectionDate == 0, "Inspection ID already exists");

        inspections[_inspectionId] = Inspection({
            inspectionId: _inspectionId,
            materialId: _materialId,
            inspector: msg.sender,
            inspectionDate: block.timestamp,
            passedInspection: _passedInspection
        });

        emit InspectionConducted(_inspectionId, _materialId, msg.sender, _passedInspection);
    }

    // Function to track material details
    function getMaterialDetails(string memory _materialId) public view returns (string memory, string memory, string memory, address, address, bool) {
        Material memory material = materials[_materialId];
        return (material.materialId, material.materialName, material.expiryDate, material.supplier, material.chef, material.isUsed);
    }

    // Function to get inspection details
    function getInspectionDetails(string memory _inspectionId) public view returns (string memory, string memory, address, uint, bool) {
        Inspection memory inspection = inspections[_inspectionId];
        return (inspection.inspectionId, inspection.materialId, inspection.inspector, inspection.inspectionDate, inspection.passedInspection);
    }

    // Helper function to ensure materials are not resold or expired
    function checkMaterialStatus(string memory _materialId) public view returns (string memory) {
        Material memory material = materials[_materialId];
        if (material.isUsed) {
            return "Material has already been used";
        }
        if (block.timestamp > parseDate(material.expiryDate)) {
            return "Material has expired";
        }
        return "Material is available and in good condition";
    }

    // Function to parse expiry date from string to timestamp (to simplify)
    function parseDate(string memory date) private pure returns (uint256) {
        // Example: Date parsing function, assumes 'YYYYMMDD' format
        bytes memory b = bytes(date);
        uint year = uint(uint8(b[0]) - 48) * 1000 + uint(uint8(b[1]) - 48) * 100 + uint(uint8(b[2]) - 48) * 10 + uint(uint8(b[3]) - 48);
        uint month = uint(uint8(b[4]) - 48) * 10 + uint(uint8(b[5]) - 48);
        uint day = uint(uint8(b[6]) - 48) * 10 + uint(uint8(b[7]) - 48);
        return (year * 365 + month * 30 + day) * 1 days;
    }
}
