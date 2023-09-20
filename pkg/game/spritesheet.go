package game

import (
	"bytes"
	"image"
	_ "image/png"

	"github.com/hajimehoshi/ebiten/v2"
	"github.com/hajimehoshi/ebiten/v2/examples/resources/images"
)

// SpriteSheet represents a collection of sprite images.
type SpriteSheet struct {
	Floor  *ebiten.Image
	Wall   *ebiten.Image
	Statue *ebiten.Image
	Tube   *ebiten.Image
	Crown  *ebiten.Image
	Portal *ebiten.Image
}

// LoadSpriteSheet loads the embedded SpriteSheet.
func LoadSpriteSheet(tileSize int) (*SpriteSheet, error) {
	img, _, err := image.Decode(bytes.NewReader(images.Spritesheet_png))
	if err != nil {
		return nil, err
	}

	sheet := ebiten.NewImageFromImage(img)

	// spriteAt returns a sprite at the provided coordinates.
	spriteAt := func(x, y int) *ebiten.Image {
		return sheet.SubImage(image.Rect(x*tileSize, (y+1)*tileSize, (x+1)*tileSize, y*tileSize)).(*ebiten.Image)
	}

	// Populate SpriteSheet.
	s := &SpriteSheet{}
	s.Floor = spriteAt(10, 4)
	s.Wall = spriteAt(2, 3)
	s.Statue = spriteAt(5, 4)
	s.Tube = spriteAt(3, 4)
	s.Crown = spriteAt(8, 6)
	s.Portal = spriteAt(5, 6)

	return s, nil
}

