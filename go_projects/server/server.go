package server

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"sync"
)

var (
	stats = make(map[int]map[int]int) // {clientID: {statusCode: count}}
	mu    sync.Mutex                  // Для потокобезопасного доступа
)

func StartServer(port string) {
	fmt.Println("Запускаем сервер на порту:", port)

	http.HandleFunc("/", handler)
	http.HandleFunc("/stats", statsHandler)

	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		log.Fatal("Ошибка запуска сервера:", err)
	}
}

func handler(w http.ResponseWriter, r *http.Request) {
	clientIDStr := r.Header.Get("X-Client-ID")
	clientID, err := strconv.Atoi(clientIDStr)
	if err != nil || clientID <= 0 {
		http.Error(w, "Некорректный X-Client-ID", http.StatusBadRequest)
		return
	}

	// Генерация случайного статуса ответа
	statuses := []int{http.StatusOK, http.StatusAccepted, http.StatusBadRequest, http.StatusInternalServerError}
	status := statuses[len(stats)%len(statuses)]

	mu.Lock()
	if stats[clientID] == nil {
		stats[clientID] = make(map[int]int)
	}
	stats[clientID][status]++
	mu.Unlock()

	w.WriteHeader(status)
	fmt.Fprintf(w, "Ответ сервера: %d", status)
}

func statsHandler(w http.ResponseWriter, r *http.Request) {
	mu.Lock()
	defer mu.Unlock()

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(stats)
}
