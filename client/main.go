// client/main.go
package main

import (
	"bufio"
	"context"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"

	pb "finance-app/proto"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

func main() {
	conn, err := grpc.Dial("localhost:50051", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("failed to connect: %v", err)
	}
	defer conn.Close()

	client := pb.NewFinanceServiceClient(conn)
	reader := bufio.NewReader(os.Stdin)

	for {
		fmt.Println("\n1. Add Cash In")
		fmt.Println("2. Add Cash Out")
		fmt.Println("3. View Balance")
		fmt.Println("4. List Transactions")
		fmt.Println("5. Exit")
		fmt.Print("Choose: ")

		choice, _ := reader.ReadString('\n')
		choice = strings.TrimSpace(choice)

		switch choice {
		case "1", "2":
			txType := "in"
			if choice == "2" {
				txType = "out"
			}

			fmt.Print("Name: ")
			name, _ := reader.ReadString('\n')
			name = strings.TrimSpace(name)

			fmt.Print("Amount: ")
			amountStr, _ := reader.ReadString('\n')
			amount, _ := strconv.ParseFloat(strings.TrimSpace(amountStr), 64)

			resp, err := client.AddTransaction(context.Background(), &pb.AddTransactionRequest{
				Name:   name,
				Amount: amount,
				Type:   txType,
			})
			if err != nil {
				log.Printf("Error: %v", err)
				continue
			}
			fmt.Printf("Added: %s %.2f (%s)\n", resp.Transaction.Name, resp.Transaction.Amount, resp.Transaction.Type)

		case "3":
			resp, _ := client.GetBalance(context.Background(), &pb.Empty{})
			fmt.Printf("Current Balance: %.2f\n", resp.Balance)

		case "4":
			resp, _ := client.ListTransactions(context.Background(), &pb.Empty{})
			for _, tx := range resp.Transactions {
				fmt.Printf("[%s] %s: %.2f\n", tx.Type, tx.Name, tx.Amount)
			}

		case "5":
			return
		}
	}
}
