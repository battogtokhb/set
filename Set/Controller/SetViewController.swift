//
//  SetViewController.swift
//  Animated Set
//
//  Created by Bilguunzaya Battogtokh on 5/10/19.
//  Copyright © 2019 Bilguunzaya Battogtokh. All rights reserved.
//

import UIKit

class SetViewController: UIViewController, UIDynamicAnimatorDelegate {
    
    private let gridAspectRatio = CGFloat(0.7)
    private lazy var deckHeight = view.bounds.height / 7
    private lazy var deckWidth = CGFloat(0.7) * deckHeight
    private let deckAngle = CGFloat(CGFloat.pi / 8)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutDeckViews()
        let swipe = UITapGestureRecognizer(target: self, action: #selector(SetViewController.addThreeCards))
        dealDeck.addGestureRecognizer(swipe)
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.layoutDeckViews()
            self.cardContainerView.layoutIfNeeded()
            self.cardContainerView.layoutCards()
        }
        
    }
    
    private lazy var animator = UIDynamicAnimator(referenceView: self.view)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardContainerView.addPlayingCards(numCards: 12)
        discardDeck.alpha = 0
        updateViewFromModel()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutDeckViews()
        
    }
    
    
    var discardDeckFrame : CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    
    private lazy var discardDeck = createDeck(text: "", color : #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1))
    
    private lazy var dealDeck = createDeck(text: "+ 3", color : #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1))
    
    
    private func createDeck(text: String, color : UIColor) -> DeckView{
        let deck = DeckView()
        deck.deckText = text
        deck.deckColor = color
        
        view.addSubview(deck)
        return deck
    }
    
    private func layoutDeckViews(){
        discardDeck.transform = CGAffineTransform.identity
        
        discardDeck.frame = CGRect(x: view.bounds.minX, y: view.bounds.maxY - 1.0 * deckHeight  , width: deckWidth, height: deckHeight)
        
        /* Need to get dec, frame with proper location & size before we transform */
        self.discardDeckFrame = discardDeck.frame
        
        cardContainerView.discardDeckFrame = view.convert(discardDeck.frame, to: cardContainerView)
        
        
        discardDeck.transform = CGAffineTransform.identity.rotated(by: deckAngle)
        
        dealDeck.transform = CGAffineTransform.identity
        
        dealDeck.frame = CGRect(x: view.bounds.maxX - deckWidth, y: view.bounds.maxY - 1.0 * deckHeight  , width: deckWidth, height: deckHeight)
        
        /* Need to get dec, frame with proper location & size before we transform */
        
        cardContainerView.dealDeckFrame = view.convert(dealDeck.frame, to: cardContainerView)
        
        
        dealDeck.transform = CGAffineTransform.identity.rotated(by: 2 * .pi - deckAngle)
        
        
        
        
    }
    
    private weak var timer: Timer?
    
    private var game = SetGame()
    
    /* Wait until we've fully dealed out cards to deal out new cards */
    
    private lazy var grid = Grid(layout: .aspectRatio(gridAspectRatio))
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cardLeftLabel: UILabel!
    
    @IBOutlet weak var cardContainerView: SetCardContainerView!
    
    
    @objc private func addThreeCards(){
        if (ableToDealMoreCards()){
            cardContainerView.addPlayingCards(numCards: 3)
            game.deal(numberOfCards: 3)
            updateViewFromModel()
        }
    }
    
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
        cardContainerView.clearPlayingCards()
        cardContainerView.removeAllViews()
        discardDeck.alpha = 0
        game = SetGame()
        cardContainerView.addPlayingCards(numCards: 12)
        updateViewFromModel()
    }
    
    
    var flyingCards = [SetCardView]()
    
    private func ableToDealMoreCards() -> Bool{
        return game.deck.count >= 3
    }
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        print("animator pause")
        animator.delegate = nil
        
        
        
        self.cardContainerView.layoutIfNeeded()
        self.discardDeck.alpha = 0
        
        
        if let topCard = cardContainerView.discardedCards.last{
            UIView.transition(with:
                topCard ,duration: 0.3, options: .transitionFlipFromLeft, animations: {
                    topCard.isFaceUp = false
                    
            },
                         completion: {finished in
                            self.discardDeck.alpha = 1
                            self.cardContainerView.removeDiscardedCards()
            }
                
            )
        }
        
        
        
    }
    
    
    
    
    @IBAction func touchCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state{
        case .ended:
            let loc = recognizer.location(in: cardContainerView)
            
            if let touched = cardContainerView.hitTest(loc, with: nil){
                if let card = touched as? SetCardView{
                    if let index = cardContainerView.playingCards.firstIndex(of: card){
                        game.chooseCard(at: index)
                        updateViewFromModel()
                    }
                }
                
                
            }
            
            
        default: break
        }
    }
    
    
    private func updateViewFromModel(){
        updateCardViews()
        scoreLabel.text = "Score: \(game.score)"
        cardLeftLabel.text = "Cards Left: \(game.deck.count + game.dealtCards.count)"
        if ( !ableToDealMoreCards() ){
            dealDeck.deckColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            
        }
        else{
            dealDeck.deckColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
        }
        
    }
    
    private func cardToView(_ card: SetCard) -> SetCardView  {
        //let cardView = Set
        let cardView =  SetCardView(card: card, status: game.checkCardStatus(for: card) )
        
        let result = cardContainerView.playingCards.filter{$0.shape == cardView.shape && $0.number == cardView.number && $0.shading == cardView.shading && $0.shapeColor == cardView.shapeColor }
        
        if !result.isEmpty{
            result[0].status = game.checkCardStatus(for: card)
            
            return result[0]
        }
        else{
            cardView.isFaceUp = false
            cardView.toDeal = true
            cardView.alpha = 0
            
            return cardView
        }
        
        
    }
    
    
    private func updateCardViews(){
        print ("in update card views: \(game.dealtCards.count), \(cardContainerView.subviews.count), \(cardContainerView.discardedCards.count), \(cardContainerView.playingCards.count)")
        
        cardContainerView.layoutIfNeeded()
        
        var cards = [SetCardView]()
        for card in game.dealtCards{
            let cardView = cardToView(card)
            cards.append(cardView)
        }
        
        cardContainerView.clearPlayingCards()
        
        cardContainerView.playingCards = cards
        cardContainerView.layoutIfNeeded()
        cardContainerView.layoutCards()
        
        if !cardContainerView.matchedCards.isEmpty{
            checkMatchedCards( cards: cardContainerView.matchedCards)
            game.replaceOrHideMatchedCards()
            updateViewFromModel()
        }
        
    }
    
    private func replaceMatchedCards(){
        game.replaceOrHideMatchedCards()
        if (ableToDealMoreCards()){
            cardContainerView.matchedCards.forEach {
                $0.isFaceUp = false
                $0.toDeal = true
            }
        }
        updateViewFromModel()
    }
    
    func addSnapBehavior(item : SetCardView){
        
        let snap = UISnapBehavior(item: item, snapTo: self.discardDeckFrame.center)
        snap.action = { [unowned self] in
            item.transform = CGAffineTransform.identity.rotated(by: self.deckAngle)
        }
        
        animator.addBehavior(snap)
    }
    
    var snappedCards = [SetCardView]()
    
   
    
    func checkMatchedCards( cards: [SetCardView]){
        
        cardContainerView.removePlayingCards(cards: cards)
        cardContainerView.discardedCards += cards
        
        
        animator.delegate = self
    
        let fly = flyAwayBehavior(items : cards)
        
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
            
            for (_, card) in self.cardContainerView.discardedCards.enumerated(){
                
                fly.remove(item: card )
                self.animator.removeBehavior(fly)
               // if (!card.frame.intersects(self.discardDeckFrame)){
                     self.addSnapBehavior(item: card)
               // }
               
                
                
                
                
            }
            
        }
        
        print ("im in check matched cards")
        
    }
    
    private func flyAwayBehavior(items : [SetCardView]) -> FlyAwayBehavior {
        
        let flyaway = FlyAwayBehavior(items: items)
        animator.addBehavior(flyaway)
        return flyaway
    }
    
    
    
    private struct Animation {
        static let flipDuration = 0.5
        static let fadeAwayDuration = 0.6
        static let showMatchDuration = 0.6
        static let matchedGrowthFactor: CGFloat = 2.5
        static let matchedShrinkFactor: CGFloat = 0.1
    }
    
    
}




