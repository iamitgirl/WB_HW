package client

import (
	"fmt"
	"net/http"
	"strconv"
	"time"
)

func SendRequests(clientID int) {
	client := &http.Client{}

	for i := 0; i < 100; i++ {
		req, err := http.NewRequest("POST", "http://localhost:8080", nil)
		if err != nil {
			fmt.Printf("Клиент %d: ошибка создания запроса %v\n", clientID, err)
			continue
		}
		req.Header.Set("X-Client-ID", strconv.Itoa(clientID)) // Добавляем ID клиента

		resp, err := client.Do(req)
		if err != nil {
			fmt.Printf("Клиент %d: ошибка отправки %v\n", clientID, err)
			continue
		}

		fmt.Printf("Клиент %d получил ответ: %d\n", clientID, resp.StatusCode)
		resp.Body.Close()
		time.Sleep(200 * time.Millisecond) // Ограничение скорости
	}
}

func CheckServer() {
	for {
		resp, err := http.Get("http://localhost:8080/stats")
		if err != nil {
			fmt.Println("Сервер недоступен")
		} else {
			fmt.Println("Сервер доступен")
			resp.Body.Close()
		}
		time.Sleep(5 * time.Second)
	}
}
