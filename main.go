package main

import (
	"log"

	"github.com/hajimehoshi/ebiten/v2"
	"github.com/justgook/gosurvive/pkg/game"
)

func main() {
	ebiten.SetWindowSize(640, 480)
	ebiten.SetWindowTitle("Hello, World!")
	setup, err := game.New()
	if err != nil {
		panic(err)
	}
	if err := ebiten.RunGame(setup); err != nil {
		log.Fatal(err)
	}
}

