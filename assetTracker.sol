//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;



contract SupplyChain {

modifier SeulTransporteur () {
require (msg.sender==transporteur, "tu n'es pas transporteur");
    _;
    
}


uint index;
address fournisseur;
address transporteur = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;
address receptioniste=0x583031D1113aD414F02576BD6afaBfb302140225;

enum Approvisionnement {paspret, pret, enRoute, livrer,Receptionner}

constructor (address _fournissuer) {
    fournisseur = _fournissuer;
    produit();
}



struct  VACCIN {
    uint id;
    string typedevaccin;
    Approvisionnement etat;
    address centrehospitalier;
    uint temps;
}

    
mapping (uint => VACCIN) public vaccins;



function produit() public {
    
    VACCIN memory vaccin = VACCIN (index, "entrer un produit", Approvisionnement.paspret,msg.sender, block.timestamp);

    vaccins[index]=vaccin;
    
    }
    
   function createProduit (string memory _typedevaccin, address _centrehospitalier) public {
      require (msg.sender== fournisseur, "tu n'es pas le fournisseur");
      index++;
      vaccins[index]=VACCIN(index, _typedevaccin, Approvisionnement.pret, _centrehospitalier, block.timestamp);
        
        }
    
    function TRANS (uint _index) public SeulTransporteur() {
        
        require (vaccins[_index].etat==Approvisionnement.pret, "ce n'est pas encore pret");
        vaccins[_index].etat=Approvisionnement.enRoute;
    }
    
    function deliver (uint _index) public SeulTransporteur() {
        
        require (vaccins[_index].etat==Approvisionnement.enRoute, "ce n'est pas en route");
        vaccins[_index].etat=Approvisionnement.livrer;
        
    }
    
    function reception (uint _index) public{
        require(msg.sender==receptioniste, "tu n'es pas receptioniste");
        require (vaccins[_index].etat==Approvisionnement.livrer, "pas encore livrer");
        vaccins[_index].etat=Approvisionnement.Receptionner;
    }
}
