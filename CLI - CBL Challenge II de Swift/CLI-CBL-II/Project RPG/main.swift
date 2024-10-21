import Foundation

// Definição da classe Personagem
class Personagem {
    var nome: String
    var vida: Int
    var ataque: Int
    var defesa: Int
    var estaDefendendo: Bool = false

    init(nome: String, vida: Int, ataque: Int, defesa: Int) {
        self.nome = nome
        self.vida = vida
        self.ataque = ataque
        self.defesa = defesa
    }

    func receberDano(_ dano: Int) {
        var danoRecebido = dano
        if estaDefendendo {
            danoRecebido -= defesa
            danoRecebido = max(danoRecebido, 0)
            estaDefendendo = false
            print("\(nome) está defendendo e reduziu o dano para \(danoRecebido).")
        }
        vida -= danoRecebido
        print("\(nome) recebeu \(danoRecebido) de dano. Vida restante: \(vida)")
    }

    func atacarAlvo(_ alvo: Personagem) {
        print("\(nome) atacou \(alvo.nome) com \(ataque) de dano.")
        alvo.receberDano(ataque)
    }

    func defender() {
        estaDefendendo = true
        print("\(nome) está defendendo neste turno.")
    }

    func usarPocaoAtaque() {
        let aumentoAtaque = 10
        ataque += aumentoAtaque
        print("\(nome) usou uma poção de aumento de ataque! Ataque aumentado em \(aumentoAtaque). Ataque atual: \(ataque)")
    }
}

// Função para obter a entrada do usuário
func obterEntrada() -> String {
    guard let input = readLine() else {
        return ""
    }
    return input.lowercased()
}

// Inicialização dos personagens
let jogador = Personagem(nome: "Kaiky", vida: 100, ataque: 20, defesa: 10)
let inimigo = Personagem(nome: "Francisco", vida: 100, ataque: 20, defesa: 5)

print("=== Batalha Iniciada ===")
print("\(jogador.nome): \(jogador.vida) HP")
print("\(inimigo.nome): \(inimigo.vida) HP\n")

// Loop principal do jogo
while jogador.vida > 0 && inimigo.vida > 0 {
    print("Escolha uma ação:")
    print("1. Atacar")
    print("2. Defender")
    print("3. Usar Poção de Ataque")
    print("Digite 1, 2 ou 3:")

    let escolha = obterEntrada()

    switch escolha {
    case "1":
        jogador.atacarAlvo(inimigo)
    case "2":
        jogador.defender()
    case "3":
        jogador.usarPocaoAtaque()
    default:
        print("Escolha inválida. Por favor, tente novamente.")
        continue
    }

    // Verifica se o inimigo foi derrotado
    if inimigo.vida <= 0 {
        print("\n\(inimigo.nome) foi derrotado! Você venceu!")
        break
    }

    // Turno do inimigo
    print("\nTurno do \(inimigo.nome):")
    // Simples IA: Inimigo sempre ataca
    let acaoInimigo = "ataque"
    inimigo.atacarAlvo(jogador)

    // Verifica se o jogador foi derrotado
    if jogador.vida <= 0 {
        print("\n\(jogador.nome) foi derrotado! Você perdeu!")
        break
    }

    print("\nStatus Atual:")
    print("\(jogador.nome): \(jogador.vida) HP")
    print("\(inimigo.nome): \(inimigo.vida) HP\n")
}

// Fim do jogo
print("=== Batalha Encerrada ===")
