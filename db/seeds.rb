
g1 = Game.create(card_background: 'card_flip.png')
g2 = Game.create(card_background: 'card_flip.png')

Card.create(background: 'card.png',
            face: 'faces/base-african-0001.png',
            eye: 'faces/eyes-hazel-0015.png',
            eyebrow: 'faces/eyebrows-0008.png',
            hair: 'faces/hair-light-brown-0007.png',
            nose: 'faces/nose-0005.png',
            mouth: 'faces/mouth-0014.png',
            game_id: g1.id
)

Card.create(background: 'card.png',
            face: 'faces/base-dark-caucasian-0011.png',
            eye: 'faces/eyes-blue-0015.png',
            eyebrow: 'faces/eyebrows-0004.png',
            hair: 'faces/hair-blonde-0023.png',
            nose: 'faces/nose-0003.png',
            mouth: 'faces/mouth-0004.png',
            game_id: g1.id
)

Card.create(background: 'card.png',
            face: 'faces/base-light-asian-0001.png',
            eye: 'faces/eyes-brown-0005.png',
            eyebrow: 'faces/eyebrows-0007.png',
            hair: 'faces/hair-black-0025.png',
            nose: 'faces/nose-0011.png',
            mouth: 'faces/mouth-0008.png',
            game_id: g2.id
)
