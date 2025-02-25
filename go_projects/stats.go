package main

import (
	"encoding/json"
	"fmt"
	"os"
	"sync"
)

func saveStats(stats map[int]map[int]int, mu *sync.Mutex) {
	mu.Lock()
	defer mu.Unlock()

	file, err := os.Create("stats.json")
	if err != nil {
		fmt.Println("Ошибка сохранения статистики:", err)
		return
	}
	defer file.Close()

	json.NewEncoder(file).Encode(stats)
	fmt.Println("Статистика сохранена в stats.json")
}
