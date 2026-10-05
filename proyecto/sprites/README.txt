SPRITES ENEMIGO ESTÁTICO - GODOT

Archivos:
- enemy_estatico.png -> enemigo estático, 64x64
- enemy_estatico_spritesheet.png -> igual, 64x64
- llama_1.png ... llama_4.png -> 4 frames de llama, 32x32
- llama_spritesheet_4frames.png -> los 4 frames en horizontal, 128x32

Importación recomendada:
- Texture Filter: Nearest
- Texture Repeat: Disabled

Para la llama animada puedes usar AnimatedSprite2D y crear una SpriteFrames
con los 4 archivos llama_1.png ... llama_4.png a 8-12 FPS.

Todos los PNG tienen fondo transparente.
