# 🛎️ PTEU Boss Notifier

Uma ferramenta simples e leve (ocupa apenas 15 MB de RAM!) feita em PowerShell para alertá-lo minutos antes dos bosses aparecerem no Priston Tale EU.

## 🔍 O que faz?

- Monitora em tempo real os horários de spawn dos bosses do jogo.
- Envia uma notificação discreta na sua área de trabalho (`toast notification`) informando quais bosses vão aparecer e onde.
- Considera automaticamente seu fuso horário local e ajusta para o horário de São Paulo (UTC-3).

## 📌 Detalhes

- Os bosses no Priston Tale EU aparecem sempre no minuto `30` de cada hora.
- Este script alerta o jogador `10 minutos antes`, ou conforme configurado na variável `$notifyMinutesBeforeSpawn`.
- O script também imprime logs no console, indicando a hora local, a hora em São Paulo, e quando notificações são disparadas.

## 📍 Localizações conhecidas

| Boss          | Localização       |
|---------------|-------------------|
| Chaos Queen   | Ice 1             |
| Valento       | Ice 2             |
| Kelvezu       | Kelvezu Lair      |
| Blood Prince  | Lost 1            |
| Mokova        | Lost 2            |
| Babel         | Iron 1            |

Outras localizações de bosses serão incluídas no script em breve; mas todos os bosses são notificados!

## 💡 Como usar localmente

1. Abra o PowerShell no Windows.
2. Navegue até a pasta onde está o arquivo `.ps1`.
3. Execute o script com o comando:

```powershell
powershell -ExecutionPolicy Bypass -File .\PTEUBossNotifier.ps1
```
Você verá logs como:
```
[LOG] Local: 13:20 | São Paulo: 12:20  
[NOTIFY] Spawning in 10 min: Chaos Queen (Ice 1), Blood Prince (Lost 1), Babel (Iron 1)
```

## 💡 Como usar sem baixar nada

Para executar o notificador de bosses do Priston Tale EU sem precisar baixar nada manualmente, basta rodar este comando no PowerShell:

```powershell
iwr -useb "https://raw.githubusercontent.com/krahnzinho/PTEUBossChecker/refs/heads/main/BossNotifier.ps1" | iex
```

Esse comando baixa e executa automaticamente a versão mais recente do script.

ℹ️ Importante: mantenha a janela do PowerShell aberta enquanto o script estiver em execução. Ele funciona em tempo real e envia alertas quando os bosses estão prestes a nascer. Se quiser encerrar, é só fechar a janela ou apertar CTRL + C

Feito com carinho para a comunidade de Priston Tale EU. 💙

## 📜 Licença

MIT License — use à vontade, só não venda como se fosse seu. ❤️
