package main

import (
	"log"
	"os"
	"time"

	"go_projects/client" // ✅ Импортируем сервер
	"go_projects/server" // ✅ Импортируем клиент

	"github.com/joho/godotenv"
)

func main() {
	// Загружаем переменные окруженияgo
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Ошибка загрузки .env")
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080" // Значение по умолчанию
	}

	// Запускаем сервер в отдельной горутине
	go server.StartServer(port)

	time.Sleep(2 * time.Second)

	// Запускаем клиентов
	go client.SendRequests(1) // Первый клиент
	go client.SendRequests(2) // Второй клиент
	go client.CheckServer()   // Проверка сервера

	// Ждем завершения работы
	time.Sleep(30 * time.Second)
}
