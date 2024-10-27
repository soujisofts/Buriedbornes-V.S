import Foundation

// Estrutura para representar um inimigo
struct Enemy {
    let name: String
    var health: Int
    let damage: Int
    let isBoss: Bool
}

// Estrutura para representar o jogador
struct Player {
    var health: Int
    var attack: Int
    var defense: Int
    var dodgeChance: Int
    var items: [Item]
    
    mutating func takeDamage(_ damage: Int) {
        let mitigatedDamage = max(0, damage - defense)
        if Int.random(in: 1...100) <= dodgeChance {
            print("Você esquivou do ataque!")
        } else {
            health -= mitigatedDamage
            print("Você recebeu \(mitigatedDamage) de dano após mitigação!")
        }
        if health < 0 { health = 0 }
    }
    
    mutating func heal(_ amount: Int) {
        health += amount
        if health > 100 { health = 100 }
    }
}

// Estrutura para representar um item
enum ItemType {
    case sword
    case armor
    case healthPotion
    case attackBoost
    case dodgeBoost
}

struct Item {
    let name: String
    let type: ItemType
    let value: Int
}

// Função para exibir a barra de vida do jogador
func displayHealthBar(_ health: Int) {
    let healthBar = String(repeating: "█", count: health / 10)
    let emptyBar = String(repeating: "░", count: 10 - (health / 10))
    print("Vida: [\(healthBar)\(emptyBar)] \(health)/100")
}

// Função para gerar um inimigo comum
func randomEnemy() -> Enemy {
    let enemies = [
        Enemy(name: "Goblin", health: 30, damage: 10, isBoss: false),
        Enemy(name: "Esqueleto", health: 25, damage: 8, isBoss: false),
        Enemy(name: "Lobo", health: 35, damage: 12, isBoss: false),
        Enemy(name: "Mago Sombrio", health: 20, damage: 15, isBoss: false)
    ]
    return enemies.randomElement()!
}

// Função para gerar um mini-boss
func miniBoss() -> Enemy {
    return Enemy(name: "Minotauro", health: 100, damage: 25, isBoss: true)
}

// Função para gerar o chefão final
func finalBoss() -> Enemy {
    return Enemy(name: "Dragão Ancião", health: 300, damage: 50, isBoss: true)
}

// Função principal para batalhas
func battle(player: inout Player, enemy: inout Enemy) {
    print("Você encontrou um \(enemy.name) com \(enemy.health) de vida!")
    
    while player.health > 0 && enemy.health > 0 {
        print("\nEscolha sua ação:")
        print("1 - Atacar")
        print("2 - Curar (+10 de vida)")
        print("3 - Fugir")
        print("4 - Usar item")
        
        let action = readLine()
        
        switch action {
        case "1":
            // Ataque
            let damage = Int.random(in: 10...20) + player.attack
            print("Você atacou o \(enemy.name) causando \(damage) de dano!")
            enemy.health -= damage
            
            if enemy.health <= 0 {
                if enemy.isBoss {
                    print("Você derrotou o \(enemy.name)!")
                    let bossItem = randomBossItem()
                    player.items.append(bossItem)
                    print("Você coletou um \(bossItem.name)!")
                } else {
                    print("Você derrotou o \(enemy.name)!")
                    let item = randomItem()
                    player.items.append(item)
                    print("Você coletou um \(item.name)!")
                }
                break
            }
            
            // Contra-ataque do inimigo
            print("\(enemy.name) atacou e causou \(enemy.damage) de dano!")
            player.takeDamage(enemy.damage)
            displayHealthBar(player.health)
            
        case "2":
            // Cura
            print("Você usou uma poção de cura!")
            player.heal(10)
            displayHealthBar(player.health)
            
        case "3":
            // Fugir
            print("Você fugiu da batalha!")
            return
            
        case "4":
            // Usar item
            if player.items.isEmpty {
                print("Você não tem itens para usar!")
            } else {
                print("Seus itens:")
                for (index, item) in player.items.enumerated() {
                    print("\(index + 1) - \(item.name)")
                }
                print("Escolha um item para usar:")
                if let itemChoice = readLine(), let index = Int(itemChoice), index > 0 && index <= player.items.count {
                    let selectedItem = player.items[index - 1]
                    useItem(&player, item: selectedItem)
                    player.items.remove(at: index - 1)
                } else {
                    print("Item inválido!")
                }
            }
            
        default:
            print("Ação inválida, escolha entre 1 a 4.")
        }
        
        if player.health <= 0 {
            print("Você foi derrotado!")
            return
        }
    }
}

// Função para usar um item
func useItem(_ player: inout Player, item: Item) {
    switch item.type {
    case .sword:
        print("Você equipou a espada \(item.name), aumentando seu ataque em \(item.value).")
        player.attack += item.value
    case .armor:
        print("Você equipou a armadura \(item.name), aumentando sua defesa em \(item.value).")
        player.defense += item.value
    case .healthPotion:
        print("Você bebeu a poção de vida \(item.name), curando \(item.value) de vida.")
        player.heal(item.value)
    case .attackBoost:
        print("Você usou o item de aumento de ataque \(item.name), aumentando seu ataque em \(item.value).")
        player.attack += item.value
    case .dodgeBoost:
        print("Você usou o item de aumento de esquiva \(item.name), aumentando sua esquiva em \(item.value)%.")
        player.dodgeChance += item.value
    }
}

// Função para gerar um item aleatório
func randomItem() -> Item {
    let items = [
        Item(name: "Espada de Ferro", type: .sword, value: 5),
        Item(name: "Armadura de Couro", type: .armor, value: 3),
        Item(name: "Poção de Vida", type: .healthPotion, value: 20),
        Item(name: "Aumento de Ataque", type: .attackBoost, value: 4),
        Item(name: "Aumento de Esquiva", type: .dodgeBoost, value: 10)
    ]
    return items.randomElement()!
}

// Função para gerar itens de mini-boss ou chefão
func randomBossItem() -> Item {
    let bossItems = [
        Item(name: "Espada Lendária", type: .sword, value: 20),
        Item(name: "Armadura de Dragão", type: .armor, value: 15),
        Item(name: "Poção Mágica de Vida", type: .healthPotion, value: 50),
        Item(name: "Elixir de Ataque Supremo", type: .attackBoost, value: 10),
        Item(name: "Escudo de Esquiva Suprema", type: .dodgeBoost, value: 20)
    ]
    return bossItems.randomElement()!
}

func startGame() {
    var player = Player(health: 100, attack: 10, defense: 5, dodgeChance: 10, items: [])
    var enemiesDefeated = 0
    
    print("Bem-vindo ao RPG Hardcore!")
    displayHealthBar(player.health)
    
    while player.health > 0 {
        var enemy: Enemy
        enemiesDefeated += 1
        
        // Checamos se o jogador encontrou um mini-boss ou o chefão final
        if enemiesDefeated % 5 == 0 && enemiesDefeated < 20 {
            enemy = miniBoss()
        } else if enemiesDefeated == 20 {
            enemy = finalBoss()
        } else {
            enemy = randomEnemy()
        }
        
        battle(player: &player, enemy: &enemy)
        
        if player.health > 0 && enemiesDefeated < 20 {
            print("\nDeseja continuar explorando? (s/n)")
            if let choice = readLine(), choice.lowercased() != "s" {
                break
            }
        } else if enemiesDefeated == 20 {
            print("\nVocê derrotou o Dragão Ancião! Parabéns, você completou o jogo!")
            break
        }
    }
    
    print("Fim do jogo! Você terminou com \(player.health) de vida, ataque \(player.attack), defesa \(player.defense), esquiva \(player.dodgeChance)% e os itens: \(player.items.map { $0.name }).")
}

// Iniciar o jogo
startGame()
