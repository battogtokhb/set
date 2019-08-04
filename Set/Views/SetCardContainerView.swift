//
//  SetCardContainerView.swift
//  Animated Set
//
//  Created by Bilguunzaya Battogtokh on 5/10/19.
//  Copyright © 2019 Bilguunzaya Battogtokh. All rights reserved.
//

import UIKit

class SetCardContainerView: UIView {
    
    private var grid = Grid(layout: .aspectRatio(CGFloat(0.7)))
    
    
    var discardedCards = [SetCardView](){
        didSet{
            discardedCards.forEach{
                super.addSubview($0)
            }
            setNeedsLayout()
        }
    }
    
    
    var playingCards = [SetCardView](){
        didSet{
            playingCards.forEach{
                super.addSubview($0)
            }
            setNeedsLayout()
        }
    }
    
    
    
    
    var dealDeckFrame : CGRect = CGRect(x: 0, y: 0, width: 0, height: 0){
        didSet{
            setNeedsLayout()
            //layoutCards()
        }
    }
    
    var discardDeckFrame : CGRect = CGRect(x: 0, y: 0, width: 0, height: 0){
        didSet{
            setNeedsLayout()
        }
    }
    
    func layoutDiscardedCards() {
        discardedCards.forEach{
            $0.transform = .identity
            
            $0.frame = discardDeckFrame
            $0.transform = CGAffineTransform.identity.rotated(by:  Animation.deckAngle)
            
        }
        
        
        
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    func layoutCards (){
        
        layoutIfNeeded()
        layoutDiscardedCards()
        
        grid.frame = bounds
        grid.cellCount = self.playingCards.count
        
        playingCards.forEach{
            if $0.toDeal{
                $0.alpha = 0
            }
        }
        
        print ("in layout cards: \(playingCards.count)")
        
        /* Rearrangement of cards animation. */
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: Animation.layoutDuration,
            delay: 0,
            options: [],
            animations: {
                for (i, card) in self.playingCards.enumerated(){
                    if let cardFrame = self.grid[i]{
                        card.frame = cardFrame.zoom(by: 0.95)
                    self.layoutIfNeeded()
                        
                    }
                }
        },
            completion: {finished in self.animateDealtCards() }
        )
    }
    
    
    func addPlayingCards(numCards : Int){
        let cards = (0..<numCards).map { _ in SetCardView()}
        
        for card in cards{
            card.clipsToBounds = false
            card.isFaceUp = false
            card.toDeal = true
            card.alpha = 0
            addSubview(card)
        }
        self.playingCards += cards
        layoutIfNeeded()
    }
    
    private var dealtCardsToAnimate : [SetCardView]{
        return playingCards.filter{$0.toDeal == true}
    }
    
    var matchedCards : [SetCardView]{
        return playingCards.filter{$0.status == .matched}
    }
    
    func animateDealtCards(){
        
        guard dealtCardsToAnimate.count > 0 else { return}
        layoutIfNeeded()
        
        grid.frame = bounds
        grid.cellCount = self.playingCards.count
        print ("in animateDealtCards: \(dealtCardsToAnimate.count)")
        dealtCardsToAnimate.forEach{
            $0.transform = CGAffineTransform.identity
            
            $0.frame = dealDeckFrame
            $0.alpha = 1
            $0.transform = CGAffineTransform.identity.rotated(by: 2 * .pi - Animation.deckAngle)
        }
        
        for (index, card) in dealtCardsToAnimate.enumerated(){
            let delay = Animation.dealDelay * Double(index)
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: Animation.dealDuration,
                delay: delay,
                options: [],
                animations: {
                    if let idx = self.playingCards.firstIndex(of: card), let cardFrame = self.grid[idx]{
                        card.transform = .identity
                        card.frame = cardFrame.zoom(by: 0.95)
                        card.toDeal = false
                        
                        
                        
                    }
            },
                completion: {position in
                    UIView.transition(with:
                        card ,duration: Animation.flipDuration, options: .transitionFlipFromLeft, animations: {
                            card.isFaceUp = true
                            
                    },
                              completion: { finished in  card.toDeal = false})
            }
            )
            
        }
        
        
        
    }
    
    
    func removeDiscardedCards(){
        discardedCards.forEach{
            
            if let idx = discardedCards.firstIndex(of: $0), $0.frame.intersects(discardDeckFrame) {
                $0.removeFromSuperview()
                print ("removed")
                discardedCards.remove(at: idx)
            }
            
        }
        
    }
    
    
    func removePlayingCards(cards: [SetCardView]){
        cards.forEach{
            if let idx = self.playingCards.firstIndex(of: $0){
                self.playingCards.remove(at: idx)
                
            }
            $0.removeFromSuperview()
        }
    }
    
    func clearPlayingCards(){
        print ("in clear")
        
        for card in playingCards {
            card.removeFromSuperview()
        }
        self.playingCards = []
        setNeedsLayout()
    }
    
    func removeAllViews() {
        for sub in subviews{
            sub.removeFromSuperview()
        }
        playingCards = []
        discardedCards = []
    }
    
    private struct Animation {
        static let layoutDuration = 0.3
        static let dealDuration = 0.3
        static let flipDuration = 0.3
        static let dealDelay = 0.4
        static let deckAngle = CGFloat( CGFloat.pi / 8)
    }
    
    
    
    
    
    
}
