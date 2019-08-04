//
//  SetGame.swift
//  Set
//
//  Created by Bilguunzaya Battogtokh on 4/16/19.
//  Copyright © 2019 Bilguunzaya Battogtokh. All rights reserved.
//

import Foundation

class SetGame{
    
    //Private variables
    private let maxNumCardsInDeck = 81
    private let maxNumCardSelections = 3
    public let maxNumCardsDealt = 24
    private let matchPts = 3
    private let mismatchPts = -5
    private let deselectionPts = -1
    private let initialNumCardsDealt = 12
    
    
    //Readable variables
    private(set) var score = 0
    private(set) var deck = [SetCard]()
    private(set) var dealtCards = [SetCard]()
    private(set) var selectedCards = [SetCard]()
    private(set) var mismatchedCards = [SetCard]()
    private(set) var matchedCards = [SetCard]()
    private(set) var isThereASetFromDealtCards = false


    
    /*
     Create all and then shuffle 81 unique cards in Set
    */
    private func createDeck(){
        for number in SetCard.Flavor.allCases{
            for shape in SetCard.Flavor.allCases{
                for color in SetCard.Flavor.allCases{
                    for shading in SetCard.Flavor.allCases{
                        deck.append(SetCard(number: number, shape: shape, color: color, shading: shading))
                    }
                }
            }
        }
        deck.shuffle()
        
    }
    
    /*
     Deal cards to user.
     */
    func deal (numberOfCards : Int){
        if (numberOfCards <= deck.count){
            for _ in 0..<numberOfCards{
                dealtCards.append(deck.removeFirst())
            }
        }
    }
    
    /*
        Replace existing card in dealt cards with new card from deck.
    */
    private func replace (card : SetCard){
        if let dealtCardsIndex = dealtCards.firstIndex(of: card){
            if (deck.count >= 1){
                let newCard = deck.removeFirst()
                dealtCards[dealtCardsIndex] = newCard
            }
        }
    }
    
    enum CardStatus {
        case selected
        case matched
        case mismatched
        case normal
    }
    
     func checkCardStatus(for card: SetCard) -> CardStatus{
        
         if (checkIfMatched(for: card) ){
            return CardStatus.matched
        }
        else if (checkIfMismatched(for: card)){
            return CardStatus.mismatched
        }
        else if (checkIfSelected(for: card)){
            return CardStatus.selected
        }
        else{
            return CardStatus.normal
        }
    
        
    }
    
    private func checkIfSelected(for card : SetCard) -> Bool{
        return  selectedCards.firstIndex(of: card) != nil
    }
    
    private func checkIfMatched(for card : SetCard) -> Bool{
         return  matchedCards.firstIndex(of: card) != nil
    }
    
    private func checkIfMismatched(for card : SetCard) -> Bool{
        return  mismatchedCards.firstIndex(of: card) != nil
    }
    
    func shuffleDealtCards(){
        dealtCards.shuffle()
    }
  
    
    private func removeAllSelectedCards(){
        selectedCards.removeAll()
        matchedCards.removeAll()
        mismatchedCards.removeAll()
    }
    
    
    
    
    func replaceOrHideMatchedCards(){
        if (  matchedCards.count <= deck.count  ){
            for card in matchedCards{
                replace(card: card)
            }
        }
        else{
            for card in matchedCards{
                if let idx = dealtCards.firstIndex(of: card){
                    dealtCards.remove(at: idx)
                }
            }
        }
        removeAllSelectedCards()
    }
    
    private func checkSelectedCards() {
        if (selectedCards.count == maxNumCardSelections){
            var setOfNumberValues = Set<SetCard.Flavor>()
            var setOfShapeValues = Set<SetCard.Flavor>()
            var setOfColorValues = Set<SetCard.Flavor>()
            var setOfShadingValues = Set<SetCard.Flavor>()
            for card in selectedCards{
                setOfNumberValues.insert(card.number)
                setOfShapeValues.insert(card.shape)
                setOfColorValues.insert(card.color)
                setOfShadingValues.insert(card.shading)
            }
            func checkSet (set : Set<SetCard.Flavor>) -> Bool{
                return (set.count == 1 || set.count == selectedCards.count)
            }
            
            let isSet =  (checkSet(set:setOfNumberValues) && checkSet(set: setOfShapeValues) && checkSet(set: setOfColorValues) &&
                checkSet(set: setOfShadingValues))
            
            if (isSet){
                matchedCards.append(contentsOf: selectedCards)
                score += matchPts

            }
            else{
                mismatchedCards.append(contentsOf: selectedCards)
                score += mismatchPts
            }
     
        }
    }
    
    func chooseCard(at chosenIndex : Int){
        let card = dealtCards[chosenIndex]
        if let selectionIndex = selectedCards.firstIndex(of : card){
            if (selectedCards.count < maxNumCardSelections){
                selectedCards.remove(at: selectionIndex)
                score += deselectionPts
            }
            else{
                if matchedCards.firstIndex(of: card) != nil{
                    replaceOrHideMatchedCards()
                    removeAllSelectedCards()
                }
                else{
                    removeAllSelectedCards()
                    selectedCards.append(card)
                }
                
            }
        }
        
        else{
            if (selectedCards.count < maxNumCardSelections){
                selectedCards.append(card)
            }
            else{
                if (isThereASetFromDealtCards){
                    isThereASetFromDealtCards = false
                    replaceOrHideMatchedCards()
                    removeAllSelectedCards()
                    selectedCards.append(card)
                }else{
                    removeAllSelectedCards()
                    selectedCards.append(card)
                }
                
            }
            
        }
        checkSelectedCards()

    }
    
    init(){
        createDeck()
        assert(deck.count == maxNumCardsInDeck)
        deal(numberOfCards: initialNumCardsDealt)
        assert(dealtCards.count == initialNumCardsDealt)
    }
    
}




