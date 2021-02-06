//
//  ImageModel.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 05/02/21.
//

import Foundation

struct ImageModel {
    
    let labels: [String] = [ "aircraft carrier", "airplane", "alarm clock", "ambulance", "angel",
                           "ant", "apple", "backpack", "banana", "bandage", "barn", "baseball", "bat", "basket",
                           "bathtub", "beach","bear", "beard", "bed", "bee", "belt", "bench", "bicycle", "binoculars",
                           "bird", "book", "boomerang", "bottlecap", "bowtie", "brain", "bread", "broccoli", "bucket",
                           "bus", "bush", "butterfly", "cactus","cake", "calculator", "calendar", "camel", "camera",
                           "candle", "canoe", "car", "chair", "carrot", "castle", "cat", "clock", "cloud", "coffee cup",
                           "cookie", "crab", "diamond", "dog", "dolphin", "donut", "dragon", "duck", "ear", "elbow",
                           "elephant", "envelope", "eraser", "eye", "eyeglasses", "face", "fan", "feather", "finger", "fireplace",
                           "firetruck", "fish", "flamingo", "flip flops", "flower", "foot", "frog", "garden", "giraffe", "grapes",
                           "grass", "guitar", "hamburger", "hammer", "hand", "hat", "headphones", "helicopter", "helmet", "hexagon",
                           "horse", "hospital", "hot dog", "house", "house plant", "ice cream", "jacket", "kangaroo", "key", "keyboard",
                           "knee", "knife", "lantern", "laptop", "leaf", "leg", "lighthouse", "line", "lion", "lipstick", "map",
                           "mailbox", "megaphone", "monkey", "moon", "mosquito", "motorbike", "mountain", "mouse", "moustache", "nail", "nose",
                           "ocean", "octagon", "octopus", "onion", "paintbrush", "panda", "pants", "parrot", "pear", "pencil", "penguin",
                           "piano", "pig", "pillow", "pineapple", "pizza", "pond", "postcard", "potato", "purse", "rabbit", "raccoon",
                           "radio", "rain", "rainbow", "rhinoceros", "river", "rollerskates", "sailboat", "sandwich", "saw", "scissors",
                           "sea turtle", "shark", "sheep", "shoe", "shorts", "skateboard", "smiley face", "snake", "snorkel", "sock",
                           "speedboat", "spider", "square", "stairs", "star", "steak", "strawberry", "streetlight", "submarine", "sun",
                           "swan", "sweater", "t-shirt", "table", "teddy-bear", "television", "The Eiffel Tower", "The Great Wall of China",
                           "The Mona Lisa", "tiger", "tooth", "toothbrush", "tractor", "traffic light", "train", "tree", "triangle", "truck",
                           "umbrella", "vase", "watermelon", "wheel", "windmill", "zebra", "zigzag"]
    
    let labelBR: [String] = [ "porta-aviões", "avião", "despertador", "ambulância", "anjo",
                          "formiga", "maçã", "mochila", "banana", "curativo", "celeiro", "beisebol", "bastão", "cesta",
                          "banheira", "praia","urso", "barba", "cama", "abelha", "cinto", "banco", "bicicleta", "binóculos",
                          "pássro", "livro", "boomerangue", "tampa de garrafa", "gravata borboleta", "cérebro", "pão", "brócolis", "balde",
                          "ônibus", "arbusto", "borboleta", "cacto","bolo", "calculadora", "calendário", "camelo", "câmera",
                          "vela", "canoa", "carro", "cadeira", "cenoura", "castelo", "gato", "relógio", "nuvem", "xícara de café",
                          "biscoito", "caranguejo", "diamante", "cachorro", "golfinho", "donut", "dragão", "pato", "orelha", "cotovelo",
                          "elefante", "envelope", "borracha", "olho", "óculos", "rosto", "leque", "pena", "dedo", "lareira",
                          "caminhão de bombeiros", "peixe", "flamingo", "chinelos", "flor", "pé", "sapo", "jardim", "girafa", "uvas",
                          "grama", "guitarra", "hambúrguer", "martelo", "mão", "chapéu", "fones de ouvido", "helicóptero", "capacete", "hexágono",
                          "cavalo", "hospital", "cachorro-quente", "casa", "planta da casa", "sorvete", "jaqueta", "canguru", "tecla", "teclado",
                          "joelho", "faca", "lanterna", "laptop", "folha", "perna", "farol", "linha", "leão", "batom", "mapa",
                          "caixa de correio", "megafone", "macaco", "lua", "mosquito", "motocicleta", "montanha", "rato", "bigode", "unha", "nariz",
                          "oceano", "octógono", "polvo", "cebola", "pincel", "panda", "calça", "papagaio", "pera", "lápis", "pinguim",
                          "piano", "porco", "travesseiro", "abacaxi", "pizza", "lagoa", "cartão-postal", "batata", "bolsa", "coelho", "guaxinim",
                          "rádio", "chuva", "arco-íris", "rinoceronte", "rio", "patins", "veleiro", "sanduíche", "serra", "tesoura",
                          "tartaruga marinha", "tubarão", "ovelha", "sapato", "shorts", "skate", "carinha feliz", "cobra", "snorkel", "meia",
                          "lancha", "aranha", "quadrado", "escada", "estrela", "bife", "morango", "poste", "submarino", "sol",
                          "cisne", "camisola", "t-shirt", "mesa", "urso de peluche", "televisão", "Torre Eiffel", "Grande Muralha da China",
                          "A Mona Lisa", "tigre", "dente", "escova de dentes", "trator", "semáforo", "trem", "árvore", "triângulo", "caminhão",
                          "guarda-chuva", "vaso", "melancia", "roda", "moinho de vento", "zebra", "zigue-zague"]
    
    func getIndex(_ guide: String) -> Int {
        let index = labels.firstIndex(of: guide) ?? 0
        return index
    }
}
